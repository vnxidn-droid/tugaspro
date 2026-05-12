import '../../../storage/data/storage_permission_service.dart';
import '../../domain/entities/file_item.dart';

class FileManagerState {
  const FileManagerState({
    required this.roots,
    required this.currentPath,
    required this.items,
    required this.selectedPaths,
    required this.backStack,
    required this.forwardStack,
    required this.sortMode,
    required this.ascending,
    required this.permissionStatus,
    required this.isLoading,
    required this.isSearching,
    required this.hasMore,
    required this.totalCount,
    required this.pageSize,
    required this.gridView,
    required this.recursiveSearch,
    required this.searchQuery,
    required this.extensionFilter,
    this.clipboard,
    this.errorMessage,
    this.safRoot,
  });

  factory FileManagerState.initial() => const FileManagerState(
    roots: [],
    currentPath: '',
    items: [],
    selectedPaths: {},
    backStack: [],
    forwardStack: [],
    sortMode: SortMode.name,
    ascending: true,
    permissionStatus: StoragePermissionStatus.denied,
    isLoading: false,
    isSearching: false,
    hasMore: false,
    totalCount: 0,
    pageSize: 80,
    gridView: false,
    recursiveSearch: false,
    searchQuery: '',
    extensionFilter: '',
  );

  final List<String> roots;
  final String currentPath;
  final List<FileItem> items;
  final Set<String> selectedPaths;
  final List<String> backStack;
  final List<String> forwardStack;
  final SortMode sortMode;
  final bool ascending;
  final StoragePermissionStatus permissionStatus;
  final bool isLoading;
  final bool isSearching;
  final bool hasMore;
  final int totalCount;
  final int pageSize;
  final bool gridView;
  final bool recursiveSearch;
  final String searchQuery;
  final String extensionFilter;
  final FileClipboard? clipboard;
  final String? errorMessage;
  final String? safRoot;

  bool get selectionMode => selectedPaths.isNotEmpty;

  FileManagerState copyWith({
    List<String>? roots,
    String? currentPath,
    List<FileItem>? items,
    Set<String>? selectedPaths,
    List<String>? backStack,
    List<String>? forwardStack,
    SortMode? sortMode,
    bool? ascending,
    StoragePermissionStatus? permissionStatus,
    bool? isLoading,
    bool? isSearching,
    bool? hasMore,
    int? totalCount,
    int? pageSize,
    bool? gridView,
    bool? recursiveSearch,
    String? searchQuery,
    String? extensionFilter,
    FileClipboard? clipboard,
    bool clearClipboard = false,
    String? errorMessage,
    bool clearError = false,
    String? safRoot,
  }) {
    return FileManagerState(
      roots: roots ?? this.roots,
      currentPath: currentPath ?? this.currentPath,
      items: items ?? this.items,
      selectedPaths: selectedPaths ?? this.selectedPaths,
      backStack: backStack ?? this.backStack,
      forwardStack: forwardStack ?? this.forwardStack,
      sortMode: sortMode ?? this.sortMode,
      ascending: ascending ?? this.ascending,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
      gridView: gridView ?? this.gridView,
      recursiveSearch: recursiveSearch ?? this.recursiveSearch,
      searchQuery: searchQuery ?? this.searchQuery,
      extensionFilter: extensionFilter ?? this.extensionFilter,
      clipboard: clearClipboard ? null : clipboard ?? this.clipboard,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      safRoot: safRoot ?? this.safRoot,
    );
  }
}
