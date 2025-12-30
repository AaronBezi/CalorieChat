import '../models/logged_meal.dart';
import 'db.dart';

class LogDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> insertMeal(LoggedMeal meal) async {
    final db = await _db.database;

    // Insert meal
    final mealId = await db.insert(
      'logged_meals',
      {
        'description': meal.description,
        'total_calories': meal.totalCalories,
        'timestamp': meal.timestamp.millisecondsSinceEpoch,
      },
    );

    // Insert meal items
    final batch = db.batch();
    for (final item in meal.items) {
      batch.insert('logged_meal_items', {
        'meal_id': mealId,
        'food_id': item.foodId,
        'food_description': item.foodDescription,
        'portion': item.portion,
        'quantity': item.quantity,
        'calories': item.calories,
      });
    }
    await batch.commit(noResult: true);

    return mealId;
  }

  Future<List<LoggedMeal>> getMealsByDateRange(DateTime start, DateTime end) async {
    final db = await _db.database;

    final meals = await db.query(
      'logged_meals',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
      orderBy: 'timestamp DESC',
    );

    final result = <LoggedMeal>[];
    for (final mealRow in meals) {
      final mealId = mealRow['id'] as int;
      final items = await _getMealItems(mealId);

      result.add(LoggedMeal(
        id: mealId,
        description: mealRow['description'] as String,
        totalCalories: mealRow['total_calories'] as int,
        timestamp: DateTime.fromMillisecondsSinceEpoch(mealRow['timestamp'] as int),
        items: items,
      ));
    }

    return result;
  }

  Future<List<LoggedMealItem>> _getMealItems(int mealId) async {
    final db = await _db.database;

    final items = await db.query(
      'logged_meal_items',
      where: 'meal_id = ?',
      whereArgs: [mealId],
    );

    return items.map((row) => LoggedMealItem(
      foodId: row['food_id'] as String,
      foodDescription: row['food_description'] as String,
      portion: row['portion'] as String,
      quantity: row['quantity'] as int,
      calories: row['calories'] as int,
    )).toList();
  }

  Future<Map<String, int>> getDailyCalories(DateTime start, DateTime end) async {
    final db = await _db.database;

    final results = await db.rawQuery('''
      SELECT
        DATE(timestamp / 1000, 'unixepoch', 'localtime') as date,
        SUM(total_calories) as total
      FROM logged_meals
      WHERE timestamp >= ? AND timestamp <= ?
      GROUP BY date
      ORDER BY date
    ''', [
      start.millisecondsSinceEpoch,
      end.millisecondsSinceEpoch,
    ]);

    final map = <String, int>{};
    for (final row in results) {
      map[row['date'] as String] = row['total'] as int;
    }
    return map;
  }

  Future<void> deleteMeal(int id) async {
    final db = await _db.database;
    await db.delete(
      'logged_meals',
      where: 'id = ?',
      whereArgs: [id],
    );
    // Items will be deleted automatically due to CASCADE
  }

  /// Update an existing meal
  Future<void> updateMeal(LoggedMeal meal) async {
    if (meal.id == 0) {
      throw ArgumentError('Cannot update meal with ID 0');
    }

    final db = await _db.database;

    // Update meal
    await db.update(
      'logged_meals',
      {
        'description': meal.description,
        'total_calories': meal.totalCalories,
        'timestamp': meal.timestamp.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [meal.id],
    );

    // Delete old meal items
    await db.delete(
      'logged_meal_items',
      where: 'meal_id = ?',
      whereArgs: [meal.id],
    );

    // Insert new meal items
    final batch = db.batch();
    for (final item in meal.items) {
      batch.insert('logged_meal_items', {
        'meal_id': meal.id,
        'food_id': item.foodId,
        'food_description': item.foodDescription,
        'portion': item.portion,
        'quantity': item.quantity,
        'calories': item.calories,
      });
    }
    await batch.commit(noResult: true);
  }

  /// Get a specific meal by ID
  Future<LoggedMeal?> getMealById(int id) async {
    final db = await _db.database;

    final meals = await db.query(
      'logged_meals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (meals.isEmpty) return null;

    final mealRow = meals.first;
    final items = await _getMealItems(id);

    return LoggedMeal(
      id: id,
      description: mealRow['description'] as String,
      totalCalories: mealRow['total_calories'] as int,
      timestamp: DateTime.fromMillisecondsSinceEpoch(mealRow['timestamp'] as int),
      items: items,
    );
  }
}
