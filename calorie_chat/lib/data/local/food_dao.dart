import 'package:sqflite/sqflite.dart';
import '../models/food_item.dart';
import '../../core/utils/text_normalize.dart';
import 'db.dart';

class FoodDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> insertFoods(List<FoodItem> foods) async {
    final db = await _db.database;
    final batch = db.batch();

    for (final food in foods) {
      batch.insert(
        'foods',
        {
          'id': food.id,
          'description': food.description,
          'portion': food.portion,
          'calories': food.calories,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<FoodItem>> searchFoods(String query, {int limit = 25, int offset = 0}) async {
    final db = await _db.database;
    final normalizedQuery = TextNormalizer.normalizeForSearch(query);

    List<Map<String, dynamic>> results;

    // Check if query contains wildcard
    if (query.contains('*')) {
      // For wildcard search, we need to get all items and filter in memory
      // This is less efficient but necessary for wildcard support
      final allResults = await db.query('foods');

      results = allResults.where((row) {
        final description = row['description'] as String;
        return TextNormalizer.matchesWildcard(description, query);
      }).skip(offset).take(limit).toList();
    } else {
      // Regular search using SQL LIKE
      results = await db.query(
        'foods',
        where: 'LOWER(description) LIKE ?',
        whereArgs: ['%$normalizedQuery%'],
        limit: limit,
        offset: offset,
      );
    }

    return results.map((row) => FoodItem(
      id: row['id'] as String,
      description: row['description'] as String,
      portion: row['portion'] as String,
      calories: row['calories'] as int,
    )).toList();
  }

  Future<int> countSearchResults(String query) async {
    final db = await _db.database;
    final normalizedQuery = TextNormalizer.normalizeForSearch(query);

    if (query.contains('*')) {
      // For wildcard search, count matching items
      final allResults = await db.query('foods');
      return allResults.where((row) {
        final description = row['description'] as String;
        return TextNormalizer.matchesWildcard(description, query);
      }).length;
    } else {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM foods WHERE LOWER(description) LIKE ?',
        ['%$normalizedQuery%'],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    }
  }

  Future<FoodItem?> getFoodById(String id) async {
    final db = await _db.database;
    final results = await db.query(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return FoodItem(
      id: row['id'] as String,
      description: row['description'] as String,
      portion: row['portion'] as String,
      calories: row['calories'] as int,
    );
  }

  Future<int> getFoodCount() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM foods');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
