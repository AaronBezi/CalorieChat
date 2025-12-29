import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../config/env.dart';
import '../config/app_constants.dart';
import '../utils/app_logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.geminiApiBaseUrl,
        connectTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add retry interceptor (must be added before other interceptors)
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) => AppLogger.debug('Retry: $message'),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add API key to headers for Gemini API
          options.headers['X-goog-api-key'] = Env.geminiApiKey;
          return handler.next(options);
        },
        onError: (error, handler) {
          // Log error for debugging
          AppLogger.error('API Error', error);
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> parseMeal(String text) async {
    try {
      final response = await _dio.post(
        '/models/gemini-2.0-flash:generateContent',
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text': '''Parse the following meal description into structured food items.
Return ONLY valid JSON in this exact format (no markdown, no explanation):
{
  "items": [
    {
      "query": "food name",
      "quantity": 1,
      "portionHint": "optional portion description"
    }
  ]
}

Meal description: $text

Remember: Return ONLY the JSON object, nothing else.'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 1024,
          }
        },
      );

      // Extract text from Gemini response
      final generatedText = response.data['candidates'][0]['content']['parts'][0]['text'] as String;

      // Clean up markdown code blocks if present
      String cleanedText = generatedText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      } else if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      // Parse the JSON
      final parsedJson = _parseJson(cleanedText);
      return parsedJson;
    } catch (e) {
      AppLogger.warning('Gemini API failed, using fallback parser', e);

      // Fallback: Simple parsing for testing

      return _fallbackParse(text);
    }
  }

  Map<String, dynamic> _parseJson(String text) {
    try {
      // Try to parse as JSON
      return Map<String, dynamic>.from(
        // Using dart:convert would be imported at the top
        const JsonDecoder().convert(text),
      );
    } catch (e) {
      throw FormatException('Failed to parse JSON response: $text');
    }
  }

  /// Fallback parser when API fails - simple text parsing
  Map<String, dynamic> _fallbackParse(String text) {
    final items = <Map<String, dynamic>>[];

    // Simple parsing: look for numbers followed by food words
    final words = text.toLowerCase().split(RegExp(r'[,\s]+and\s+|[,\s]+'));

    for (final word in words) {
      final trimmed = word.trim();
      if (trimmed.isEmpty) continue;

      // Try to extract quantity (number at start)
      int quantity = 1;
      String foodName = trimmed;

      final match = RegExp(r'^(\d+)\s+(.+)').firstMatch(trimmed);
      if (match != null) {
        quantity = int.tryParse(match.group(1) ?? '1') ?? 1;
        foodName = match.group(2) ?? trimmed;
      }

      // Clean up common words
      foodName = foodName
          .replaceAll(RegExp(r'\b(with|of|a|an|the|i|ate)\b'), '')
          .trim();

      if (foodName.isNotEmpty) {
        items.add({
          'query': foodName,
          'quantity': quantity,
          'portionHint': null,
        });
      }
    }

    return {'items': items};
  }
}
