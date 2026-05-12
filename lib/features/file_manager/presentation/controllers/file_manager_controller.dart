import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../core/errors/file_manager_exception.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../storage/data/storage_permission_service.dart';
import '../../domain/entities/file_item.dart';
import 'file_manager_state.dart';

final fileManagerControllerProvider =
    NotifierProvider<FileManagerController, FileManagerState>(
      FileManagerController.new,
    );

class FileManagerController extends Notifier<FileManagerState> {
  @override
  FileManagerState build() => FileManagerState.initial();

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final permission = await ref
          .read(storagePermissionServiceProvider)
          .check();
      final roots = await ref.read(fileRepositoryProvider).storageRoots();
      final start = roots.isNotEmpty ? roots.first : '';
      state = state.copyWith(
        roots: roots,
        currentPath: start,
        permissionStatus: permission,
        isLoading: false,
      );
      if (start.isNotEmpty) await openDirectory(start, pushHistory: false);
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Initialize failed', error, stack);
      state = state.copyWith(isLoading: false, errorMessage: '$error');
    }
  }

  Future<void> requestPermission() async {
    final permission = await ref
        .read(storagePermissionServiceProvider)
        .request();
    state = state.copyWith(permissionStatus: permission);
    if (permission == StoragePermissionStatus.granted ||
        permission == StoragePermissionStatus.limited) {
      final roots = await ref.read(fileRepositoryProvider).storageRoots();
      state = state.copyWith(roots: roots);
      if (state.currentPath.isEmpty && roots.isNotEmpty) {
        await openDirectory(roots.first, pushHistory: false);
      } else {
        await refresh();
      }
    }
  }

  Future<void> requestAllFilesAccess() async {
    final permission = await ref
        .read(storagePermissionServiceProvider)
        .requestAllFilesAccess();
    state = state.copyWith(permissionStatus: permission);
    if (permission == StoragePermissionStatus.granted) {
      final roots = await ref.read(fileRepositoryProvider).storageRoots();
      state = state.copyWith(roots: roots);
      if (state.currentPath.isEmpty && roots.isNotEmpty) {
        await openDirectory(roots.first, pushHistory: false);
      } else {
        await refresh();
      }
    }
  }

  Future<void> chooseSafRoot() async {
    final directory = await ref
        .read(storagePermissionServiceProvider)
        .requestSafDirectory();
    if (directory == null) return;
    final roots = {...state.roots, directory}.toList();
    state = state.copyWith(roots: roots, safRoot: directory);
    await openDirectory(directory);
  }

  Future<void> openSettings() {
    return ref.read(storagePermissionServiceProvider).openSettings();
  }

  Future<void> openDirectory(String path, {bool pushHistory = true}) async {
    if (path.isEmpty) return;
    final backStack = pushHistory && state.currentPath.isNotEmpty
        ? [...state.backStack, state.currentPath]
        : state.backStack;
    state = state.copyWith(
      currentPath: path,
      items: [],
      selectedPaths: {},
      backStack: backStack,
      forwardStack: pushHistory ? [] : state.forwardStack,
      isLoading: true,
      isSearching: false,
      searchQuery: '',
      extensionFilter: '',
      clearError: true,
    );
    await _loadPage(reset: true);
  }

  Future<void> refresh() async {
    if (state.currentPath.isEmpty) return;
    await _loadPage(reset: true);
  }

  Future<void> loadMore() => _loadPage(reset: false);

  Future<void> _loadPage({required bool reset}) async {
    if (state.currentPath.isEmpty) return;
    if (!reset && !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final offset = reset ? 0 : state.items.length;
      final page = await ref
          .read(fileRepositoryProvider)
          .listDirectory(
            state.currentPath,
            offset: offset,
            limit: state.pageSize,
            sortMode: state.sortMode,
            ascending: state.ascending,
          );
      state = state.copyWith(
        items: reset ? page.items : [...state.items, ...page.items],
        totalCount: page.totalCount,
        hasMore: page.hasMore,
        isLoading: false,
      );
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Directory load failed', error, stack);
      state = state.copyWith(isLoading: false, errorMessage: '$error');
    }
  }

  Future<void> goBack() async {
    if (state.backStack.isEmpty) return;
    final previous = state.backStack.last;
    state = state.copyWith(
      backStack: state.backStack.sublist(0, state.backStack.length - 1),
      forwardStack: [...state.forwardStack, state.currentPath],
    );
    await openDirectory(previous, pushHistory: false);
  }

  Future<void> goForward() async {
    if (state.forwardStack.isEmpty) return;
    final next = state.forwardStack.last;
    state = state.copyWith(
      forwardStack: state.forwardStack.sublist(
        0,
        state.forwardStack.length - 1,
      ),
      backStack: [...state.backStack, state.currentPath],
    );
    await openDirectory(next, pushHistory: false);
  }

  Future<void> goUp() async {
    final parent = p.dirname(state.currentPath);
    if (parent == state.currentPath || parent == '.') return;
    await openDirectory(parent);
  }

  Future<void> openBreadcrumb(int index) async {
    final separator = p.separator;
    final parts = state.currentPath
        .split(RegExp(r'[\\/]'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return;
    final prefix = state.currentPath.startsWith(separator) ? separator : '';
    final target = '$prefix${parts.take(index + 1).join(separator)}';
    await openDirectory(target);
  }

  void toggleViewMode() {
    state = state.copyWith(gridView: !state.gridView);
  }

  Future<void> setSortMode(SortMode mode) async {
    state = state.copyWith(sortMode: mode);
    await refresh();
  }

  Future<void> toggleSortDirection() async {
    state = state.copyWith(ascending: !state.ascending);
    await refresh();
  }

  void toggleSelection(FileItem item) {
    final selected = {...state.selectedPaths};
    selected.contains(item.path)
        ? selected.remove(item.path)
        : selected.add(item.path);
    state = state.copyWith(selectedPaths: selected);
  }

  void clearSelection() => state = state.copyWith(selectedPaths: {});

  void selectAllVisible() {
    state = state.copyWith(
      selectedPaths: state.items.map((item) => item.path).toSet(),
    );
  }

  Future<void> createFolder(String name) async {
    try {
      if (state.currentPath.isEmpty) {
        throw const FileManagerException(
          'Open a writable folder before creating a new folder',
        );
      }
      await ref
          .read(fileRepositoryProvider)
          .createFolder(state.currentPath, name);
      await refresh();
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Create folder failed', error, stack);
      state = state.copyWith(errorMessage: '$error');
    }
  }

  Future<void> renameItem(FileItem item, String newName) async {
    try {
      await ref.read(fileRepositoryProvider).rename(item.path, newName);
      await refresh();
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Rename failed', error, stack);
      state = state.copyWith(errorMessage: '$error');
    }
  }

  Future<void> deleteSelected() async {
    final paths = state.selectedPaths.toList();
    try {
      for (final path in paths) {
        await ref.read(fileRepositoryProvider).delete(path);
      }
      clearSelection();
      await refresh();
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Delete failed', error, stack);
      state = state.copyWith(errorMessage: '$error');
    }
  }

  void copySelected() {
    state = state.copyWith(
      clipboard: FileClipboard(
        paths: state.selectedPaths.toList(),
        mode: ClipboardMode.copy,
      ),
      selectedPaths: {},
    );
  }

  void moveSelected() {
    state = state.copyWith(
      clipboard: FileClipboard(
        paths: state.selectedPaths.toList(),
        mode: ClipboardMode.move,
      ),
      selectedPaths: {},
    );
  }

  Future<void> pasteClipboard() async {
    final clipboard = state.clipboard;
    if (clipboard == null || state.currentPath.isEmpty) return;
    try {
      if (clipboard.mode == ClipboardMode.copy) {
        await ref
            .read(fileRepositoryProvider)
            .copy(clipboard.paths, state.currentPath);
      } else {
        await ref
            .read(fileRepositoryProvider)
            .move(clipboard.paths, state.currentPath);
      }
      state = state.copyWith(
        clearClipboard: clipboard.mode == ClipboardMode.move,
      );
      await refresh();
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Paste failed', error, stack);
      state = state.copyWith(errorMessage: '$error');
    }
  }

  Future<void> shareSelected() async {
    final files = state.selectedPaths.map((path) => XFile(path)).toList();
    if (files.isEmpty) return;
    await SharePlus.instance.share(ShareParams(files: files));
  }

  Future<void> search({
    required String query,
    required String extension,
    required bool recursive,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSearching: query.trim().isNotEmpty || extension.trim().isNotEmpty,
      searchQuery: query,
      extensionFilter: extension,
      recursiveSearch: recursive,
      clearError: true,
    );
    try {
      if (!state.isSearching) {
        await refresh();
        return;
      }
      final results = await ref
          .read(fileRepositoryProvider)
          .search(
            state.currentPath,
            query: query.trim(),
            extension: extension.trim(),
            recursive: recursive,
            limit: 1000,
          );
      state = state.copyWith(
        items: results,
        totalCount: results.length,
        hasMore: false,
        isLoading: false,
      );
    } catch (error, stack) {
      AppLogger.fileSystem.warning('Search failed', error, stack);
      state = state.copyWith(isLoading: false, errorMessage: '$error');
    }
  }
}
