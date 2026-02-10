import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper
{
	static Database? _db;
	static const int _currentVersion = 1;
	static final DatabaseHelper instance = DatabaseHelper._constructor(); // Makes a singleton

	// Single Calculation Table
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

	// TDEE Table
	final String tdeeTableName = "tdee";
	final String tdeeIDColumnName = "id";
	final String tdeeTDEEColumnName = "tdee";
	final String tdeeBMRColumnName = "bmr";
	final String tdeeWeightColumnName = "weight";
	final String tdeeAgeColumnName = "age";
	final String tdeeGenderColumnName = "gender";

	// Week-Folder Table
	final String weeklyPlansTableName = "weekly_plans";
	final String weeklyPlansIDColumnName = "id";
	final String weeklyPlansFolderNameColumnName = "folder_name";

	// TDEE Stuff but only for the Weekly Planner
	final String weeklyTdeeTableName = "weekly_tdee";
	final String weeklyTdeeWeeklyPlanIDColumnName = "weekly_plan_id";
	final String weeklyTdeeWeightColumnName = "weight";
	final String weeklyTdeeAgeColumnName = "age";
	final String weeklyTdeeMaleColumnName = "male";
	final String weeklyTdeeAdditionalCaloriesColumnName = "additional_calories";
	final String weeklyTdeeBMRColumnName = "bmr";
	final String weeklyTdeeTDEEColumnName = "tdee";

	// Day Table Within The Week-Folder
	final String dailyEntriesTableName = "daily_entries";
	final String dailyEntriesIDColumnName = "id";
	final String dailyEntriesWeeklyPlanIDColumnName = "weekly_plan_id";
	final String dailyEntriesDayIDColumnName = "day_of_the_week";
	final String dailyEntriesActivityFactorColumnName = "activity_factor";
	final String dailyEntriesActivityNameColumnName = "activity_name";
	final String dailyEntriesActivityBurnColumnName = "activity_burn";
	final String dailyEntriesSportDurationColumnName = "sport_duration";
	final String dailyEntriesUpperDurationColumnName = "upper_duration";
	final String dailyEntriesAccessoriesDurationColumnName = "accessories_duration";
	final String dailyEntriesLowerDurationColumnName = "lower_duration";
	final String dailyEntriesCardioFactorColumnName = "cardio_factor";
	final String dailyEntriesCardioNameColumnName = "cardio_name";
	final String dailyEntriesCardioBurnColumnName = "cardio_burn";
	final String dailyEntriesCardioDistanceColumnName = "cardio_distance";
	final String dailyEntriesEpocFactorColumnName = "epoc_factor";
	final String dailyEntriesEpocNameColumnName = "epoc_name";
	final String dailyEntriesEpocBurnColumnName = "epoc_burn";
	final String dailyEntriesProteinIntensityColumnName = "protein_intensity";
	final String dailyEntriesFatIntakeColumnName = "fat_intake";

	DatabaseHelper._constructor();

	Future<Database> get database async
	{
		return _db ??= await getDatabase(); // Return the database if it isn't null, otherwise call getDatabase and return the value from that
	}

	Future<Database> getDatabase() async
	{
		final String databaseDirPath = await getDatabasesPath();
		final String databasePath = join(databaseDirPath, "master_db_v2.db"); // When in doubt regarding sql, its probably an onCreate issue or you can just rename the .db file to ensure that the old .db file isn't interfering.

		return await openDatabase
		(
			databasePath,
			version: _currentVersion,
			onConfigure: (db) async
			{
				await db.execute('PRAGMA foreign_keys = ON');
			},
			onCreate: (db, version) async
			{
				await db.execute
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

				await db.execute
				(
					'''
						CREATE TABLE $tdeeTableName (
							$tdeeIDColumnName INTEGER PRIMARY KEY DEFAULT 1,
							$tdeeTDEEColumnName REAL NOT NULL,
							$tdeeBMRColumnName REAL NOT NULL,
							$tdeeWeightColumnName REAL NOT NULL,
							$tdeeAgeColumnName REAL NOT NULL,
							$tdeeGenderColumnName INTEGER NOT NULL
						)
					'''
				);

				await db.execute
				(
					'''
						CREATE TABLE $weeklyPlansTableName (
							$weeklyPlansIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
							$weeklyPlansFolderNameColumnName TEXT NOT NULL
						)
					'''
				);

				await db.execute
				(
					'''
						CREATE TABLE $weeklyTdeeTableName (
							$weeklyTdeeWeeklyPlanIDColumnName INTEGER PRIMARY KEY,
							$weeklyTdeeWeightColumnName REAL NOT NULL,
							$weeklyTdeeAgeColumnName REAL NOT NULL,
							$weeklyTdeeMaleColumnName INTEGER NOT NULL,
							$weeklyTdeeAdditionalCaloriesColumnName REAL NOT NULL,
							$weeklyTdeeBMRColumnName REAL NOT NULL,
							$weeklyTdeeTDEEColumnName REAL NOT NULL,
							FOREIGN KEY ($weeklyTdeeWeeklyPlanIDColumnName)
								REFERENCES $weeklyPlansTableName ($weeklyPlansIDColumnName)
								ON DELETE CASCADE
								ON UPDATE CASCADE
						)
					'''
				);

				await db.execute
				(
					'''
						CREATE TABLE $dailyEntriesTableName (
							$dailyEntriesIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
							$dailyEntriesWeeklyPlanIDColumnName INTEGER NOT NULL,
							$dailyEntriesDayIDColumnName INTEGER NOT NULL,
							$dailyEntriesActivityFactorColumnName REAL NOT NULL,
							$dailyEntriesActivityNameColumnName TEXT NOT NULL,
							$dailyEntriesActivityBurnColumnName REAL NOT NULL,
							$dailyEntriesSportDurationColumnName REAL NOT NULL,
							$dailyEntriesUpperDurationColumnName REAL NOT NULL,
							$dailyEntriesAccessoriesDurationColumnName REAL NOT NULL,
							$dailyEntriesLowerDurationColumnName REAL NOT NULL,
							$dailyEntriesCardioFactorColumnName REAL NOT NULL,
							$dailyEntriesCardioNameColumnName TEXT NOT NULL,
							$dailyEntriesCardioBurnColumnName REAL NOT NULL,
							$dailyEntriesCardioDistanceColumnName REAL NOT NULL,
							$dailyEntriesEpocFactorColumnName REAL NOT NULL,
							$dailyEntriesEpocNameColumnName TEXT NOT NULL,
							$dailyEntriesEpocBurnColumnName REAL NOT NULL,
							$dailyEntriesProteinIntensityColumnName REAL NOT NULL,
							$dailyEntriesFatIntakeColumnName REAL NOT NULL,
							UNIQUE($dailyEntriesWeeklyPlanIDColumnName, $dailyEntriesDayIDColumnName),
							FOREIGN KEY ($dailyEntriesWeeklyPlanIDColumnName)
								REFERENCES $weeklyPlansTableName ($weeklyPlansIDColumnName)
								ON DELETE CASCADE
								ON UPDATE CASCADE
						)
					'''
				);
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
	Future<int> addTDEE(double bmr, double tdee, double weight, double age, bool male) async
	{
		final db = await database;

		return await db.insert
		(
			tdeeTableName, // Table name that the info is being inserted into
			{	// A map with the column's name on the left and the values on the right
				tdeeTDEEColumnName: tdee,
				tdeeBMRColumnName: bmr,
				tdeeWeightColumnName: weight,
				tdeeAgeColumnName: age,
				tdeeGenderColumnName: male == true ? 1 : 0
			}
		);
	}

	Future<int> updateTDEE(double bmr, double tdee, double weight, double age, bool male) async
	{
		final db = await database;

		return await db.update
		(
			tdeeTableName,
			{
				tdeeBMRColumnName: bmr,
				tdeeTDEEColumnName: tdee,
				tdeeWeightColumnName: weight,
				tdeeAgeColumnName: age,
				tdeeGenderColumnName: male == true ? 1 : 0
			}, // New info being updated
			where: "$tdeeIDColumnName = ?",
			whereArgs: [1],
			conflictAlgorithm: ConflictAlgorithm.replace
		);
	}

	Future<int> addWeeklyPlan(String folderName, {DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.insert
		(
			weeklyPlansTableName,
			{
				weeklyPlansFolderNameColumnName: folderName,
			}
		);
	}

	Future<int> updateWeeklyPlan(String folderName, int id, {DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.update
		(
			weeklyPlansTableName,
			{
				weeklyPlansFolderNameColumnName: folderName,
			},
			where: "$weeklyPlansIDColumnName = ?",
			whereArgs: [id],
			conflictAlgorithm: ConflictAlgorithm.replace
		);
	}

	Future<int> deleteWeeklyPlan(int id, {DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.delete
		(
			weeklyPlansTableName,
			where: "$weeklyPlansIDColumnName = ?",
			whereArgs: [id],
		);
	}

	Future<int> addWeeklyTdee({required int? weeklyPlanId, required double weight, required double age, required bool isMale, required double additionalCalories, required double bmr, required double tdee, DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.insert
        (
            weeklyTdeeTableName,
            {
                weeklyTdeeWeeklyPlanIDColumnName: weeklyPlanId,
                weeklyTdeeWeightColumnName: weight,
                weeklyTdeeAgeColumnName: age,
                weeklyTdeeMaleColumnName: isMale ? 1 : 0,
                weeklyTdeeAdditionalCaloriesColumnName: additionalCalories,
                weeklyTdeeBMRColumnName: bmr,
                weeklyTdeeTDEEColumnName: tdee,
            },
			conflictAlgorithm: ConflictAlgorithm.replace
        );
	}

	Future<List<Map<String, Object?>>> joinWeeklyTdeeToDailyEntry(int weekId, {DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.rawQuery
		(
			'''
				SELECT $dailyEntriesTableName.*,
					$weeklyTdeeTableName.$weeklyTdeeWeightColumnName AS weekly_weight, 
					$weeklyTdeeTableName.$weeklyTdeeAgeColumnName AS weekly_age, 
					$weeklyTdeeTableName.$weeklyTdeeMaleColumnName AS weekly_male, 
					$weeklyTdeeTableName.$weeklyTdeeAdditionalCaloriesColumnName AS weekly_additional, 
				    $weeklyTdeeTableName.$weeklyTdeeBMRColumnName AS weekly_bmr,
				    $weeklyTdeeTableName.$weeklyTdeeTDEEColumnName AS weekly_tdee
				FROM $dailyEntriesTableName
				LEFT JOIN $weeklyTdeeTableName
				ON $dailyEntriesTableName.$dailyEntriesWeeklyPlanIDColumnName = $weeklyTdeeTableName.$weeklyTdeeWeeklyPlanIDColumnName
				WHERE $dailyEntriesTableName.$dailyEntriesWeeklyPlanIDColumnName = ?
			''',
			[weekId]
		);
	}

	Future<int> addDailyEntry({required int? weeklyPlanId, required int dayId, required double activityFactor, required String activityName, required double activityBurn, required double sportDuration, required double upperDuration, required double accessoriesDuration, required double lowerDuration, required double cardioFactor, required String cardioName, required double cardioBurn, required double cardioDistance, required double epocFactor, required String epocName, required double epocBurn, required double proteinIntensity, required double fatIntake, DatabaseExecutor? txn}) async
    {
        final db = txn ?? await database;

		return await db.insert
        (
            dailyEntriesTableName,
            {
                dailyEntriesWeeklyPlanIDColumnName: weeklyPlanId,
                dailyEntriesDayIDColumnName: dayId,
                dailyEntriesActivityFactorColumnName: activityFactor,
                dailyEntriesActivityNameColumnName: activityName,
                dailyEntriesActivityBurnColumnName: activityBurn,
                dailyEntriesSportDurationColumnName: sportDuration,
                dailyEntriesUpperDurationColumnName: upperDuration,
                dailyEntriesAccessoriesDurationColumnName: accessoriesDuration,
                dailyEntriesLowerDurationColumnName: lowerDuration,
                dailyEntriesCardioFactorColumnName: cardioFactor,
                dailyEntriesCardioNameColumnName: cardioName,
                dailyEntriesCardioBurnColumnName: cardioBurn,
                dailyEntriesCardioDistanceColumnName: cardioDistance,
                dailyEntriesEpocFactorColumnName: epocFactor,
                dailyEntriesEpocNameColumnName: epocName,
                dailyEntriesEpocBurnColumnName: epocBurn,
                dailyEntriesProteinIntensityColumnName: proteinIntensity,
                dailyEntriesFatIntakeColumnName: fatIntake
            },
			conflictAlgorithm: ConflictAlgorithm.replace
        );
    }

	Future<int> updateDailyEntry({required int? id, required int? weeklyPlanId, required int dayId, required double activityFactor, required String activityName, required double activityBurn, required double sportDuration, required double upperDuration, required double accessoriesDuration, required double lowerDuration, required double cardioFactor, required String cardioName, required double cardioBurn, required double cardioDistance, required double epocFactor, required String epocName, required double epocBurn, required double proteinIntensity, required double fatIntake, DatabaseExecutor? txn}) async
	{
		final db = txn ?? await database;

		return await db.update
        (
            dailyEntriesTableName,
            {
                dailyEntriesWeeklyPlanIDColumnName: weeklyPlanId,
                dailyEntriesDayIDColumnName: dayId,
                dailyEntriesActivityFactorColumnName: activityFactor,
                dailyEntriesActivityNameColumnName: activityName,
                dailyEntriesActivityBurnColumnName: activityBurn,
                dailyEntriesSportDurationColumnName: sportDuration,
                dailyEntriesUpperDurationColumnName: upperDuration,
                dailyEntriesAccessoriesDurationColumnName: accessoriesDuration,
                dailyEntriesLowerDurationColumnName: lowerDuration,
                dailyEntriesCardioFactorColumnName: cardioFactor,
                dailyEntriesCardioNameColumnName: cardioName,
                dailyEntriesCardioBurnColumnName: cardioBurn,
                dailyEntriesCardioDistanceColumnName: cardioDistance,
                dailyEntriesEpocFactorColumnName: epocFactor,
                dailyEntriesEpocNameColumnName: epocName,
                dailyEntriesEpocBurnColumnName: epocBurn,
                dailyEntriesProteinIntensityColumnName: proteinIntensity,
                dailyEntriesFatIntakeColumnName: fatIntake
            },
			where: "$dailyEntriesIDColumnName = ?",
			whereArgs: [id],
			conflictAlgorithm: ConflictAlgorithm.replace
		);
	}

	Future<int> newPlanTransaction(String folderName, double weight, double age, bool isMale, double sliderNumber, double bmr, double tdee) async
	{
		final db = await database;

		int weeklyPlanId = -1;

		await db.transaction((txn) async
		{
			weeklyPlanId = await addWeeklyPlan(folderName, txn: txn);

			await addWeeklyTdee(weeklyPlanId: weeklyPlanId, weight: weight, age: age, isMale: isMale, additionalCalories: sliderNumber, bmr: bmr, tdee: tdee, txn: txn);

			for(int i = 0; i < 7; i++)
			{
				await addDailyEntry(weeklyPlanId: weeklyPlanId, dayId: i, activityFactor: 0, activityName: "", activityBurn: 0, sportDuration: 0, upperDuration: 0, accessoriesDuration: 0, lowerDuration: 0, cardioFactor: 0, cardioName: "", cardioBurn: 0, cardioDistance: 0, epocFactor: 0, epocName: "", epocBurn: 0, proteinIntensity: 1.6, fatIntake: 0.25, txn: txn);
			}
		});

		return weeklyPlanId;
	}

	Future<void> editPlanTransaction(int weeklyPlanId, String folderName, double weight, double age, bool isMale, double sliderNumber, double bmr, double tdee) async
	{
		final db = await database;

		await db.transaction((txn) async
		{
			await updateWeeklyPlan(folderName, weeklyPlanId, txn: txn);

			await addWeeklyTdee(weeklyPlanId: weeklyPlanId, weight: weight, age: age, isMale: isMale, additionalCalories: sliderNumber, bmr: bmr, tdee: tdee, txn: txn);
		});
	}
}