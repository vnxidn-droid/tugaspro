import 'package:logging/logging.dart';

class AppLogger {
  AppLogger._();

  static final Logger fileSystem = Logger('tugaspro.file_system');
  static final Logger permission = Logger('tugaspro.permission');
  static final Logger ui = Logger('tugaspro.ui');

  static void setup() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(
        '[${record.level.name}] ${record.loggerName}: ${record.message}'
        '${record.error == null ? '' : ' | ${record.error}'}',
      );
    });
  }
}
