import 'file_item.dart';

class DirectoryPage {
  const DirectoryPage({
    required this.items,
    required this.totalCount,
    required this.hasMore,
  });

  final List<FileItem> items;
  final int totalCount;
  final bool hasMore;
}
