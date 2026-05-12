import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StorageRootsService {
  Future<List<String>> roots() async {
    final roots = <String>{};
    if (Platform.isAndroid) {
      roots.add('/storage/emulated/0');
      final storage = Directory('/storage');
      if (await storage.exists()) {
        await for (final entity in storage.list(followLinks: false)) {
          if (entity is Directory && !entity.path.endsWith('/self')) {
            roots.add(entity.path);
          }
        }
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final home = Platform.environment['HOME'];
      if (home != null && home.isNotEmpty) {
        roots.add(home);
        for (final child in [
          'Desktop',
          'Documents',
          'Downloads',
          'Pictures',
          'Videos',
          'Music',
        ]) {
          roots.add(p.join(home, child));
        }
      }
      final downloads = await getDownloadsDirectory();
      if (downloads != null) roots.add(downloads.path);
      roots.add(Directory.current.path);
    } else {
      final docs = await getApplicationDocumentsDirectory();
      roots.add(docs.path);
    }

    final existing = <String>[];
    for (final root in roots) {
      if (await Directory(root).exists()) existing.add(root);
    }
    return existing;
  }
}
