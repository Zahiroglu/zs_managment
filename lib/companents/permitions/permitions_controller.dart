import 'package:permission_handler/permission_handler.dart';

class LocalPermissionsController {
  // Method to check if location permission is granted
  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }

  Future<bool> checkNotyPermission() async {
    return await Permission.notification.isGranted;
  }

  // Method to request location permission
  Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }

  // Method to check if background location permission is granted
  Future<bool> checkBackgroundLocationPermission() async {
    if (await Permission.location.isGranted) {
      return await Permission.locationAlways.isGranted;
    }
    return false;
  }

  // Method to request background location permission
  Future<void> requestBackgroundLocationPermission() async {
    if (!(await Permission.location.isGranted)) {
      await Permission.location.request();
    }
    await Permission.locationAlways.request();
  }
  Future<void> requestNotyPermission() async {
    if (!(await Permission.notification.isGranted)) {
      await Permission.notification.request();
    }
    await Permission.notification.request();
  }
}