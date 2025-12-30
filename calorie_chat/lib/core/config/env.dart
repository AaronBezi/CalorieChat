import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  /// DEPRECATED: API key should be server-side only
  @Deprecated('Use backend API proxy instead')
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Backend API proxy base URL
  /// Development: http://localhost:3000
  /// Production: https://your-backend-url.onrender.com
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
