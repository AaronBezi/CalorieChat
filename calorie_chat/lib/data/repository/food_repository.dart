import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import '../models/food_item.dart';
import '../local/food_dao.dart';
import '../local/memory_food_dao.dart';
import '../../core/utils/app_logger.dart';

class FoodRepository {
  late final dynamic _dao;
  bool _isInitialized = false;

  FoodRepository() {
    // Use in-memory storage for web, SQLite for native platforms
    _dao = kIsWeb ? MemoryFoodDao() : FoodDao();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Check if database already has data
    final count = await _dao.getFoodCount();
    if (count > 0) {
      _isInitialized = true;
      return;
    }

    // Load from JSON asset
    await _loadFoodsFromAsset();
    _isInitialized = true;
  }

  Future<void> _loadFoodsFromAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mypyramid_food.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final foods = jsonList.map((json) => FoodItem.fromJson(json)).toList();
      await _dao.insertFoods(foods);
    } catch (e) {
      // If asset doesn't exist yet, we'll handle it gracefully
      AppLogger.error('Failed to load food data from assets', e);
      rethrow;
    }
  }

  Future<List<FoodItem>> searchFoods(String query, {int limit = 25, int offset = 0}) async {
    await initialize();
    return await _dao.searchFoods(query, limit: limit, offset: offset);
  }

  Future<int> countSearchResults(String query) async {
    await initialize();
    return await _dao.countSearchResults(query);
  }

  Future<FoodItem?> getFoodById(String id) async {
    await initialize();
    return await _dao.getFoodById(id);
  }
}
