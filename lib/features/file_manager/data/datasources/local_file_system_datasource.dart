import 'dart:io';
import 'dart:isolate';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../../../core/errors/file_manager_exception.dart';
import '../../domain/entities/directory_page.dart';
import '../../domain/entities/file_item.dart';

class LocalFileSystemDataSource {
  LocalFileSystemDataSource();

  final Map<String, _CachedDirectory> _cache = {};

  Future<FileItem> metadata(String path) async {
    try {
      final type = await FileSystemEntity.type(path, followLinks: false);
      if (type == FileSystemEntityType.notFound) {
        throw const FileManagerException('File not found');
      }
      return _entityToItem(path, type);
    } on FileManagerException {
      rethrow;
    } catch (error) {
      throw FileManagerException('Failed to read metadata', error);
    }
  }

  Future<DirectoryPage> listDirectory(
    String path, {
    required int offset,
    required int limit,
    required SortMode sortMode,
    required bool ascending,
  }) async {
    try {
      final key = '$path|${sortMode.name}|$ascending';
      final directory = Directory(path);
      if (!await directory.exists()) {
        throw const FileManagerException('Directory not found');
      }

      final stat = await directory.stat();
      final cached = _cache[key];
      if (cached != null && cached.modified == stat.modified) {
        return _pageFrom(cached.items, offset, limit);
      }

      final rawPaths = await directory
          .list(followLinks: false)
          .map((entity) => entity.path)
          .toList();
      final items = await Isolate.run(() => _buildItems(rawPaths));
      _sortItems(items, sortMode, ascending);
      _cache[key] = _CachedDirectory(items: items, modified: stat.modified);
      return _pageFrom(items, offset, limit);
    } on FileManagerException {
      rethrow;
    } catch (error) {
      throw FileManagerException('Failed to list directory', error);
    }
  }

  Future<List<FileItem>> search(
    String rootPath, {
    required String query,
    required String extension,
    required bool recursive,
    required int limit,
  }) async {
    try {
      return Isolate.run(
        () => _searchFiles(
          SearchRequest(
            rootPath: rootPath,
            query: query,
            extension: extension,
            recursive: recursive,
            limit: limit,
          ),
        ),
      );
    } catch (error) {
      throw FileManagerException('Search failed', error);
    }
  }

  Future<void> createFolder(String parentPath, String name) async {
    try {
      final cleanName = name.trim();
      if (cleanName.isEmpty || cleanName.contains(Platform.pathSeparator)) {
        throw const FileManagerException('Invalid folder name');
      }
      await Directory(p.join(parentPath, cleanName)).create();
      _cache.clear();
    } catch (error) {
      throw FileManagerException('Failed to create folder', error);
    }
  }

  Future<void> rename(String path, String newName) async {
    try {
      final cleanName = newName.trim();
      if (cleanName.isEmpty || cleanName.contains(Platform.pathSeparator)) {
        throw const FileManagerException('Invalid name');
      }
      final destination = p.join(p.dirname(path), cleanName);
      final type = await FileSystemEntity.type(path, followLinks: false);
      if (type == FileSystemEntityType.directory) {
        await Directory(path).rename(destination);
      } else {
        await File(path).rename(destination);
      }
      _cache.clear();
    } catch (error) {
      throw FileManagerException('Failed to rename item', error);
    }
  }

  Future<void> delete(String path) async {
    try {
      final type = await FileSystemEntity.type(path, followLinks: false);
      if (type == FileSystemEntityType.notFound) return;
      if (type == FileSystemEntityType.directory) {
        await Directory(path).delete(recursive: true);
      } else {
        await File(path).delete();
      }
      _cache.clear();
    } catch (error) {
      throw FileManagerException('Failed to delete item', error);
    }
  }

  Future<void> copy(List<String> sources, String destinationDirectory) async {
    try {
      for (final source in sources) {
        final destination = await _uniquePath(
          destinationDirectory,
          p.basename(source),
        );
        final type = await FileSystemEntity.type(source, followLinks: false);
        if (type == FileSystemEntityType.directory) {
          await _copyDirectory(Directory(source), Directory(destination));
        } else {
          await File(source).copy(destination);
        }
      }
      _cache.clear();
    } catch (error) {
      throw FileManagerException('Failed to copy item', error);
    }
  }

  Future<void> move(List<String> sources, String destinationDirectory) async {
    try {
      for (final source in sources) {
        final destination = await _uniquePath(
          destinationDirectory,
          p.basename(source),
        );
        try {
          final type = await FileSystemEntity.type(source, followLinks: false);
          if (type == FileSystemEntityType.directory) {
            await Directory(source).rename(destination);
          } else {
            await File(source).rename(destination);
          }
        } on FileSystemException {
          final type = await FileSystemEntity.type(source, followLinks: false);
          if (type == FileSystemEntityType.directory) {
            await _copyDirectory(Directory(source), Directory(destination));
            await Directory(source).delete(recursive: true);
          } else {
            await File(source).copy(destination);
            await File(source).delete();
          }
        }
      }
      _cache.clear();
    } catch (error) {
      throw FileManagerException('Failed to move item', error);
    }
  }
}

class _CachedDirectory {
  const _CachedDirectory({required this.items, required this.modified});

  final List<FileItem> items;
  final DateTime modified;
}

class SearchRequest {
  const SearchRequest({
    required this.rootPath,
    required this.query,
    required this.extension,
    required this.recursive,
    required this.limit,
  });

  final String rootPath;
  final String query;
  final String extension;
  final bool recursive;
  final int limit;
}

DirectoryPage _pageFrom(List<FileItem> items, int offset, int limit) {
  final safeOffset = offset.clamp(0, items.length);
  final end = (safeOffset + limit).clamp(0, items.length);
  return DirectoryPage(
    items: items.sublist(safeOffset, end),
    totalCount: items.length,
    hasMore: end < items.length,
  );
}

List<FileItem> _buildItems(List<String> paths) {
  final items = <FileItem>[];
  for (final path in paths) {
    try {
      final type = FileSystemEntity.typeSync(path, followLinks: false);
      if (type == FileSystemEntityType.notFound) continue;
      items.add(_entityToItemSync(path, type));
    } catch (_) {
      // Skip entries that cannot be read because of permissions or races.
    }
  }
  return items;
}

List<FileItem> _searchFiles(SearchRequest request) {
  final root = Directory(request.rootPath);
  if (!root.existsSync()) return const [];

  final queryTokens = _searchTokens(request.query);
  final extensionTokens = _searchTokens(request.extension.replaceAll('.', ' '));
  final results = <FileItem>[];
  final entities = root.listSync(
    recursive: request.recursive,
    followLinks: false,
  );
  for (final entity in entities) {
    if (results.length >= request.limit) break;
    try {
      final type = FileSystemEntity.typeSync(entity.path, followLinks: false);
      final item = _entityToItemSync(entity.path, type);
      final matchesQuery =
          queryTokens.isEmpty || _matchesSmartQuery(item, queryTokens);
      final matchesExtension =
          extensionTokens.isEmpty || _matchesFormatQuery(item, extensionTokens);
      if (matchesQuery && matchesExtension) {
        results.add(item);
      }
    } catch (_) {
      // Search must be resilient across protected directories.
    }
  }
  _sortItems(results, SortMode.name, true);
  return results;
}

List<String> _searchTokens(String input) {
  return input
      .toLowerCase()
      .trim()
      .split(RegExp(r'[\s,;]+'))
      .where((token) => token.isNotEmpty)
      .toList();
}

bool _matchesSmartQuery(FileItem item, List<String> tokens) {
  final haystack = [
    item.name,
    item.path,
    item.extension,
    item.mimeType,
    item.category.name,
  ].join(' ').toLowerCase();

  return tokens.every(
    (token) => haystack.contains(token) || _fileContentContains(item, token),
  );
}

bool _matchesFormatQuery(FileItem item, List<String> tokens) {
  final formatHaystack = [
    item.extension,
    '.${item.extension}',
    item.mimeType,
    item.category.name,
  ].join(' ').toLowerCase();

  return tokens.every(formatHaystack.contains);
}

bool _fileContentContains(FileItem item, String token) {
  if (item.isDirectory || token.length < 2 || !_isSearchableTextFile(item)) {
    return false;
  }

  final file = File(item.path);
  try {
    if (!file.existsSync() || file.lengthSync() > 1024 * 1024) return false;
    final content = file.readAsStringSync().toLowerCase();
    return content.contains(token);
  } catch (_) {
    return false;
  }
}

bool _isSearchableTextFile(FileItem item) {
  if (item.mimeType.startsWith('text/')) return true;
  return const {
    'txt',
    'md',
    'json',
    'xml',
    'csv',
    'log',
    'yaml',
    'yml',
    'dart',
    'java',
    'kt',
    'gradle',
    'html',
    'css',
    'js',
    'ts',
    'sh',
  }.contains(item.extension);
}

Future<FileItem> _entityToItem(String path, FileSystemEntityType type) async {
  final stat = await FileStat.stat(path);
  return _itemFromStat(path, type, stat);
}

FileItem _entityToItemSync(String path, FileSystemEntityType type) {
  final stat = FileStat.statSync(path);
  return _itemFromStat(path, type, stat);
}

FileItem _itemFromStat(String path, FileSystemEntityType type, FileStat stat) {
  final isDirectory = type == FileSystemEntityType.directory;
  final extension = isDirectory
      ? ''
      : p.extension(path).replaceFirst('.', '').toLowerCase();
  final mimeType = isDirectory
      ? 'inode/directory'
      : lookupMimeType(path) ?? _mimeFallback(extension);
  return FileItem(
    path: path,
    name: p.basename(path),
    isDirectory: isDirectory,
    size: isDirectory ? 0 : stat.size,
    modified: stat.modified,
    extension: extension,
    mimeType: mimeType,
    category: _categoryFor(isDirectory, extension, mimeType),
  );
}

FileCategory _categoryFor(bool isDirectory, String extension, String mimeType) {
  if (isDirectory) return FileCategory.directory;
  if (extension == 'apk') return FileCategory.apk;
  if (extension == 'pdf') return FileCategory.pdf;
  if (mimeType.startsWith('image/')) return FileCategory.image;
  if (mimeType.startsWith('video/')) return FileCategory.video;
  if (mimeType.startsWith('audio/')) return FileCategory.audio;
  if (['zip', 'rar', '7z', 'tar', 'gz'].contains(extension)) {
    return FileCategory.archive;
  }
  if ([
    'txt',
    'md',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'json',
    'xml',
    'csv',
  ].contains(extension)) {
    return FileCategory.document;
  }
  return FileCategory.other;
}

String _mimeFallback(String extension) {
  if (extension == 'apk') return 'application/vnd.android.package-archive';
  if (extension == 'pdf') return 'application/pdf';
  return 'application/octet-stream';
}

void _sortItems(List<FileItem> items, SortMode sortMode, bool ascending) {
  int compare(FileItem a, FileItem b) {
    if (a.isDirectory != b.isDirectory) return a.isDirectory ? -1 : 1;
    switch (sortMode) {
      case SortMode.name:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case SortMode.size:
        return a.size.compareTo(b.size);
      case SortMode.modified:
        return a.modified.compareTo(b.modified);
      case SortMode.type:
        return a.extension.compareTo(b.extension);
    }
  }

  items.sort((a, b) => ascending ? compare(a, b) : compare(b, a));
}

Future<String> _uniquePath(String directory, String name) async {
  var destination = p.join(directory, name);
  if (!await FileSystemEntity.isDirectory(destination) &&
      !await File(destination).exists()) {
    return destination;
  }
  final extension = p.extension(name);
  final base = extension.isEmpty
      ? name
      : name.substring(0, name.length - extension.length);
  var counter = 1;
  while (await FileSystemEntity.type(destination, followLinks: false) !=
      FileSystemEntityType.notFound) {
    destination = p.join(directory, '$base ($counter)$extension');
    counter++;
  }
  return destination;
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(
    recursive: false,
    followLinks: false,
  )) {
    final target = p.join(destination.path, p.basename(entity.path));
    if (entity is Directory) {
      await _copyDirectory(entity, Directory(target));
    } else if (entity is File) {
      await entity.copy(target);
    }
  }
}
