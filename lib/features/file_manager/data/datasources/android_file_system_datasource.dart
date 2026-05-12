import 'package:flutter/services.dart';

import '../../domain/entities/directory_page.dart';
import '../../domain/entities/file_item.dart';
import 'local_file_system_datasource.dart';

class AndroidFileSystemDataSource extends LocalFileSystemDataSource {
  AndroidFileSystemDataSource();

  static const MethodChannel _channel = MethodChannel(
    'tugaspro/android_file_system',
  );

  Future<List<String>> roots() async {
    final result = await _channel.invokeListMethod<String>('roots');
    return result ?? const [];
  }

  @override
  Future<FileItem> metadata(String path) async {
    final parent = path.contains('/')
        ? path.substring(0, path.lastIndexOf('/'))
        : path;
    final page = await listDirectory(
      parent,
      offset: 0,
      limit: 10000,
      sortMode: SortMode.name,
      ascending: true,
    );
    return page.items.firstWhere((item) => item.path == path);
  }

  @override
  Future<DirectoryPage> listDirectory(
    String path, {
    required int offset,
    required int limit,
    required SortMode sortMode,
    required bool ascending,
  }) async {
    final result = await _channel
        .invokeMapMethod<String, dynamic>('listDirectory', {
          'path': path,
          'offset': offset,
          'limit': limit,
          'sortMode': sortMode.name,
          'ascending': ascending,
        });
    final rawItems = (result?['items'] as List? ?? const []);
    return DirectoryPage(
      items: rawItems.map(_itemFromNative).toList(),
      totalCount: (result?['totalCount'] as num?)?.toInt() ?? rawItems.length,
      hasMore: result?['hasMore'] == true,
    );
  }

  @override
  Future<List<FileItem>> search(
    String rootPath, {
    required String query,
    required String extension,
    required bool recursive,
    required int limit,
  }) async {
    final result = await _channel.invokeListMethod<dynamic>('search', {
      'rootPath': rootPath,
      'query': query,
      'extension': extension,
      'recursive': recursive,
      'limit': limit,
    });
    return (result ?? const []).map(_itemFromNative).toList();
  }

  @override
  Future<void> createFolder(String parentPath, String name) {
    return _channel.invokeMethod<void>('createFolder', {
      'parentPath': parentPath,
      'name': name,
    });
  }

  @override
  Future<void> rename(String path, String newName) {
    return _channel.invokeMethod<void>('rename', {
      'path': path,
      'newName': newName,
    });
  }

  @override
  Future<void> delete(String path) {
    return _channel.invokeMethod<void>('delete', {'path': path});
  }

  @override
  Future<void> copy(List<String> sources, String destinationDirectory) {
    return _channel.invokeMethod<void>('copy', {
      'sources': sources,
      'destinationDirectory': destinationDirectory,
    });
  }

  @override
  Future<void> move(List<String> sources, String destinationDirectory) {
    return _channel.invokeMethod<void>('move', {
      'sources': sources,
      'destinationDirectory': destinationDirectory,
    });
  }
}

FileItem _itemFromNative(dynamic value) {
  final map = Map<String, dynamic>.from(value as Map);
  final modifiedMs = (map['modified'] as num?)?.toInt() ?? 0;
  final categoryName = map['category'] as String? ?? 'other';
  return FileItem(
    path: map['path'] as String? ?? '',
    name: map['name'] as String? ?? '',
    isDirectory: map['isDirectory'] == true,
    size: (map['size'] as num?)?.toInt() ?? 0,
    modified: DateTime.fromMillisecondsSinceEpoch(modifiedMs),
    extension: map['extension'] as String? ?? '',
    mimeType: map['mimeType'] as String? ?? 'application/octet-stream',
    category: FileCategory.values.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => FileCategory.other,
    ),
  );
}
