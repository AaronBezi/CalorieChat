import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../config/env.dart';
import '../config/app_constants.dart';
import '../utils/app_logger.dart';

/// API client that communicates with the backend proxy server
/// The backend handles Gemini API calls securely with API key server-side
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
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
          AppLogger.debug('API Request: ${options.method} ${options.path}');
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

  /// Parse meal description using backend API proxy
  /// The backend forwards the request to Gemini API securely
  Future<Map<String, dynamic>> parseMeal(String text) async {
    try {
      AppLogger.info('Parsing meal via backend proxy');

      final response = await _dio.post(
        '/api/parse-meal',
        data: {
          'text': text,
        },
      );

      // Backend returns the parsed meal data directly
      if (response.data is Map<String, dynamic>) {
        AppLogger.info('Meal parsed successfully via backend');
        return response.data;
      } else {
        throw FormatException('Invalid response format from backend');
      }
    } on DioException catch (e) {
      AppLogger.warning('Backend API failed, using fallback parser', e);

      // Check if it's a server error response with message
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('message')) {
          AppLogger.error('Backend error: ${errorData['message']}');
        }
      }

      // Fallback to local parsing
      return _fallbackParse(text);
    } catch (e) {
      AppLogger.error('Unexpected error during meal parsing', e);

      // Fallback to local parsing
      return _fallbackParse(text);
    }
  }

  /// Fallback parser when backend/API fails - simple text parsing
  /// This provides basic functionality even when the backend is unavailable
  Map<String, dynamic> _fallbackParse(String text) {
    AppLogger.info('Using fallback parser');
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
