import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/app_constants.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/food_item.dart';
import '../../data/models/meal_parse.dart';
import '../../data/models/logged_meal.dart';
import '../../data/repository/food_repository.dart';
import '../../data/repository/log_repository.dart';

class ChatController extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final FoodRepository _foodRepository = FoodRepository();
  final LogRepository _logRepository = LogRepository();

  bool _isParsing = false;
  bool _isSaving = false;
  String _errorMessage = '';
  MealParseResponse? _parsedMeal;
  List<MealMatch> _matches = [];

  bool get isParsing => _isParsing;
  bool get isSaving => _isSaving;
  String get errorMessage => _errorMessage;
  MealParseResponse? get parsedMeal => _parsedMeal;
  List<MealMatch> get matches => _matches;
  bool get hasMatches => _matches.isNotEmpty;

  Future<void> parseMeal(String mealText) async {
    // Validate input
    final trimmedText = mealText.trim();

    if (trimmedText.isEmpty) {
      _errorMessage = AppConstants.mealTextEmptyError;
      notifyListeners();
      return;
    }

    if (trimmedText.length < AppConstants.minMealTextLength) {
      _errorMessage = AppConstants.mealTextTooShortError;
      notifyListeners();
      return;
    }

    if (trimmedText.length > AppConstants.maxMealTextLength) {
      _errorMessage = AppConstants.mealTextTooLongError;
      notifyListeners();
      return;
    }

    _isParsing = true;
    _errorMessage = '';
    _parsedMeal = null;
    _matches = [];
    notifyListeners();

    try {
      // Parse meal using Gemini API
      final response = await _apiClient.parseMeal(trimmedText);
      _parsedMeal = MealParseResponse.fromJson(response);

      // Match each parsed item to food database
      await _matchFoodItems();

      // Check if we got any matches
      if (_matches.isEmpty) {
        _errorMessage = AppConstants.noMatchesError;
      }
    } on DioException catch (e) {
      AppLogger.error('Network error during meal parsing', e);

      // Provide specific error messages based on error type
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Request timed out. Please check your connection and try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        _errorMessage = AppConstants.networkErrorMessage;
      } else if (e.response != null && e.response!.statusCode == 429) {
        _errorMessage = 'Too many requests. Please wait a moment and try again.';
      } else {
        _errorMessage = AppConstants.apiErrorGeneric;
      }

      _parsedMeal = null;
      _matches = [];
    } catch (e) {
      AppLogger.error('Unexpected error during meal parsing', e);
      _errorMessage = AppConstants.apiErrorGeneric;
      _parsedMeal = null;
      _matches = [];
    } finally {
      _isParsing = false;
      notifyListeners();
    }
  }

  Future<void> _matchFoodItems() async {
    if (_parsedMeal == null) return;

    final matches = <MealMatch>[];

    for (final item in _parsedMeal!.items) {
      // Try to find matches with smart search
      final results = await _smartSearch(item.query);

      if (results.isNotEmpty) {
        // Use the first match as the best match
        matches.add(MealMatch(
          parsedItem: item,
          matchedFood: results.first,
          alternativeMatches: results.skip(1).toList(),
        ));
      } else {
        // No match found
        matches.add(MealMatch(
          parsedItem: item,
          matchedFood: null,
          alternativeMatches: [],
        ));
      }
    }

    _matches = matches;
  }

  /// Smart search with common food synonyms
  Future<List<FoodItem>> _smartSearch(String query) async {
    // Common food synonyms mapping
    final synonyms = {
      // Breads & Grains
      'toast': 'bread',
      'sandwich': 'bread',
      'bun': 'bread',
      'roll': 'bread',
      'bagel': 'bagel',
      'muffin': 'muffin',
      'pancake': 'pancake',
      'waffle': 'pancake',
      'tortilla': 'tortilla',
      'wrap': 'tortilla',
      'pasta': 'macaroni',
      'noodles': 'macaroni',
      'spaghetti': 'macaroni',
      'rice': 'rice',
      'oats': 'oatmeal',
      'oatmeal': 'oatmeal',
      'cereal': 'oatmeal',
      'granola': 'oatmeal',
      'cracker': 'crackers',
      'crackers': 'crackers',

      // Proteins - Meat
      'burger': 'beef',
      'hamburger': 'beef',
      'steak': 'beef',
      'beef': 'beef',
      'ground beef': 'beef',
      'chicken': 'chicken',
      'turkey': 'turkey',
      'pork': 'pork',
      'ham': 'ham',
      'bacon': 'bacon',
      'sausage': 'bacon',
      'hotdog': 'bacon',

      // Proteins - Seafood
      'fish': 'salmon',
      'salmon': 'salmon',
      'tuna': 'tuna',
      'shrimp': 'shrimp',
      'cod': 'cod',

      // Dairy & Eggs
      'egg': 'egg',
      'eggs': 'egg',
      'milk': 'milk',
      'cheese': 'cheese',
      'cheddar': 'cheese cheddar',
      'mozzarella': 'cheese mozzarella',
      'yogurt': 'yogurt',
      'butter': 'butter',
      'cream': 'milk',
      'ice cream': 'ice cream',

      // Vegetables
      'fries': 'potato',
      'french fries': 'potato',
      'potato': 'potato',
      'potatoes': 'potato',
      'chips': 'potato',
      'salad': 'lettuce',
      'lettuce': 'lettuce',
      'tomato': 'tomato',
      'tomatoes': 'tomato',
      'onion': 'onion',
      'onions': 'onion',
      'carrot': 'carrot',
      'carrots': 'carrot',
      'broccoli': 'broccoli',
      'spinach': 'spinach',
      'corn': 'corn',
      'peas': 'peas',
      'beans': 'black beans',
      'peppers': 'peppers',
      'cucumber': 'cucumber',
      'mushroom': 'mushrooms',
      'mushrooms': 'mushrooms',

      // Fruits
      'apple': 'apple',
      'apples': 'apple',
      'banana': 'banana',
      'bananas': 'banana',
      'orange': 'orange',
      'oranges': 'orange',
      'grapes': 'grapes',
      'strawberry': 'strawberries',
      'strawberries': 'strawberries',
      'blueberry': 'blueberries',
      'blueberries': 'blueberries',
      'watermelon': 'watermelon',
      'melon': 'cantaloupe',
      'peach': 'peach',
      'pear': 'pear',
      'cherry': 'cherries',
      'cherries': 'cherries',

      // Snacks & Sweets
      'cookie': 'cookies',
      'cookies': 'cookies',
      'cake': 'cake',
      'pie': 'pie',
      'chocolate': 'cookies chocolate chip',
      'candy': 'cookies',

      // Nuts & Seeds
      'peanut': 'peanuts',
      'peanuts': 'peanuts',
      'almond': 'almonds',
      'almonds': 'almonds',
      'walnut': 'walnuts',
      'walnuts': 'walnuts',
      'cashew': 'cashew',
      'cashews': 'cashew',

      // Condiments & Extras
      'mayo': 'mayonnaise',
      'mayonnaise': 'mayonnaise',
      'ketchup': 'ketchup',
      'mustard': 'mustard',
      'dressing': 'salad dressing',
      'ranch': 'salad dressing ranch',
      'jelly': 'jelly',
      'jam': 'jelly',

      // Beverages (not in database)
      'coffee': 'coffee',
      'tea': 'tea',
      'soda': 'soda',
      'juice': 'juice',
      'water': 'water',
      'beer': 'beer',
      'wine': 'wine',
    };

    // Try exact query first
    var results = await _foodRepository.searchFoods(query, limit: 5);

    // If no results and we have a synonym, try that
    if (results.isEmpty && synonyms.containsKey(query.toLowerCase())) {
      final synonym = synonyms[query.toLowerCase()]!;
      results = await _foodRepository.searchFoods(synonym, limit: 5);
    }

    return results;
  }

  void updateMatchedFood(int index, FoodItem food) {
    if (index >= 0 && index < _matches.length) {
      final match = _matches[index];
      _matches[index] = MealMatch(
        parsedItem: match.parsedItem,
        matchedFood: food,
        alternativeMatches: match.alternativeMatches,
      );
      notifyListeners();
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _matches.length) {
      final match = _matches[index];
      _matches[index] = MealMatch(
        parsedItem: ParsedItem(
          query: match.parsedItem.query,
          quantity: quantity,
          portionHint: match.parsedItem.portionHint,
        ),
        matchedFood: match.matchedFood,
        alternativeMatches: match.alternativeMatches,
      );
      notifyListeners();
    }
  }

  void removeMatch(int index) {
    if (index >= 0 && index < _matches.length) {
      _matches.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> saveMeal(String description) async {
    if (_matches.isEmpty) return false;

    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Calculate total calories
      int totalCalories = 0;
      final items = <LoggedMealItem>[];

      for (final match in _matches) {
        if (match.matchedFood != null) {
          final calories = match.matchedFood!.calories * match.parsedItem.quantity;
          totalCalories += calories;

          items.add(LoggedMealItem(
            foodId: match.matchedFood!.id,
            foodDescription: match.matchedFood!.description,
            portion: match.matchedFood!.portion,
            quantity: match.parsedItem.quantity,
            calories: calories,
          ));
        }
      }

      // Save the logged meal
      final meal = LoggedMeal(
        id: 0, // Will be assigned by database
        description: description,
        totalCalories: totalCalories,
        timestamp: DateTime.now(),
        items: items,
      );

      await _logRepository.saveMeal(meal);

      // Clear the current state
      _parsedMeal = null;
      _matches = [];

      return true;
    } catch (e) {
      AppLogger.error('Error saving meal to database', e);
      _errorMessage = AppConstants.databaseErrorMessage;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clear() {
    _parsedMeal = null;
    _matches = [];
    _errorMessage = '';
    notifyListeners();
  }
}

class MealMatch {
  final ParsedItem parsedItem;
  final FoodItem? matchedFood;
  final List<FoodItem> alternativeMatches;

  MealMatch({
    required this.parsedItem,
    required this.matchedFood,
    required this.alternativeMatches,
  });

  int get totalCalories =>
      matchedFood != null ? matchedFood!.calories * parsedItem.quantity : 0;
}
