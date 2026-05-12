import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/logging/app_logger.dart';
import 'features/file_manager/presentation/pages/file_manager_page.dart';
import 'features/settings/presentation/settings_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.setup();
  runApp(const ProviderScope(child: TugasProApp()));
}

class TugasProApp extends ConsumerWidget {
  const TugasProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TugasPro File Manager',
      themeMode: themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: const FileManagerPage(),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final seed = brightness == Brightness.dark
        ? const Color(0xFF36D399)
        : const Color(0xFF006D5B);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
