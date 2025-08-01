import 'package:flutter/services.dart';

class DeviceInfoService {
  static const platform = MethodChannel('com.example.deviceinfo/device');

  static Future<String?> getDeviceId() async {
    try {
      final String? deviceId = await platform.invokeMethod('getDeviceId');
      return deviceId;
    } on PlatformException catch (e) {
      print("Failed to get device ID: '${e.message}'.");
      return null;
    }
  }
}
