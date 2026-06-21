import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api'; // For Web (Chrome/Edge)
    } else {
      return 'http://10.0.2.2:5000/api'; // For Android emulator
    }
  }
}
