package com.example.tugaspro

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import android.webkit.MimeTypeMap
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "tugaspro/android_file_system"
    private var pendingSafResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "permissionStatus" -> result.success(permissionStatus())
                    "requestAllFilesAccess" -> {
                        openAllFilesSettings()
                        result.success(permissionStatus())
                    }
                    "openSafTree" -> openSafTree(result)
                    "roots" -> result.success(roots())
                    "listDirectory" -> result.success(listDirectory(call.arguments as Map<*, *>))
                    "search" -> result.success(search(call.arguments as Map<*, *>))
                    "createFolder" -> {
                        createFolder(call.arguments as Map<*, *>)
                        result.success(true)
                    }
                    "rename" -> {
                        rename(call.arguments as Map<*, *>)
                        result.success(true)
                    }
                    "delete" -> {
                        delete(call.arguments as Map<*, *>)
                        result.success(true)
                    }
                    "copy" -> {
                        copy(call.arguments as Map<*, *>)
                        result.success(true)
                    }
                    "move" -> {
                        move(call.arguments as Map<*, *>)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            } catch (error: Exception) {
                result.error("ANDROID_FS", error.message, null)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 7110) {
            val result = pendingSafResult
            pendingSafResult = null
            if (resultCode == Activity.RESULT_OK && data?.data != null) {
                val uri = data.data!!
                val flags = data.flags and (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                contentResolver.takePersistableUriPermission(uri, flags)
                result?.success(uri.toString())
            } else {
                result?.success(null)
            }
        }
    }

    private fun permissionStatus(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && Environment.isExternalStorageManager()) {
            "granted"
        } else {
            "denied"
        }
    }

    private fun openAllFilesSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
            intent.data = Uri.parse("package:$packageName")
            startActivity(intent)
        } else {
            startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName")))
        }
    }

    private fun openSafTree(result: MethodChannel.Result) {
        pendingSafResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        intent.addFlags(
            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
        )
        startActivityForResult(intent, 7110)
    }

    private fun roots(): List<String> {
        val output = linkedSetOf<String>()
        output.add(Environment.getExternalStorageDirectory().absolutePath)
        File("/storage").listFiles()?.forEach { file ->
            if (file.isDirectory && file.name != "self" && file.canRead()) output.add(file.absolutePath)
        }
        contentResolver.persistedUriPermissions.forEach { permission ->
            if (permission.isReadPermission) output.add(permission.uri.toString())
        }
        return output.toList()
    }

    private fun listDirectory(args: Map<*, *>): Map<String, Any> {
        val path = args["path"] as String
        val offset = args["offset"] as Int
        val limit = args["limit"] as Int
        val sortMode = args["sortMode"] as String
        val ascending = args["ascending"] as Boolean
        val items = if (path.startsWith("content://")) {
            val root = DocumentFile.fromTreeUri(this, Uri.parse(path)) ?: throw IllegalArgumentException("SAF folder not found")
            root.listFiles().mapNotNull { itemFromDocument(it) }
        } else {
            val dir = File(path)
            if (!dir.exists() || !dir.isDirectory) throw IllegalArgumentException("Directory not found")
            dir.listFiles()?.map { itemFromFile(it) } ?: emptyList()
        }.sortedWith(itemComparator(sortMode, ascending))

        val end = (offset + limit).coerceAtMost(items.size)
        val page = if (offset >= items.size) emptyList() else items.subList(offset, end)
        return mapOf("items" to page, "totalCount" to items.size, "hasMore" to (end < items.size))
    }

    private fun search(args: Map<*, *>): List<Map<String, Any?>> {
        val root = args["rootPath"] as String
        val query = (args["query"] as String).lowercase()
        val extension = (args["extension"] as String).lowercase().replace(".", "")
        val recursive = args["recursive"] as Boolean
        val limit = args["limit"] as Int
        val tokens = query.split(Regex("[\\s,;]+")).filter { it.isNotBlank() }
        val extTokens = extension.split(Regex("[\\s,;]+")).filter { it.isNotBlank() }
        val results = mutableListOf<Map<String, Any?>>()

        fun accept(item: Map<String, Any?>): Boolean {
            val haystack = listOf(item["name"], item["path"], item["extension"], item["mimeType"], item["category"])
                .joinToString(" ").lowercase()
            val format = listOf(item["extension"], ".${item["extension"]}", item["mimeType"], item["category"])
                .joinToString(" ").lowercase()
            return tokens.all { haystack.contains(it) } && extTokens.all { format.contains(it) }
        }

        fun walk(file: File) {
            if (results.size >= limit) return
            file.listFiles()?.forEach { child ->
                val item = itemFromFile(child)
                if (accept(item)) results.add(item)
                if (recursive && child.isDirectory) walk(child)
            }
        }

        if (root.startsWith("content://")) {
            val doc = DocumentFile.fromTreeUri(this, Uri.parse(root)) ?: return emptyList()
            fun walkDoc(parent: DocumentFile) {
                if (results.size >= limit) return
                parent.listFiles().forEach { child ->
                    val item = itemFromDocument(child) ?: return@forEach
                    if (accept(item)) results.add(item)
                    if (recursive && child.isDirectory) walkDoc(child)
                }
            }
            walkDoc(doc)
        } else {
            walk(File(root))
        }
        return results
    }

    private fun createFolder(args: Map<*, *>) {
        val parentPath = args["parentPath"] as String
        val name = args["name"] as String
        if (parentPath.startsWith("content://")) {
            val parent = DocumentFile.fromTreeUri(this, Uri.parse(parentPath)) ?: throw IllegalArgumentException("SAF folder not found")
            parent.createDirectory(name) ?: throw IllegalStateException("Cannot create SAF folder")
        } else {
            File(parentPath, name).mkdirs()
        }
    }

    private fun rename(args: Map<*, *>) {
        val path = args["path"] as String
        val newName = args["newName"] as String
        if (path.startsWith("content://")) {
            val doc = DocumentFile.fromSingleUri(this, Uri.parse(path)) ?: DocumentFile.fromTreeUri(this, Uri.parse(path))
            if (doc?.renameTo(newName) != true) throw IllegalStateException("Cannot rename SAF item")
        } else {
            val source = File(path)
            if (!source.renameTo(File(source.parentFile, newName))) throw IllegalStateException("Cannot rename item")
        }
    }

    private fun delete(args: Map<*, *>) {
        val path = args["path"] as String
        if (path.startsWith("content://")) {
            val doc = DocumentFile.fromSingleUri(this, Uri.parse(path)) ?: DocumentFile.fromTreeUri(this, Uri.parse(path))
            if (doc?.delete() != true) throw IllegalStateException("Cannot delete SAF item")
        } else {
            File(path).deleteRecursively()
        }
    }

    private fun copy(args: Map<*, *>) {
        val sources = args["sources"] as List<*>
        val destination = args["destinationDirectory"] as String
        sources.filterIsInstance<String>().forEach { source ->
            val src = File(source)
            val target = uniqueFile(File(destination), src.name)
            if (src.isDirectory) src.copyRecursively(target, overwrite = false) else src.copyTo(target, overwrite = false)
        }
    }

    private fun move(args: Map<*, *>) {
        val sources = args["sources"] as List<*>
        val destination = args["destinationDirectory"] as String
        sources.filterIsInstance<String>().forEach { source ->
            val src = File(source)
            val target = uniqueFile(File(destination), src.name)
            if (!src.renameTo(target)) {
                if (src.isDirectory) src.copyRecursively(target, overwrite = false) else src.copyTo(target, overwrite = false)
                src.deleteRecursively()
            }
        }
    }

    private fun itemFromFile(file: File): Map<String, Any?> {
        val extension = file.extension.lowercase()
        val mediaStore = if (file.isDirectory) null else mediaStoreMetadata(file)
        val mime = if (file.isDirectory) {
            "inode/directory"
        } else {
            mediaStore?.get("mimeType") as? String ?: mimeFor(file.name)
        }
        return mapOf(
            "path" to file.absolutePath,
            "name" to file.name,
            "isDirectory" to file.isDirectory,
            "size" to if (file.isDirectory) 0L else (mediaStore?.get("size") as? Long ?: file.length()),
            "modified" to (mediaStore?.get("modified") as? Long ?: file.lastModified()),
            "extension" to if (file.isDirectory) "" else extension,
            "mimeType" to mime,
            "category" to category(file.isDirectory, extension, mime)
        )
    }

    private fun mediaStoreMetadata(file: File): Map<String, Any?>? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null
        val uri = MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
        val projection = arrayOf(
            MediaStore.Files.FileColumns.MIME_TYPE,
            MediaStore.Files.FileColumns.SIZE,
            MediaStore.Files.FileColumns.DATE_MODIFIED
        )
        val selection = "${MediaStore.Files.FileColumns.DATA}=?"
        val selectionArgs = arrayOf(file.absolutePath)
        return try {
            contentResolver.query(uri, projection, selection, selectionArgs, null)?.use { cursor ->
                if (!cursor.moveToFirst()) return null
                val modifiedSeconds = cursor.getLong(2)
                mapOf(
                    "mimeType" to cursor.getString(0),
                    "size" to cursor.getLong(1),
                    "modified" to modifiedSeconds * 1000L
                )
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun itemFromDocument(doc: DocumentFile): Map<String, Any?>? {
        val name = doc.name ?: return null
        val extension = name.substringAfterLast('.', "").lowercase()
        val mime = if (doc.isDirectory) "inode/directory" else doc.type ?: mimeFor(name)
        return mapOf(
            "path" to doc.uri.toString(),
            "name" to name,
            "isDirectory" to doc.isDirectory,
            "size" to if (doc.isDirectory) 0L else doc.length(),
            "modified" to doc.lastModified(),
            "extension" to if (doc.isDirectory) "" else extension,
            "mimeType" to mime,
            "category" to category(doc.isDirectory, extension, mime)
        )
    }

    private fun itemComparator(sortMode: String, ascending: Boolean): Comparator<Map<String, Any?>> {
        val comparator = Comparator<Map<String, Any?>> { a, b ->
            val ad = a["isDirectory"] as Boolean
            val bd = b["isDirectory"] as Boolean
            if (ad != bd) return@Comparator if (ad) -1 else 1
            when (sortMode) {
                "size" -> (a["size"] as Long).compareTo(b["size"] as Long)
                "modified" -> (a["modified"] as Long).compareTo(b["modified"] as Long)
                "type" -> (a["extension"] as String).compareTo(b["extension"] as String)
                else -> (a["name"] as String).lowercase().compareTo((b["name"] as String).lowercase())
            }
        }
        return if (ascending) comparator else comparator.reversed()
    }

    private fun mimeFor(name: String): String {
        val ext = name.substringAfterLast('.', "").lowercase()
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext)
            ?: if (ext == "apk") "application/vnd.android.package-archive" else "application/octet-stream"
    }

    private fun category(isDirectory: Boolean, extension: String, mime: String): String {
        if (isDirectory) return "directory"
        if (extension == "apk") return "apk"
        if (extension == "pdf") return "pdf"
        if (mime.startsWith("image/")) return "image"
        if (mime.startsWith("video/")) return "video"
        if (mime.startsWith("audio/")) return "audio"
        if (setOf("zip", "rar", "7z", "tar", "gz").contains(extension)) return "archive"
        if (setOf("txt", "md", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "json", "xml", "csv").contains(extension)) return "document"
        return "other"
    }

    private fun uniqueFile(directory: File, name: String): File {
        var target = File(directory, name)
        val base = name.substringBeforeLast('.', name)
        val ext = name.substringAfterLast('.', "")
        var counter = 1
        while (target.exists()) {
            target = File(directory, if (ext.isEmpty()) "$base ($counter)" else "$base ($counter).$ext")
            counter++
        }
        return target
    }
}
