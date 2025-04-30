import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  // Method to request storage permission
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // We can request permission if it is not granted
      if (await Permission.storage.request().isGranted) {
        // Permission is granted
        return true;
      } else {
        // Handle the case when permission is denied
        return false;
      }
    } else {
      // Permission is already granted
      return true;
    }
  }
}
