import 'package:flutter/material.dart';

class Calculation
{
	final double bmr;
	final double tdee;
	final double weightLiftingBurn;
	final double cardioBurn;
	final double epoc;
	final double totalBurn;

	const Calculation({required this.bmr, required this.tdee, required this.weightLiftingBurn, required this.cardioBurn, required this.epoc, required this.totalBurn});
}

class CalculationFields extends ChangeNotifier
{
	String w = "";
	String h = "";
	String a = "";
	String m = "";
	String wd = "";
	String d = "";
	String e = "";

	void updateControllers({String? weight, String? height, String? age, String? workoutDuration, String? distance})
	{
		// If the parameter isn't null, then save the value, so that when the page rebuilds, it rebuilds with this value
		if(weight != null) w = weight;
		if(height != null) h = height;
		if(age != null) a = age;
		if(workoutDuration != null) wd = workoutDuration;
		if(distance != null) d = distance;
	}
}

class AllCalculations extends ChangeNotifier
{
	final List<Calculation> calcList = List.empty(growable: true); // A master list that contains every calc

	void uploadCalc(Calculation calc)
	{
		calcList.insert(0, calc);
		
		notifyListeners();
	}
}