import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/database/database.dart';

class Calculation
{
	final int? id;
	final String date;
	final double personWeight;
	final double bmr;
	final double tdee;
	final double weightLiftingBurn;
	final double cardioBurn;
	final double epoc;
	final double totalBurn;

	const Calculation({required this.id, required this.date, required this.personWeight, required this.bmr, required this.tdee, required this.weightLiftingBurn, required this.cardioBurn, required this.epoc, required this.totalBurn});

	factory Calculation.fromMap(Map<String, dynamic> map, DatabaseHelper db)
	{
		return Calculation
		(
			id: map[db.calcsIDColumnName],
			date: map[db.calcsDateColumnName],
			personWeight: (map[db.calcsWeightColumnName] as num).toDouble(),
			bmr: (map[db.calcsBMRColumnName] as num).toDouble(),
			tdee: (map[db.calcsTDEEColumnName] as num).toDouble(),
			weightLiftingBurn: (map[db.calcsWeightLiftingBurnColumnName] as num).toDouble(),
			cardioBurn: (map[db.calcsCardioBurnColumnName] as num).toDouble(),
			epoc: (map[db.calcsEPOCColumnName] as num).toDouble(),
			totalBurn: (map[db.calcsTotalBurnColumnName] as num).toDouble()
		);
	}
}

class CalculationFields extends ChangeNotifier
{
	String w = "";
	String h = "";
	String a = "";
	String m = "";
	String s = "";
	String up = "";
	String ac = "";
	String lo = "";
	String d = "";
	String e = "";
	double? met;

	void updateControllers({String? weight, String? height, String? age, String? sport, String? upper, String? accessories, String? lower, String? distance, double? metFactor})
	{
		// If the parameter isn't null, then save the value, so that when the page rebuilds, it rebuilds with this value
		if(weight != null) w = weight;
		if(height != null) h = height;
		if(age != null) a = age;
		if(sport != null) s = sport;
		if(upper != null) up = upper;
		if(accessories != null) ac = accessories;
		if(lower != null) lo = lower;
		if(distance != null) d = distance;
		if(metFactor != null) met = metFactor;
	}

	void resetControllers()
	{
		w = "";
		h = "";
		a = "";
		m = "";
		s = "";
		up = "";
		ac = "";
		lo = "";
		d = "";
		e = "";
		met = null;
	}
}

class AllCalculations extends ChangeNotifier
{
	List<Calculation> calcList = List.empty(growable: true); // A master list that contains every calc

	Future<void> init() async
	{
		await loadCalcs();
		notifyListeners();
	}

	Future<void> loadCalcs() async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;
		final List<Map<String, dynamic>> calcMap = await db.query(dbInstance.calcsTableName, orderBy: "${dbInstance.calcsIDColumnName} DESC");

		calcList = calcMap.map((m) => Calculation.fromMap(m, dbInstance)).toList();
		notifyListeners();
	}

	void uploadCalc(Calculation calc) async
	{
		final DatabaseHelper dbHelper = DatabaseHelper.instance;
		final int id = await dbHelper.addCalc(DateTime.now().toIso8601String(), calc.personWeight, calc.bmr, calc.tdee, calc.weightLiftingBurn, calc.cardioBurn, calc.epoc, calc.totalBurn);
		final Calculation savedCalc = Calculation(id: id, date: calc.date, personWeight: calc.personWeight, bmr: calc.bmr, tdee: calc.tdee, weightLiftingBurn: calc.weightLiftingBurn, cardioBurn: calc.cardioBurn, epoc: calc.epoc, totalBurn: calc.totalBurn);

		calcList.insert(0, savedCalc);
		notifyListeners();
	}

	void deleteCalc(int index) async
	{
		final Calculation calc = calcList[index];
		final DatabaseHelper dbHelper = DatabaseHelper.instance;

		if(calc.id != null)
		{
			await dbHelper.deleteCalc(calc.id!);
		}

		calcList.remove(calc);
		notifyListeners();
	}
}

class UsersTdee
{
	final int? id;
	final double bmr;
	final double tdee;
	final double weight;
	final double age;
	final bool male;

	const UsersTdee({required this.id, required this.bmr, required this.tdee, required this.weight, required this.age, required this.male});

	factory UsersTdee.fromMap(Map<String, dynamic> map, DatabaseHelper db)
	{
		return UsersTdee
		(
			id: map[db.tdeeIDColumnName],
			bmr: (map[db.tdeeBMRColumnName] as num).toDouble(),
			tdee: (map[db.tdeeTDEEColumnName] as num).toDouble(),
			weight: (map[db.tdeeWeightColumnName] as num).toDouble(),
			age: (map[db.tdeeAgeColumnName] as num).toDouble(),
			male: (map[db.tdeeGenderColumnName]) == 1,
		); 
	}
}

class UsersTdeeNotifier extends ChangeNotifier
{
	UsersTdee? usersTdee;

	Future<void> init() async
	{
		await loadTdee();
		notifyListeners();
	}

	Future<void> loadTdee() async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;
		final List<Map<String, dynamic>> maps = await db.query(dbInstance.tdeeTableName, limit: 1); // Stops after the first search cause there's only one entry

		if(maps.isNotEmpty)
		{
			usersTdee = UsersTdee.fromMap(maps.first, dbInstance);
		}
		
		notifyListeners();
	}
 
	void uploadOrEditTdee(double bmr, double tdee, double weight, double age, bool male) async
	{
		final DatabaseHelper dbHelper = DatabaseHelper.instance;

    	if (usersTdee == null)
		{
			final int id = await dbHelper.addTDEE(bmr, tdee, weight, age, male);
			usersTdee = UsersTdee(id: id, bmr: bmr, tdee: tdee, weight: weight, age: age, male: male);
		}
		else
		{
			await dbHelper.updateTDEE(bmr, tdee, weight, age, male);
			usersTdee = UsersTdee(id: 1, bmr: bmr, tdee: tdee, weight: weight, age: age, male: male);
		}

		notifyListeners();
	}
}