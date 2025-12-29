import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../data/models/logged_meal.dart';
import '../../data/repository/log_repository.dart';

class InsightsController extends ChangeNotifier {
  final LogRepository _logRepository = LogRepository();

  List<LoggedMeal> _todaysMeals = [];
  List<LoggedMeal> _recentMeals = [];
  Map<String, int> _weeklyCalories = {};
  bool _isLoading = false;
  String _errorMessage = '';

  List<LoggedMeal> get todaysMeals => _todaysMeals;
  List<LoggedMeal> get recentMeals => _recentMeals;
  Map<String, int> get weeklyCalories => _weeklyCalories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  int get todayTotal => _todaysMeals.fold(0, (sum, meal) => sum + meal.totalCalories);

  double get weeklyAverage {
    if (_weeklyCalories.isEmpty) return 0;
    final total = _weeklyCalories.values.fold(0, (sum, cal) => sum + cal);
    return total / _weeklyCalories.length;
  }

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Load today's meals
      _todaysMeals = await _logRepository.getTodaysMeals();

      // Load last 7 days of meals
      final now = DateTime.now();
      final startOfWeek = now.subtract(const Duration(days: 7));
      _recentMeals = await _logRepository.getMealsByDateRange(startOfWeek, now);

      // Load weekly calorie data
      _weeklyCalories = await _logRepository.getDailyCalories(startOfWeek, now);
    } catch (e) {
      _errorMessage = 'Error loading data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      await _logRepository.deleteMeal(id);
      await loadData(); // Reload data after deletion
    } catch (e) {
      _errorMessage = 'Error deleting meal: ${e.toString()}';
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  String getInsightMessage() {
    if (_todaysMeals.isEmpty) {
      return "No meals logged today. Start tracking your calories!";
    }

    final total = todayTotal;

    if (total < 1200) {
      return "You're under 1200 calories today. Make sure you're eating enough!";
    } else if (total < 2000) {
      return "Good job! You're staying within a moderate calorie range.";
    } else if (total < 2500) {
      return "You've had $total calories today. Monitor your intake if you're watching calories.";
    } else {
      return "High calorie day at $total calories. Consider lighter meals tomorrow.";
    }
  }
}
