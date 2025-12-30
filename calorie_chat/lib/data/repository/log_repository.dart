import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/logged_meal.dart';
import '../local/log_dao.dart';
import '../local/memory_log_dao.dart';

class LogRepository {
  late final dynamic _dao;

  LogRepository() {
    // Use in-memory storage for web, SQLite for native platforms
    _dao = kIsWeb ? MemoryLogDao() : LogDao();
  }

  Future<int> saveMeal(LoggedMeal meal) async {
    return await _dao.insertMeal(meal);
  }

  Future<List<LoggedMeal>> getMealsByDateRange(DateTime start, DateTime end) async {
    return await _dao.getMealsByDateRange(start, end);
  }

  Future<List<LoggedMeal>> getTodaysMeals() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await getMealsByDateRange(startOfDay, endOfDay);
  }

  Future<Map<String, int>> getDailyCalories(DateTime start, DateTime end) async {
    return await _dao.getDailyCalories(start, end);
  }

  Future<void> deleteMeal(int id) async {
    return await _dao.deleteMeal(id);
  }

  /// Update an existing meal
  Future<void> updateMeal(LoggedMeal meal) async {
    return await _dao.updateMeal(meal);
  }

  /// Get a specific meal by ID
  Future<LoggedMeal?> getMealById(int id) async {
    return await _dao.getMealById(id);
  }
}
