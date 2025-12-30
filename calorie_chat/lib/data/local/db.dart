import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'migrations.dart';
import '../../core/config/app_constants.dart';
import '../../core/utils/app_logger.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: DatabaseMigrations.currentVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onDowngrade: _downgradeDB,
      onOpen: _onOpen,
    );
  }

  /// Called when database is opened
  Future<void> _onOpen(Database db) async {
    AppLogger.info('Database opened successfully');

    // Verify integrity on open
    final isValid = await DatabaseMigrations.verifyIntegrity(db);
    if (!isValid) {
      AppLogger.error('Database integrity check failed on open');
    }
  }

  /// Called when database needs to be upgraded
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from v$oldVersion to v$newVersion');
    await DatabaseMigrations.migrate(db, oldVersion, newVersion);
  }

  /// Called when database needs to be downgraded (usually during development)
  Future<void> _downgradeDB(Database db, int oldVersion, int newVersion) async {
    AppLogger.warning('Downgrading database from v$oldVersion to v$newVersion');
    // For production, you might want to prevent downgrades
    // throw Exception('Database downgrade not supported');

    // For development, recreate the database
    await _resetDatabase(db);
  }

  /// Reset database by dropping all tables and recreating
  Future<void> _resetDatabase(Database db) async {
    AppLogger.warning('Resetting database - all data will be lost');

    await db.execute('DROP TABLE IF EXISTS logged_meal_items');
    await db.execute('DROP TABLE IF EXISTS logged_meals');
    await db.execute('DROP TABLE IF EXISTS foods');

    await _createDB(db, DatabaseMigrations.currentVersion);
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
