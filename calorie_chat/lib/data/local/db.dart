import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('calorie_chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Food items table
    await db.execute('''
      CREATE TABLE foods (
        id TEXT PRIMARY KEY,
        description TEXT NOT NULL,
        portion TEXT NOT NULL,
        calories INTEGER NOT NULL
      )
    ''');

    // Create index for faster searching
    await db.execute('''
      CREATE INDEX idx_foods_description ON foods(description)
    ''');

    // Logged meals table
    await db.execute('''
      CREATE TABLE logged_meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        total_calories INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    // Logged meal items table (junction table)
    await db.execute('''
      CREATE TABLE logged_meal_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id INTEGER NOT NULL,
        food_id TEXT NOT NULL,
        food_description TEXT NOT NULL,
        portion TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES logged_meals (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
