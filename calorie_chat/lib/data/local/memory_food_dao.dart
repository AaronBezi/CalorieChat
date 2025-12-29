import '../models/food_item.dart';
import '../../core/utils/text_normalize.dart';

/// In-memory food storage for web platform (SQLite not supported in browsers)
class MemoryFoodDao {
  final List<FoodItem> _foods = [];

  Future<void> insertFoods(List<FoodItem> foods) async {
    _foods.clear();
    _foods.addAll(foods);
  }

  Future<List<FoodItem>> searchFoods(String query, {int limit = 25, int offset = 0}) async {
    final normalizedQuery = TextNormalizer.normalizeForSearch(query);

    List<FoodItem> results;

    // Check if query contains wildcard
    if (query.contains('*')) {
      results = _foods.where((food) {
        return TextNormalizer.matchesWildcard(food.description, query);
      }).toList();
    } else {
      // Regular search
      results = _foods.where((food) {
        final normalizedDesc = TextNormalizer.normalizeForSearch(food.description);
        return normalizedDesc.contains(normalizedQuery);
      }).toList();
    }

    // Apply pagination
    final start = offset;
    final end = (offset + limit).clamp(0, results.length);

    if (start >= results.length) {
      return [];
    }

    return results.sublist(start, end);
  }

  Future<int> countSearchResults(String query) async {
    final normalizedQuery = TextNormalizer.normalizeForSearch(query);

    if (query.contains('*')) {
      return _foods.where((food) {
        return TextNormalizer.matchesWildcard(food.description, query);
      }).length;
    } else {
      return _foods.where((food) {
        final normalizedDesc = TextNormalizer.normalizeForSearch(food.description);
        return normalizedDesc.contains(normalizedQuery);
      }).length;
    }
  }

  Future<FoodItem?> getFoodById(String id) async {
    try {
      return _foods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> getFoodCount() async {
    return _foods.length;
  }
}
