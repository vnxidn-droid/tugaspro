import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/file_formatters.dart';
import '../../../../shared/widgets/bounded_text.dart';
import '../../../media_viewer/presentation/media_viewer_page.dart';
import '../../../search/presentation/search_panel.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../../storage/data/storage_permission_service.dart';
import '../../domain/entities/file_item.dart';
import '../controllers/file_manager_controller.dart';
import '../controllers/file_manager_state.dart';

class FileManagerPage extends ConsumerStatefulWidget {
  const FileManagerPage({super.key});

  @override
  ConsumerState<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends ConsumerState<FileManagerPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _extensionController = TextEditingController();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(fileManagerControllerProvider.notifier).initialize(),
    );
    _scrollController.addListener(() {
      final state = ref.read(fileManagerControllerProvider);
      if (_scrollController.position.extentAfter < 360 &&
          state.hasMore &&
          !state.isLoading) {
        ref.read(fileManagerControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _extensionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileManagerControllerProvider);
    ref.listen(
      fileManagerControllerProvider.select((value) => value.errorMessage),
      (_, next) {
        if (next == null || next.isEmpty) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next)));
      },
    );

    final wide = MediaQuery.sizeOf(context).width >= 920;
    final body = switch (_page) {
      0 => _ExplorerView(
        state: state,
        scrollController: _scrollController,
        onOpen: _openItem,
        onCreateFolder: _createFolder,
        onRename: _renameItem,
        onDelete: _confirmDelete,
      ),
      1 => _SearchView(
        state: state,
        queryController: _searchController,
        extensionController: _extensionController,
        onOpen: _openItem,
      ),
      _ => _SettingsView(state: state),
    };

    return Scaffold(
      appBar: AppBar(
        title: const BoundedText(
          'TugasPro File Manager',
          icon: Icons.folder_copy_rounded,
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(fileManagerControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: state.gridView ? 'List view' : 'Grid view',
            onPressed: () => ref
                .read(fileManagerControllerProvider.notifier)
                .toggleViewMode(),
            icon: Icon(
              state.gridView
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              selectedIndex: _page,
              onDestinationSelected: (index) => setState(() => _page = index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.account_tree_rounded),
                  label: Text('Files'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search_rounded),
                  label: Text('Search'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.tune_rounded),
                  label: Text('Settings'),
                ),
              ],
            ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _page,
              onDestinationSelected: (index) => setState(() => _page = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.account_tree_rounded),
                  label: 'Files',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_rounded),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.tune_rounded),
                  label: 'Settings',
                ),
              ],
            ),
      bottomSheet: state.selectionMode
          ? _SelectionActionBar(onDelete: _confirmDelete)
          : null,
    );
  }

  void _openItem(FileItem item) {
    if (ref.read(fileManagerControllerProvider).selectionMode) {
      ref.read(fileManagerControllerProvider.notifier).toggleSelection(item);
      return;
    }
    if (item.isDirectory) {
      ref.read(fileManagerControllerProvider.notifier).openDirectory(item.path);
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MediaViewerPage(item: item)));
  }

  Future<void> _createFolder() async {
    final name = await _textDialog(
      title: 'Create folder',
      label: 'Folder name',
    );
    if (name == null) return;
    await ref.read(fileManagerControllerProvider.notifier).createFolder(name);
  }

  Future<void> _renameItem(FileItem item) async {
    final name = await _textDialog(
      title: 'Rename',
      label: 'New name',
      initial: item.name,
    );
    if (name == null) return;
    await ref
        .read(fileManagerControllerProvider.notifier)
        .renameItem(item, name);
  }

  Future<void> _confirmDelete() async {
    final state = ref.read(fileManagerControllerProvider);
    if (state.selectedPaths.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const BoundedText(
          'Delete selected items?',
          icon: Icons.warning_rounded,
        ),
        content: BoundedText(
          '${state.selectedPaths.length} item will be deleted recursively when it is a folder.',
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(fileManagerControllerProvider.notifier).deleteSelected();
    }
  }

  Future<String?> _textDialog({
    required String title,
    required String label,
    String initial = '',
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) =>
          _TextInputDialog(title: title, label: label, initial: initial),
    );
    if (result == null || result.trim().isEmpty) return null;
    return result.trim();
  }
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.label,
    required this.initial,
  });

  final String title;
  final String label;
  final String initial;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BoundedText(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }
}

class _ExplorerView extends ConsumerWidget {
  const _ExplorerView({
    required this.state,
    required this.scrollController,
    required this.onOpen,
    required this.onCreateFolder,
    required this.onRename,
    required this.onDelete,
  });

  final FileManagerState state;
  final ScrollController scrollController;
  final ValueChanged<FileItem> onOpen;
  final VoidCallback onCreateFolder;
  final ValueChanged<FileItem> onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(fileManagerControllerProvider.notifier);
    return Column(
      children: [
        _PermissionBanner(state: state),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              IconButton.filledTonal(
                onPressed: state.backStack.isEmpty ? null : controller.goBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              IconButton.filledTonal(
                onPressed: state.forwardStack.isEmpty
                    ? null
                    : controller.goForward,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
              IconButton.filledTonal(
                onPressed: controller.goUp,
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
              FilledButton.icon(
                onPressed: onCreateFolder,
                icon: const Icon(Icons.create_new_folder_rounded),
                label: const Text('New folder'),
              ),
              FilledButton.tonalIcon(
                onPressed: state.clipboard == null
                    ? null
                    : controller.pasteClipboard,
                icon: const Icon(Icons.content_paste_rounded),
                label: Text(
                  state.clipboard == null
                      ? 'Paste'
                      : 'Paste ${state.clipboard!.paths.length}',
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: controller.selectAllVisible,
                icon: const Icon(Icons.select_all_rounded),
                label: const Text('Select visible'),
              ),
            ],
          ),
        ),
        _RootBar(state: state),
        _BreadcrumbBar(state: state),
        _SortBar(state: state),
        Expanded(
          child: state.items.isEmpty && !state.isLoading
              ? _EmptyDirectory(onCreateFolder: onCreateFolder)
              : state.gridView
              ? _FileGrid(
                  state: state,
                  controller: scrollController,
                  onOpen: onOpen,
                  onRename: onRename,
                )
              : _FileList(
                  state: state,
                  controller: scrollController,
                  onOpen: onOpen,
                  onRename: onRename,
                ),
        ),
        if (state.isLoading) const LinearProgressIndicator(minHeight: 3),
      ],
    );
  }
}

class _SearchView extends ConsumerWidget {
  const _SearchView({
    required this.state,
    required this.queryController,
    required this.extensionController,
    required this.onOpen,
  });

  final FileManagerState state;
  final TextEditingController queryController;
  final TextEditingController extensionController;
  final ValueChanged<FileItem> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(fileManagerControllerProvider.notifier);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SearchPanel(
            queryController: queryController,
            extensionController: extensionController,
            recursive: state.recursiveSearch,
            onRecursiveChanged: (_) => controller.search(
              query: queryController.text,
              extension: extensionController.text,
              recursive: !state.recursiveSearch,
            ),
            onSearch: () => controller.search(
              query: queryController.text,
              extension: extensionController.text,
              recursive: state.recursiveSearch,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: BoundedText(
                  'Root: ${state.currentPath}',
                  icon: Icons.folder_rounded,
                ),
              ),
              const SizedBox(width: 8),
              BoundedText(
                '${state.totalCount} results',
                icon: Icons.list_alt_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _FileList(
            state: state,
            controller: null,
            onOpen: onOpen,
            onRename: (_) {},
          ),
        ),
        if (state.isLoading) const LinearProgressIndicator(minHeight: 3),
      ],
    );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView({required this.state});

  final FileManagerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final controller = ref.read(fileManagerControllerProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _SettingsCard(
          icon: Icons.security_rounded,
          title: 'Storage permission',
          subtitle: _permissionLabel(state.permissionStatus),
          trailing: FilledButton.icon(
            onPressed: controller.requestPermission,
            icon: const Icon(Icons.lock_open_rounded),
            label: const Text('Request'),
          ),
        ),
        _SettingsCard(
          icon: Icons.folder_special_rounded,
          title: 'All files access',
          subtitle:
              'Trigger MANAGE_EXTERNAL_STORAGE so TugasPro can manage internal storage folders on Android 11+.',
          trailing: FilledButton.icon(
            onPressed: controller.requestAllFilesAccess,
            icon: const Icon(Icons.admin_panel_settings_rounded),
            label: const Text('Allow all files'),
          ),
        ),
        _SettingsCard(
          icon: Icons.folder_special_rounded,
          title: 'SAF fallback directory',
          subtitle:
              state.safRoot ??
              'Pick a directory when Android all-files access is denied.',
          trailing: FilledButton.tonalIcon(
            onPressed: controller.chooseSafRoot,
            icon: const Icon(Icons.folder_open_rounded),
            label: const Text('Choose'),
          ),
        ),
        _SettingsCard(
          icon: Icons.palette_rounded,
          title: 'Theme mode',
          subtitle: themeMode.name,
          trailing: _ThemeModeChoices(
            selected: themeMode,
            onChanged: ref.read(themeModeProvider.notifier).setThemeMode,
          ),
        ),
        _SettingsCard(
          icon: Icons.storage_rounded,
          title: 'Detected roots',
          subtitle: state.roots.isEmpty
              ? 'No readable storage roots detected.'
              : state.roots.join('\n'),
          trailing: IconButton.filledTonal(
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
        _SettingsCard(
          icon: Icons.info_rounded,
          title: 'Safety model',
          subtitle:
              'Delete is recursive but confirmed. APK files are detected as info only. Search runs off the UI isolate.',
          trailing: IconButton.filledTonal(
            onPressed: controller.openSettings,
            icon: const Icon(Icons.settings_applications_rounded),
          ),
        ),
      ],
    );
  }
}

class _ThemeModeChoices extends StatelessWidget {
  const _ThemeModeChoices({required this.selected, required this.onChanged});

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ThemeChoiceBox(
          label: 'System',
          mode: ThemeMode.system,
          selected: selected == ThemeMode.system,
          onChanged: onChanged,
        ),
        _ThemeChoiceBox(
          label: 'Light',
          mode: ThemeMode.light,
          selected: selected == ThemeMode.light,
          onChanged: onChanged,
        ),
        _ThemeChoiceBox(
          label: 'Dark',
          mode: ThemeMode.dark,
          selected: selected == ThemeMode.dark,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ThemeChoiceBox extends StatelessWidget {
  const _ThemeChoiceBox({
    required this.label,
    required this.mode,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final ThemeMode mode;
  final bool selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionBanner extends ConsumerWidget {
  const _PermissionBanner({required this.state});

  final FileManagerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.permissionStatus == StoragePermissionStatus.granted) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.shield_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: BoundedText(
                  'TugasPro needs storage access to manage files. If denied, choose a folder with SAF fallback.',
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: ref
                    .read(fileManagerControllerProvider.notifier)
                    .requestPermission,
                child: const Text('Allow'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RootBar extends ConsumerWidget {
  const _RootBar({required this.state});

  final FileManagerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final root = state.roots[index];
          return ChoiceChip(
            selected: state.currentPath == root,
            label: Text(root),
            avatar: const Icon(Icons.storage_rounded),
            onSelected: (_) => ref
                .read(fileManagerControllerProvider.notifier)
                .openDirectory(root),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: state.roots.length,
      ),
    );
  }
}

class _BreadcrumbBar extends ConsumerWidget {
  const _BreadcrumbBar({required this.state});

  final FileManagerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = state.currentPath
        .split(RegExp(r'[\\/]'))
        .where((part) => part.isNotEmpty)
        .toList();
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => ActionChip(
          label: Text(parts[index]),
          avatar: const Icon(Icons.chevron_right_rounded),
          onPressed: () => ref
              .read(fileManagerControllerProvider.notifier)
              .openBreadcrumb(index),
        ),
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemCount: parts.length,
      ),
    );
  }
}

class _SortBar extends ConsumerWidget {
  const _SortBar({required this.state});

  final FileManagerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(fileManagerControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: BoundedText(
              '${state.items.length}/${state.totalCount} loaded - ${state.currentPath}',
              icon: Icons.inventory_2_rounded,
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<SortMode>(
            value: state.sortMode,
            items: SortMode.values
                .map(
                  (mode) =>
                      DropdownMenuItem(value: mode, child: Text(mode.label)),
                )
                .toList(),
            onChanged: (mode) {
              if (mode != null) controller.setSortMode(mode);
            },
          ),
          IconButton.filledTonal(
            onPressed: controller.toggleSortDirection,
            icon: Icon(
              state.ascending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileList extends ConsumerWidget {
  const _FileList({
    required this.state,
    required this.controller,
    required this.onOpen,
    required this.onRename,
  });

  final FileManagerState state;
  final ScrollController? controller;
  final ValueChanged<FileItem> onOpen;
  final ValueChanged<FileItem> onRename;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      controller: controller,
      padding: EdgeInsets.fromLTRB(12, 0, 12, state.selectionMode ? 92 : 12),
      itemBuilder: (context, index) => _FileTile(
        item: state.items[index],
        selected: state.selectedPaths.contains(state.items[index].path),
        onOpen: onOpen,
        onRename: onRename,
      ),
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemCount: state.items.length,
    );
  }
}

class _FileGrid extends ConsumerWidget {
  const _FileGrid({
    required this.state,
    required this.controller,
    required this.onOpen,
    required this.onRename,
  });

  final FileManagerState state;
  final ScrollController controller;
  final ValueChanged<FileItem> onOpen;
  final ValueChanged<FileItem> onRename;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final count = width > 1200
        ? 6
        : width > 800
        ? 4
        : 2;
    return GridView.builder(
      controller: controller,
      padding: EdgeInsets.fromLTRB(12, 0, 12, state.selectionMode ? 92 : 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) => _FileTile(
        item: state.items[index],
        selected: state.selectedPaths.contains(state.items[index].path),
        onOpen: onOpen,
        onRename: onRename,
        grid: true,
      ),
      itemCount: state.items.length,
    );
  }
}

class _FileTile extends ConsumerWidget {
  const _FileTile({
    required this.item,
    required this.selected,
    required this.onOpen,
    required this.onRename,
    this.grid = false,
  });

  final FileItem item;
  final bool selected;
  final ValueChanged<FileItem> onOpen;
  final ValueChanged<FileItem> onRename;
  final bool grid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final color = _categoryColor(item.category, scheme);
    final controller = ref.read(fileManagerControllerProvider.notifier);
    final content = grid
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_categoryIcon(item.category), color: color, size: 34),
                  const Spacer(),
                  Checkbox(
                    value: selected,
                    onChanged: (_) => controller.toggleSelection(item),
                  ),
                ],
              ),
              const Spacer(),
              BoundedText(item.name, maxLines: 2),
              const SizedBox(height: 6),
              BoundedText(_metadata(item), maxLines: 2),
            ],
          )
        : Row(
            children: [
              Icon(_categoryIcon(item.category), color: color, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoundedText(item.name, maxLines: 1),
                    const SizedBox(height: 6),
                    BoundedText(_metadata(item), maxLines: 1),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') onRename(item);
                  if (value == 'select') controller.toggleSelection(item);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'select', child: Text('Select')),
                ],
              ),
              Checkbox(
                value: selected,
                onChanged: (_) => controller.toggleSelection(item),
              ),
            ],
          );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onOpen(item),
      onLongPress: () => controller.toggleSelection(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.16)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : scheme.outlineVariant),
        ),
        child: content,
      ),
    );
  }

  String _metadata(FileItem item) {
    final type = item.isDirectory ? 'Folder' : item.mimeType;
    final size = item.isDirectory ? '' : ' - ${formatBytes(item.size)}';
    return '$type$size - ${formatDate(item.modified)}';
  }
}

class _SelectionActionBar extends ConsumerWidget {
  const _SelectionActionBar({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerControllerProvider);
    final controller = ref.read(fileManagerControllerProvider.notifier);
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: BoundedText(
                  '${state.selectedPaths.length} selected',
                  icon: Icons.check_circle_rounded,
                ),
              ),
              IconButton.filledTonal(
                onPressed: controller.copySelected,
                icon: const Icon(Icons.copy_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: controller.moveSelected,
                icon: const Icon(Icons.drive_file_move_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: controller.shareSelected,
                icon: const Icon(Icons.share_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: controller.clearSelection,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoundedText(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  BoundedText(subtitle, maxLines: 4),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(child: trailing),
          ],
        ),
      ),
    );
  }
}

class _EmptyDirectory extends StatelessWidget {
  const _EmptyDirectory({required this.onCreateFolder});

  final VoidCallback onCreateFolder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.folder_off_rounded, size: 64),
              const SizedBox(height: 12),
              BoundedText('This directory is empty'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onCreateFolder,
                icon: const Icon(Icons.create_new_folder_rounded),
                label: const Text('Create folder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _permissionLabel(StoragePermissionStatus status) {
  return switch (status) {
    StoragePermissionStatus.granted => 'All files access granted.',
    StoragePermissionStatus.limited =>
      'Legacy storage permission granted. SAF fallback is available.',
    StoragePermissionStatus.denied => 'Permission denied or not requested yet.',
    StoragePermissionStatus.permanentlyDenied =>
      'Permission permanently denied. Open Android app settings.',
  };
}

IconData _categoryIcon(FileCategory category) {
  return switch (category) {
    FileCategory.directory => Icons.folder_rounded,
    FileCategory.image => Icons.image_rounded,
    FileCategory.video => Icons.movie_rounded,
    FileCategory.audio => Icons.audio_file_rounded,
    FileCategory.pdf => Icons.picture_as_pdf_rounded,
    FileCategory.document => Icons.description_rounded,
    FileCategory.archive => Icons.archive_rounded,
    FileCategory.apk => Icons.android_rounded,
    FileCategory.other => Icons.insert_drive_file_rounded,
  };
}

Color _categoryColor(FileCategory category, ColorScheme scheme) {
  return switch (category) {
    FileCategory.directory => const Color(0xFFFFC857),
    FileCategory.image => const Color(0xFF3BA7FF),
    FileCategory.video => const Color(0xFFFF5C7A),
    FileCategory.audio => const Color(0xFF9C6BFF),
    FileCategory.pdf => const Color(0xFFFF7043),
    FileCategory.document => const Color(0xFF36CFC9),
    FileCategory.archive => const Color(0xFFB0BEC5),
    FileCategory.apk => const Color(0xFF58D26A),
    FileCategory.other => scheme.primary,
  };
}
