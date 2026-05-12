import '../../domain/entities/directory_page.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/local_file_system_datasource.dart';

class FileRepositoryImpl implements FileRepository {
  FileRepositoryImpl(this._dataSource, this._storageRoots);

  final LocalFileSystemDataSource _dataSource;
  final Future<List<String>> Function() _storageRoots;

  @override
  Future<List<String>> storageRoots() => _storageRoots();

  @override
  Future<FileItem> metadata(String path) => _dataSource.metadata(path);

  @override
  Future<DirectoryPage> listDirectory(
    String path, {
    required int offset,
    required int limit,
    required SortMode sortMode,
    required bool ascending,
  }) {
    return _dataSource.listDirectory(
      path,
      offset: offset,
      limit: limit,
      sortMode: sortMode,
      ascending: ascending,
    );
  }

  @override
  Future<List<FileItem>> search(
    String rootPath, {
    required String query,
    required String extension,
    required bool recursive,
    required int limit,
  }) {
    return _dataSource.search(
      rootPath,
      query: query,
      extension: extension,
      recursive: recursive,
      limit: limit,
    );
  }

  @override
  Future<void> createFolder(String parentPath, String name) {
    return _dataSource.createFolder(parentPath, name);
  }

  @override
  Future<void> rename(String path, String newName) {
    return _dataSource.rename(path, newName);
  }

  @override
  Future<void> delete(String path) => _dataSource.delete(path);

  @override
  Future<void> copy(List<String> sources, String destinationDirectory) {
    return _dataSource.copy(sources, destinationDirectory);
  }

  @override
  Future<void> move(List<String> sources, String destinationDirectory) {
    return _dataSource.move(sources, destinationDirectory);
  }
}
