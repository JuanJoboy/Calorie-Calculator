import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper
{
	static Database? _db;
	static const int _currentVersion = 2;
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

	DatabaseHelper._constructor();

	Future<Database> get database async
	{
		return _db ??= await getDatabase(); // Return the database if it isn't null, otherwise call getDatabase and return the value from that
	}

	Future<Database> getDatabase() async
	{
		final String databaseDirPath = await getDatabasesPath();
		final String databasePath = join(databaseDirPath, "master_db.db");

		final Database database = await openDatabase
		(
			databasePath,
			version: _currentVersion,
			onCreate: (db, version)
			{
				db.execute
				('''
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
				''');
			},
			onUpgrade: (db, oldVersion, newVersion) async
			{
				if (oldVersion < 2)
				{
					await db.execute("ALTER TABLE $calcsTableName ADD COLUMN $calcsWeightColumnName REAL NOT NULL DEFAULT 0.0");
				}
			},
		);

		return database;
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
}