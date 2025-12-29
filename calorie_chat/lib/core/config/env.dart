import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiApiBaseUrl =>
      dotenv.env['GEMINI_API_BASE_URL'] ?? 'https://generativelanguage.googleapis.com/v1beta';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
