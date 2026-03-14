import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Base URL for the API.
  ///
  /// - Web: uses localhost (127.0.0.1)
  /// - Android Emulator: uses 10.0.2.2 (special alias for host localhost)
  /// - Real Device/iOS: Use your machine's local IP (e.g., 192.168.1.x)
  static String get baseUrl {
    if (kReleaseMode) {
      return 'https://snapshare.carljeffersondelfin.com';
    }
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // For real devices, replace 10.0.2.2 with your machine's local IP
      // Ensure your backend is listening on 0.0.0.0 instead of 127.0.0.1
      return 'http://192.168.100.58:8000';
    } else {
      // iOS Simulator and Desktop
      return 'http://localhost:8000';
    }
  }

  static const String postsEndpoint = '/api/posts/';
  static const String loginEndpoint = '/api/auth/login/';
  static const String registrationEndpoint = '/api/auth/registration/';
}
