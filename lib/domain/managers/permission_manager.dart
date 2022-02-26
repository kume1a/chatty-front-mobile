import 'package:permission_handler/permission_handler.dart';

abstract class PermissionManager {
  Future<bool> isStoragePermissionGranted();

  Future<PermissionStatus> requestStoragePermission();

  Future<bool> isCameraPermissionGranted();

  Future<PermissionStatus> requestCameraPermission();

  Future<bool> isMicrophonePermissionGranted();

  Future<PermissionStatus> requestMicrophonePermission();

  Future<void> openPermissionSettings();
}
