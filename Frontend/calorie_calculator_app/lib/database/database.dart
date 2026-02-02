import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper
{
	static Database? _db;
	static const int _currentVersion = 3;
	static final DatabaseHelper instance = DatabaseHelper._constructor(); // Makes a singleton

	final String calcsTableName = "calcs";
	final String calcsIDColumnName = "id";
	final String calcsDateColumnName = "date";
	final String calcsWeightColumnName = "personWeight";
	final String calcsBMRColumnName = "bmr";
	final String calcsTDEEColumnName = "tdee";
	final String calcsWeightLiftingBurnColumnName = "weightLiftingBurn";
	final String calcsCardioBurnColumnName = "cardioBurn";
	final String calcsEPOCColumnName = "epoc";
	final String calcsTotalBurnColumnName = "totalBurn";

	final String tdeeTableName = "tdee";
	final String tdeeIDColumnName = "id";
	final String tdeeTDEEColumnName = "tdee";
	final String tdeeBMRColumnName = "bmr";
	final String tdeeWeightColumnName = "weight";

	DatabaseHelper._constructor();

	Future<Database> get database async
	{
		return _db ??= await getDatabase(); // Return the database if it isn't null, otherwise call getDatabase and return the value from that
	}

	Future<Database> getDatabase() async
	{
		final String databaseDirPath = await getDatabasesPath();
		final String databasePath = join(databaseDirPath, "master_db.db");

		return await openDatabase
		(
			databasePath,
			version: _currentVersion,
			onConfigure: (db) async
			{
				await db.execute('PRAGMA foreign_keys = ON');
			},
			onCreate: (db, version)
			{
				db.execute
				(
					'''
						CREATE TABLE $calcsTableName (
							$calcsIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
							$calcsDateColumnName TEXT NOT NULL,
							$calcsWeightColumnName REAL NOT NULL,
							$calcsBMRColumnName REAL NOT NULL,
							$calcsTDEEColumnName REAL NOT NULL,
							$calcsWeightLiftingBurnColumnName REAL NOT NULL,
							$calcsCardioBurnColumnName REAL NOT NULL,
							$calcsEPOCColumnName REAL NOT NULL,
							$calcsTotalBurnColumnName REAL NOT NULL
						)
					''',
				);

				db.execute
				(
					'''
						CREATE TABLE $tdeeTableName (
							$tdeeIDColumnName INTEGER PRIMARY KEY DEFAULT 1,
							$tdeeTDEEColumnName REAL NOT NULL,
							$tdeeBMRColumnName REAL NOT NULL,
							$tdeeWeightColumnName REAL NOT NULL,
						)
					'''
				);
			},
			onUpgrade: (db, oldVersion, newVersion) async
			{
				if (oldVersion < 2)
				{
					await db.execute("ALTER TABLE $calcsTableName ADD COLUMN $calcsWeightColumnName REAL NOT NULL DEFAULT 0.0");
				}
				if (oldVersion < 3)
				{
					await db.execute
					(
						'''
							CREATE TABLE $tdeeTableName (
								$tdeeIDColumnName INTEGER PRIMARY KEY DEFAULT 1,
								$tdeeTDEEColumnName REAL NOT NULL,
								$tdeeBMRColumnName REAL NOT NULL,
								$tdeeWeightColumnName REAL NOT NULL
							)
						'''
					);
				}
			}
		);
	}

	// Returns an int to notify that a successful addition took place
	Future<int> addCalc(String date, double personWeight, double bmr, double tdee, double weight, double cardio, double epoc, double total) async
	{
		final db = await database;

		return await db.insert
		(
			calcsTableName, // Table name that the info is being inserted into
			{	// A map with the column's name on the left and the values on the right
				calcsDateColumnName: date,
				calcsWeightColumnName: personWeight,
				calcsBMRColumnName: bmr,
				calcsTDEEColumnName: tdee,
				calcsWeightLiftingBurnColumnName: weight,
				calcsCardioBurnColumnName: cardio,
				calcsEPOCColumnName: epoc,
				calcsTotalBurnColumnName: total,
			}
		);
	}

	Future<int> deleteCalc(int id) async
	{
		final db = await database;

		return await db.delete
		(
			calcsTableName, // Table name that the info is being inserted into
			where: "$calcsIDColumnName = ?",
			whereArgs: [id]
		);
	}

	// Returns an int to notify that a successful addition took place
	Future<int> addTDEE(double bmr, double tdee, double weight) async
	{
		final db = await database;

		return await db.insert
		(
			tdeeTableName, // Table name that the info is being inserted into
			{	// A map with the column's name on the left and the values on the right
				tdeeTDEEColumnName: tdee,
				tdeeBMRColumnName: bmr,
				tdeeWeightColumnName: weight,
			}
		);
	}

	Future<int> updateTDEE(double bmr, double tdee, double weight) async
	{
		final db = await database;

		return await db.update
		(
			tdeeTableName,
			{tdeeBMRColumnName: bmr, tdeeTDEEColumnName: tdee, tdeeWeightColumnName: weight}, // New info being updated
			where: "$tdeeIDColumnName = ?",
			whereArgs: [1],
			conflictAlgorithm: ConflictAlgorithm.replace
		);
	}

	Future<bool> hasExistingTdee() async
	{
		final db = await database;
		final result = await db.rawQuery("SELECT COUNT(*) FROM $tdeeTableName");
		int? count = Sqflite.firstIntValue(result);
		
		return count != null && count > 0;
	}
}