import '../entities/directory_page.dart';
import '../entities/file_item.dart';

abstract class FileRepository {
  Future<List<String>> storageRoots();

  Future<FileItem> metadata(String path);

  Future<DirectoryPage> listDirectory(
    String path, {
    required int offset,
    required int limit,
    required SortMode sortMode,
    required bool ascending,
  });

  Future<List<FileItem>> search(
    String rootPath, {
    required String query,
    required String extension,
    required bool recursive,
    required int limit,
  });

  Future<void> createFolder(String parentPath, String name);

  Future<void> rename(String path, String newName);

  Future<void> delete(String path);

  Future<void> copy(List<String> sources, String destinationDirectory);

  Future<void> move(List<String> sources, String destinationDirectory);
}
