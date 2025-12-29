import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/logged_meal.dart';

/// Persistent meal log storage for web platform using SharedPreferences
class MemoryLogDao {
  static const String _mealsKey = 'logged_meals';
  static const String _nextIdKey = 'next_meal_id';

  List<LoggedMeal> _meals = [];
  int _nextId = 1;
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // Load next ID
    _nextId = prefs.getInt(_nextIdKey) ?? 1;

    // Load meals from SharedPreferences
    final mealsJson = prefs.getString(_mealsKey);
    if (mealsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(mealsJson);
        _meals = decoded.map((json) => LoggedMeal.fromJson(json)).toList();
      } catch (e) {
        _meals = [];
      }
    }

    _isInitialized = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    // Save meals to SharedPreferences
    final mealsJson = json.encode(_meals.map((meal) => meal.toJson()).toList());
    await prefs.setString(_mealsKey, mealsJson);

    // Save next ID
    await prefs.setInt(_nextIdKey, _nextId);
  }

  Future<int> insertMeal(LoggedMeal meal) async {
    await _initialize();

    final mealWithId = LoggedMeal(
      id: _nextId++,
      description: meal.description,
      totalCalories: meal.totalCalories,
      timestamp: meal.timestamp,
      items: meal.items,
    );
    _meals.add(mealWithId);

    await _save();
    return mealWithId.id;
  }

  Future<List<LoggedMeal>> getMealsByDateRange(DateTime start, DateTime end) async {
    await _initialize();

    return _meals
        .where((meal) =>
            meal.timestamp.isAfter(start) && meal.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<Map<String, int>> getDailyCalories(DateTime start, DateTime end) async {
    await _initialize();

    final map = <String, int>{};

    final mealsInRange = _meals.where((meal) =>
        meal.timestamp.isAfter(start) && meal.timestamp.isBefore(end));

    for (final meal in mealsInRange) {
      final dateKey = '${meal.timestamp.year}-${meal.timestamp.month.toString().padLeft(2, '0')}-${meal.timestamp.day.toString().padLeft(2, '0')}';
      map[dateKey] = (map[dateKey] ?? 0) + meal.totalCalories;
    }

    return map;
  }

  Future<void> deleteMeal(int id) async {
    await _initialize();

    _meals.removeWhere((meal) => meal.id == id);
    await _save();
  }
}
