import 'package:sqflite/sqflite.dart';
import '../../core/utils/app_logger.dart';

/// Database migration handler for schema versioning
class DatabaseMigrations {
  /// Current database version
  static const int currentVersion = 1;

  /// Execute all migrations between oldVersion and newVersion
  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Migrating database from version $oldVersion to $newVersion');

    // Run migrations sequentially
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _runMigration(db, version);
    }

    AppLogger.info('Database migration complete');
  }

  /// Run a specific migration version
  static Future<void> _runMigration(Database db, int version) async {
    AppLogger.info('Running migration for version $version');

    switch (version) {
      case 1:
        // Initial schema - handled by onCreate
        break;

      // Example future migrations:
      // case 2:
      //   await _migrateTo2(db);
      //   break;
      // case 3:
      //   await _migrateTo3(db);
      //   break;

      default:
        AppLogger.warning('No migration defined for version $version');
    }
  }

  /// Example: Add macronutrients to foods table
  /// Uncomment and modify when needed
  /*
  static Future<void> _migrateTo2(Database db) async {
    await db.execute('''
      ALTER TABLE foods ADD COLUMN protein REAL DEFAULT 0.0
    ''');
    await db.execute('''
      ALTER TABLE foods ADD COLUMN carbs REAL DEFAULT 0.0
    ''');
    await db.execute('''
      ALTER TABLE foods ADD COLUMN fat REAL DEFAULT 0.0
    ''');
    AppLogger.info('Added macronutrient columns to foods table');
  }
  */

  /// Example: Add user goals table
  /// Uncomment and modify when needed
  /*
  static Future<void> _migrateTo3(Database db) async {
    await db.execute('''
      CREATE TABLE user_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        daily_calorie_target INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    AppLogger.info('Created user_goals table');
  }
  */

  /// Verify database integrity after migration
  static Future<bool> verifyIntegrity(Database db) async {
    try {
      final result = await db.rawQuery('PRAGMA integrity_check');
      final isOk = result.isNotEmpty && result.first['integrity_check'] == 'ok';

      if (isOk) {
        AppLogger.info('Database integrity check passed');
      } else {
        AppLogger.error('Database integrity check failed', result);
      }

      return isOk;
    } catch (e) {
      AppLogger.error('Error during integrity check', e);
      return false;
    }
  }

  /// Get current schema version
  static Future<int> getSchemaVersion(Database db) async {
    try {
      final result = await db.rawQuery('PRAGMA user_version');
      return result.first['user_version'] as int;
    } catch (e) {
      AppLogger.error('Error getting schema version', e);
      return 0;
    }
  }

  /// Set schema version
  static Future<void> setSchemaVersion(Database db, int version) async {
    try {
      await db.execute('PRAGMA user_version = $version');
      AppLogger.info('Set schema version to $version');
    } catch (e) {
      AppLogger.error('Error setting schema version', e);
    }
  }
}
