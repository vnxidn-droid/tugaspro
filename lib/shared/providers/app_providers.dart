import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../features/file_manager/data/datasources/android_file_system_datasource.dart';
import '../../features/file_manager/data/datasources/local_file_system_datasource.dart';
import '../../features/file_manager/data/repositories/file_repository_impl.dart';
import '../../features/file_manager/domain/repositories/file_repository.dart';
import '../../features/storage/data/storage_permission_service.dart';
import '../../features/storage/data/storage_roots_service.dart';

final storagePermissionServiceProvider = Provider<StoragePermissionService>((
  ref,
) {
  return StoragePermissionService();
});

final storageRootsServiceProvider = Provider<StorageRootsService>((ref) {
  return StorageRootsService();
});

final fileSystemDataSourceProvider = Provider<LocalFileSystemDataSource>((ref) {
  if (Platform.isAndroid) return AndroidFileSystemDataSource();
  return LocalFileSystemDataSource();
});

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final dataSource = ref.watch(fileSystemDataSourceProvider);
  return FileRepositoryImpl(
    dataSource,
    dataSource is AndroidFileSystemDataSource
        ? dataSource.roots
        : ref.watch(storageRootsServiceProvider).roots,
  );
});
