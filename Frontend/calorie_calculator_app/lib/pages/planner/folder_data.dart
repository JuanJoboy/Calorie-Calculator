import 'package:calorie_calculator_app/database/database.dart';
import 'package:flutter/material.dart';

class FolderNotifier extends ChangeNotifier
{
	String name = "";

	void updateControllers({String? folderName})
	{
		if(folderName != null) name = folderName;
	}
}

class WeeklyPlan
{
	final int? id;
	final String folderName;

	const WeeklyPlan({required this.id, required this.folderName});

	factory WeeklyPlan.fromMap(Map<String, dynamic> map, DatabaseHelper db)
	{
		return WeeklyPlan
		(
			id: map[db.weeklyPlansIDColumnName],
			folderName: (map[db.weeklyPlansFolderNameColumnName] as String)
		); 
	}
}

class WeeklyPlanNotifier extends ChangeNotifier
{
	List<WeeklyPlan> weeklyPlans = List.empty(growable: true);
	
	Future<void> init() async
	{
		await loadPlans();
		notifyListeners();
	}

	Future<void> loadPlans() async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;
		final List<Map<String, dynamic>> weeklyPlansMap = await db.query(dbInstance.weeklyPlansTableName, orderBy: "${dbInstance.weeklyPlansIDColumnName} DESC");

		if(weeklyPlansMap.isNotEmpty)
		{
			weeklyPlans = weeklyPlansMap.map((m) => WeeklyPlan.fromMap(m, dbInstance)).toList();
		}
		
		notifyListeners();
	}
 
    Future<int> createWeeklyPlanShell() async
    {
        final DatabaseHelper dbHelper = DatabaseHelper.instance;
        return await uploadWeeklyPlan(dbHelper);
    }

    Future<void> uploadOrEditWeeklyPlan(String folderName, int? weeklyPlanId) async
    {
        final DatabaseHelper dbHelper = DatabaseHelper.instance;

        if(weeklyPlanId != null)
        {
            int realIndex = weeklyPlans.indexWhere((p) => p.id == weeklyPlanId);
            await dbHelper.updateWeeklyPlan(folderName, weeklyPlanId);
            weeklyPlans[realIndex] = WeeklyPlan(id: weeklyPlanId, folderName: folderName);
        }

        notifyListeners();
    }

    Future<int> uploadWeeklyPlan(DatabaseHelper dbHelper) async
    {
        final int id = await dbHelper.addWeeklyPlan("New Weekly Plan");
        weeklyPlans.insert(0, WeeklyPlan(id: id, folderName: "New Weekly Plan"));

        return id;
    }

	void deleteWeeklyPlan(int id) async
	{
		WeeklyPlan plan = weeklyPlans.firstWhere
		(
			(p) => p.id == id,
			orElse: () => const WeeklyPlan(id: -1, folderName: "")
		);

		if(plan.id == -1)
		{
			return; // Prevents deleting that fake plan and causing any errors.
		}

		final DatabaseHelper dbHelper = DatabaseHelper.instance;

		if(plan.id != null)
		{
			await dbHelper.deleteWeeklyPlan(plan.id!);
		}

		weeklyPlans.remove(plan);
		notifyListeners();
	}
}

class WeeklyTdee
{
	final int? id;
	final int? weeklyPlanId;
	final double weight;
	final double age;
	final bool isMale;
	final double additionalCalories;
	final double bmr;
	final double tdee;

	const WeeklyTdee
	({
		required this.id,
		required this.weeklyPlanId,
		required this.weight,
		required this.age,
		required this.isMale,
		required this.additionalCalories,
		required this.bmr,
		required this.tdee,
	});

	factory WeeklyTdee.fromMap(Map<String, dynamic> map, DatabaseHelper db)
	{
		return WeeklyTdee
		(
			id: map[db.dailyEntriesIDColumnName],
			weeklyPlanId: map[db.dailyEntriesWeeklyPlanIDColumnName],
			weight: (map[db.weeklyTdeeWeightColumnName] as num).toDouble(),
			age: (map[db.weeklyTdeeAgeColumnName] as num).toDouble(),
			isMale: map[db.weeklyTdeeMaleColumnName] == 1,
			additionalCalories: (map[db.weeklyTdeeAdditionalCaloriesColumnName] as num).toDouble(),
			bmr: (map[db.weeklyTdeeBMRColumnName] as num).toDouble(),
			tdee: (map[db.weeklyTdeeTDEEColumnName] as num).toDouble(),
		);
	}
}

class WeeklyTdeeNotifier extends ChangeNotifier
{
	Future<void> uploadOrEditWeeklyTdee({required int? weeklyPlanId, required double weight, required double age, required bool isMale, required double additionalCalories, required double bmr, required double tdee}) async
	{
		final DatabaseHelper dbHelper = DatabaseHelper.instance;

		await dbHelper.addWeeklyTdee(weeklyPlanId: weeklyPlanId, weight: weight, age: age, isMale: isMale, additionalCalories: additionalCalories, bmr: bmr, tdee: tdee);

		notifyListeners();
	}
}

class DailyEntry
{
	final int? id;
	final int? weeklyPlanId;
	final int dayId;
	final double weight;
	final double age;
	final bool isMale;
	final double additionalCalories;
	final double bmr;
	final double tdee;
	final double activityFactor;
	final String activityName;
	final double activityBurn;
	final double sportDuration;
	final double upperDuration;
	final double accessoriesDuration;
	final double lowerDuration;
	final double cardioFactor;
	final String cardioName;
	final double cardioBurn;
	final double cardioDistance;
	final double epocFactor;
	final String epocName;
	final double epocBurn;
	final double proteinIntensity;
	final double fatIntake;

	const DailyEntry
	({
		required this.id,
		required this.weeklyPlanId,
		required this.dayId,
		required this.weight,
		required this.age,
		required this.isMale,
		required this.additionalCalories,
		required this.bmr,
		required this.tdee,
		required this.activityFactor,
		required this.activityName,
		required this.activityBurn,
		required this.sportDuration,
		required this.upperDuration,
		required this.accessoriesDuration,
		required this.lowerDuration,
		required this.cardioFactor,
		required this.cardioName,
		required this.cardioBurn,
		required this.cardioDistance,
		required this.epocFactor,
		required this.epocName,
		required this.epocBurn,
		required this.proteinIntensity,
		required this.fatIntake,
	});

    const DailyEntry.freshDay
    ({
        this.id, // It's null so the row doesn't exist in the database yet, so it's safe to create. It won't override any other days 
        this.weeklyPlanId,
        required this.dayId,
        this.weight = 0.0, // Take from weekly_tdee table
        this.age = 0.0, // Take from weekly_tdee table
        this.isMale = true, // Take from weekly_tdee table
        this.additionalCalories = 0.0, // Take from weekly_tdee table
        this.bmr = 0.0, // Take from weekly_tdee table
        this.tdee = 0.0, // Take from weekly_tdee table
        this.activityFactor = 0.0,
        this.activityName = "",
        this.activityBurn = 0.0,
        this.sportDuration = 0.0,
        this.upperDuration = 0.0,
        this.accessoriesDuration = 0.0,
        this.lowerDuration = 0.0,
        this.cardioFactor = 0.0,
        this.cardioName = "",
        this.cardioBurn = 0.0,
        this.cardioDistance = 0.0,
        this.epocFactor = 0.0,
        this.epocName = "",
        this.epocBurn = 0.0,
        this.proteinIntensity = 1.6,
        this.fatIntake = 0.25,
    });

	factory DailyEntry.fromMap(Map<String, dynamic> map, DatabaseHelper db)
	{
		return DailyEntry
		(
			id: map[db.dailyEntriesIDColumnName],
			weeklyPlanId: map[db.dailyEntriesWeeklyPlanIDColumnName],
			dayId: map[db.dailyEntriesDayIDColumnName],
			weight: (map["weekly_weight"] as num).toDouble(),
			age: (map["weekly_age"] as num).toDouble(),
			isMale: map["weekly_male"] == 1,
			additionalCalories: (map["weekly_additional"] as num).toDouble(),
			bmr: (map["weekly_bmr"] as num).toDouble(),
			tdee: (map["weekly_tdee"] as num).toDouble(),
			activityFactor: (map[db.dailyEntriesActivityFactorColumnName] as num).toDouble(),
			activityName: map[db.dailyEntriesActivityNameColumnName] as String,
			activityBurn: (map[db.dailyEntriesActivityBurnColumnName] as num).toDouble(),
			sportDuration: (map[db.dailyEntriesSportDurationColumnName] as num).toDouble(),
			upperDuration: (map[db.dailyEntriesUpperDurationColumnName] as num).toDouble(),
			accessoriesDuration: (map[db.dailyEntriesAccessoriesDurationColumnName] as num).toDouble(),
			lowerDuration: (map[db.dailyEntriesLowerDurationColumnName] as num).toDouble(),
			cardioFactor: (map[db.dailyEntriesCardioFactorColumnName] as num).toDouble(),
			cardioName: map[db.dailyEntriesCardioNameColumnName] as String,
			cardioBurn: (map[db.dailyEntriesCardioBurnColumnName] as num).toDouble(),
			cardioDistance: (map[db.dailyEntriesCardioDistanceColumnName] as num).toDouble(),
			epocFactor: (map[db.dailyEntriesEpocFactorColumnName] as num).toDouble(),
			epocName: map[db.dailyEntriesEpocNameColumnName] as String,
			epocBurn: (map[db.dailyEntriesEpocBurnColumnName] as num).toDouble(),
			proteinIntensity: (map[db.dailyEntriesProteinIntensityColumnName] as num).toDouble(),
			fatIntake: (map[db.dailyEntriesFatIntakeColumnName] as num).toDouble(),
		);
	}
}

class DailyEntryNotifier extends ChangeNotifier
{
	List<DailyEntry> dailyEntries = List.generate
	(
		7,
		(int index)
		{
			return DailyEntry.freshDay(dayId: index);
		},
		growable: false
	);

	bool isLoading = false;

	Future<void> loadEntries(int weeklyPlanId) async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;
		isLoading = true;
		notifyListeners();

		// Reset to empty/fresh state
		dailyEntries = List.generate(7, (index) => DailyEntry.freshDay(dayId: index), growable: false);

		// Debug: See what is actually in the DB
		final List<Map<String, dynamic>> allRows = await db.query(dbInstance.dailyEntriesTableName);
		print("--- DB DEBUG ---");
		print("Total rows in table: ${allRows.length}");

		for (var row in allRows)
		{
			print("Entry ID: ${row[dbInstance.dailyEntriesIDColumnName]}, PlanID: ${row[dbInstance.dailyEntriesWeeklyPlanIDColumnName]}, Day: ${row[dbInstance.dailyEntriesDayIDColumnName]}");
		}

		// Perform specific query
		final List<Map<String, dynamic>> maps = await dbInstance.joinWeeklyTdeeToDailyEntry(weeklyPlanId);

		print("Rows found for Plan $weeklyPlanId: ${maps.length}");

		for (Map<String, dynamic> map in maps)
		{
			final DailyEntry entry = DailyEntry.fromMap(map, dbInstance);
			dailyEntries[entry.dayId] = entry;
		}

		isLoading = false;
		notifyListeners();
	}
 
	Future<void> uploadOrEditDailyEntry({required int? id, required int? weeklyPlanId, required int dayId, required double weight, required double age, required bool isMale, required double additionalCalories, required double bmr, required double tdee, required double activityFactor, required String activityName, required double activityBurn, required double sportDuration, required double upperDuration, required double accessoriesDuration, required double lowerDuration, required double cardioFactor, required String cardioName, required double cardioBurn, required double cardioDistance, required double epocFactor, required String epocName, required double epocBurn, required double proteinIntensity, required double fatIntake}) async
	{
		final DatabaseHelper dbHelper = DatabaseHelper.instance;

		int realIndex = dailyEntries.indexWhere((d) => d.dayId == dayId);
		
		if(id != null)
		{
			await dbHelper.updateDailyEntry(id: id, weeklyPlanId: weeklyPlanId, dayId: dayId, activityFactor: activityFactor, activityName: activityName, activityBurn: activityBurn, sportDuration: sportDuration, upperDuration: upperDuration, accessoriesDuration: accessoriesDuration, lowerDuration: lowerDuration, cardioFactor: cardioFactor, cardioName: cardioName, cardioBurn: cardioBurn, cardioDistance: cardioDistance, epocFactor: epocFactor, epocName: epocName, epocBurn: epocBurn, proteinIntensity: proteinIntensity, fatIntake: fatIntake);

			dailyEntries[realIndex] = DailyEntry(id: id, weeklyPlanId: weeklyPlanId, dayId: dayId, weight: weight, age: age, isMale: isMale, additionalCalories: additionalCalories, bmr: bmr, tdee: tdee, activityFactor: activityFactor, activityName: activityName, activityBurn: activityBurn, sportDuration: sportDuration, upperDuration: upperDuration, accessoriesDuration: accessoriesDuration, lowerDuration: lowerDuration, cardioFactor: cardioFactor, cardioName: cardioName, cardioBurn: cardioBurn, cardioDistance: cardioDistance, epocFactor: epocFactor, epocName: epocName, epocBurn: epocBurn, proteinIntensity: proteinIntensity, fatIntake: fatIntake);
		}
        else
        {
            final int newId = await dbHelper.addDailyEntry(weeklyPlanId: weeklyPlanId, dayId: dayId, activityFactor: activityFactor, activityName: activityName, activityBurn: activityBurn, sportDuration: sportDuration, upperDuration: upperDuration, accessoriesDuration: accessoriesDuration, lowerDuration: lowerDuration, cardioFactor: cardioFactor, cardioName: cardioName, cardioBurn: cardioBurn, cardioDistance: cardioDistance, epocFactor: epocFactor, epocName: epocName, epocBurn: epocBurn, proteinIntensity: proteinIntensity, fatIntake: fatIntake);

			dailyEntries[realIndex] = DailyEntry(id: newId, weeklyPlanId: weeklyPlanId, dayId: dayId, weight: weight, age: age, isMale: isMale, additionalCalories: additionalCalories, bmr: bmr, tdee: tdee, activityFactor: activityFactor, activityName: activityName, activityBurn: activityBurn, sportDuration: sportDuration, upperDuration: upperDuration, accessoriesDuration: accessoriesDuration, lowerDuration: lowerDuration, cardioFactor: cardioFactor, cardioName: cardioName, cardioBurn: cardioBurn, cardioDistance: cardioDistance, epocFactor: epocFactor, epocName: epocName, epocBurn: epocBurn, proteinIntensity: proteinIntensity, fatIntake: fatIntake);
        }

		notifyListeners();
	}
}