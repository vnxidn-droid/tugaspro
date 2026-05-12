enum FileCategory {
  directory,
  image,
  video,
  audio,
  pdf,
  document,
  archive,
  apk,
  other,
}

class FileItem {
  const FileItem({
    required this.path,
    required this.name,
    required this.isDirectory,
    required this.size,
    required this.modified,
    required this.extension,
    required this.mimeType,
    required this.category,
  });

  final String path;
  final String name;
  final bool isDirectory;
  final int size;
  final DateTime modified;
  final String extension;
  final String mimeType;
  final FileCategory category;
}

enum SortMode {
  name('Name'),
  size('Size'),
  modified('Modified'),
  type('Type');

  const SortMode(this.label);
  final String label;
}

enum ClipboardMode { copy, move }

class FileClipboard {
  const FileClipboard({required this.paths, required this.mode});

  final List<String> paths;
  final ClipboardMode mode;
}
