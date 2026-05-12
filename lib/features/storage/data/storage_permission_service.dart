import 'dart:io';

import 'package:flutter/services.dart';

import '../../../core/logging/app_logger.dart';

enum StoragePermissionStatus { granted, denied, permanentlyDenied, limited }

class StoragePermissionService {
  static const MethodChannel _channel = MethodChannel(
    'tugaspro/android_file_system',
  );

  Future<StoragePermissionStatus> check() async {
    if (!Platform.isAndroid) return StoragePermissionStatus.granted;
    final status = await _channel.invokeMethod<String>('permissionStatus');
    return _statusFromNative(status);
  }

  Future<StoragePermissionStatus> request() {
    return requestAllFilesAccess();
  }

  Future<StoragePermissionStatus> requestAllFilesAccess() async {
    if (!Platform.isAndroid) return StoragePermissionStatus.granted;
    AppLogger.permission.info(
      'Opening Android SDK MANAGE_EXTERNAL_STORAGE permission flow',
    );
    final status = await _channel.invokeMethod<String>('requestAllFilesAccess');
    return _statusFromNative(status);
  }

  Future<String?> requestSafDirectory() {
    if (!Platform.isAndroid) return Future.value(null);
    return _channel.invokeMethod<String>('openSafTree');
  }

  Future<void> openSettings() async {
    await requestAllFilesAccess();
  }

  StoragePermissionStatus _statusFromNative(String? status) {
    return switch (status) {
      'granted' => StoragePermissionStatus.granted,
      'limited' => StoragePermissionStatus.limited,
      'permanentlyDenied' => StoragePermissionStatus.permanentlyDenied,
      _ => StoragePermissionStatus.denied,
    };
  }
}
