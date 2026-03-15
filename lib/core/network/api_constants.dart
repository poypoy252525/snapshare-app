import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Base URL for the API.
  ///
  /// - Web: uses localhost (127.0.0.1)
  /// - Android Emulator: uses 10.0.2.2 (special alias for host localhost)
  /// - Real Device/iOS: Use your machine's local IP (e.g., 192.168.1.x)
  static String get baseUrl {
    return "https://snapshare.carljeffersondelfin.com";
  }

  static const String postsEndpoint = '/api/posts/';
  static const String loginEndpoint = '/api/auth/login/';
  static const String registrationEndpoint = '/api/auth/registration/';
  static const String tokenVerifyEndpoint = '/api/auth/token/verify/';
  static const String tokenRefreshEndpoint = '/api/auth/token/refresh/';
  static const String currentUserEndpoint = '/api/auth/user/';
}
