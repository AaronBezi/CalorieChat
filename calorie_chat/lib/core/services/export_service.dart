import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/logged_meal.dart';
import '../utils/app_logger.dart';

/// Service for exporting meal data to various formats
class ExportService {
  /// Export meals to CSV format
  static Future<String> exportToCSV(List<LoggedMeal> meals) async {
    AppLogger.info('Exporting ${meals.length} meals to CSV');

    // Create CSV data
    final List<List<dynamic>> rows = [];

    // Add header row
    rows.add([
      'Date',
      'Time',
      'Meal Description',
      'Food Item',
      'Portion',
      'Quantity',
      'Calories per Item',
      'Total Item Calories',
      'Meal Total Calories',
    ]);

    // Add data rows
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    for (final meal in meals) {
      final date = dateFormat.format(meal.timestamp);
      final time = timeFormat.format(meal.timestamp);

      if (meal.items.isEmpty) {
        // Meal with no items
        rows.add([
          date,
          time,
          meal.description,
          '',
          '',
          '',
          '',
          '',
          meal.totalCalories,
        ]);
      } else {
        // Add a row for each item
        for (int i = 0; i < meal.items.length; i++) {
          final item = meal.items[i];
          final itemTotalCalories = item.calories * item.quantity;

          rows.add([
            i == 0 ? date : '', // Only show date on first row
            i == 0 ? time : '', // Only show time on first row
            i == 0 ? meal.description : '', // Only show description on first row
            item.foodDescription,
            item.portion,
            item.quantity,
            item.calories,
            itemTotalCalories,
            i == 0 ? meal.totalCalories : '', // Only show total on first row
          ]);
        }
      }
    }

    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      // For web, return the CSV string directly (caller will handle download)
      AppLogger.info('CSV generated for web download');
      return csvString;
    } else {
      // For mobile, save to file
      final file = await _saveToFile(csvString, 'calorie_chat_export.csv');
      AppLogger.info('CSV saved to: ${file.path}');
      return file.path;
    }
  }

  /// Export summary statistics to CSV
  static Future<String> exportSummaryToCSV(
    List<LoggedMeal> meals,
    Map<String, int> dailyCalories,
  ) async {
    AppLogger.info('Exporting summary statistics to CSV');

    final List<List<dynamic>> rows = [];

    // Header
    rows.add(['Date', 'Total Calories', 'Number of Meals']);

    // Group meals by date
    final mealsByDate = <String, List<LoggedMeal>>{};
    for (final meal in meals) {
      final dateKey = DateFormat('yyyy-MM-dd').format(meal.timestamp);
      mealsByDate.putIfAbsent(dateKey, () => []).add(meal);
    }

    // Add data rows
    for (final entry in dailyCalories.entries) {
      final date = entry.key;
      final calories = entry.value;
      final mealCount = mealsByDate[date]?.length ?? 0;

      rows.add([date, calories, mealCount]);
    }

    // Add statistics
    rows.add([]); // Empty row
    rows.add(['Statistics']);
    rows.add(['Total Days', dailyCalories.length]);
    rows.add(['Total Meals', meals.length]);
    rows.add([
      'Average Daily Calories',
      dailyCalories.isEmpty
          ? 0
          : (dailyCalories.values.reduce((a, b) => a + b) / dailyCalories.length).round()
    ]);

    final csvString = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      return csvString;
    } else {
      final file = await _saveToFile(csvString, 'calorie_chat_summary.csv');
      AppLogger.info('Summary CSV saved to: ${file.path}');
      return file.path;
    }
  }

  /// Save CSV string to file (mobile only)
  static Future<File> _saveToFile(String content, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return await file.writeAsString(content);
  }

  /// Get export filename with timestamp
  static String getExportFilename(String prefix) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${prefix}_$timestamp.csv';
  }
}
