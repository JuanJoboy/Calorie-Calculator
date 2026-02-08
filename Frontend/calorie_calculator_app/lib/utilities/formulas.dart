import 'dart:math';
import 'package:calorie_calculator_app/pages/nutrition/diet.dart';

class CalorieMath
{
	static double totalCaloriesToday(double tdee, double activity, double cardio, double epoc, {double? additionalCalories})
	{
		final double total = tdee + activity + cardio + epoc + (additionalCalories ?? 0);

		return total;
	}

	static ({int bmr, int tdee, int activity, int cardio, int epoc, int totalCal, int totalBurn}) roundValues(double bmr, double tdee, double activity, double cardio, double epoc, double total)
	{
		return (bmr: bmr.round(), tdee: tdee.round(), activity: activity.round(), cardio: cardio.round(), epoc: epoc.round(), totalCal: total.round(), totalBurn: (total - tdee).round());
	}
}

class NutritionMath
{
	static int protein(double weight, double proteinIntensity)
	{
		final int protein = (weight * proteinIntensity).round();

		return protein;
	}

	static ({int totalFat, int saturatedFat, int unsaturatedFat, double omega3, double omega6, int cholesterol}) fat(double tdee, double fatIntake, bool male)
	{
		final int totalFat = ((tdee * fatIntake) / 9).round();
		final int saturatedFat = ((tdee * 0.1) / 9).round();
		final int unsaturatedFat = (totalFat - saturatedFat).round();
		final double omega3 = double.parse((max((male == true ? 1.6 : 1.1), (tdee * 0.01) / 9)).toStringAsFixed(2));
		final double omega6 = double.parse((max((male == true ? 17 : 12), (tdee * 0.05) / 9)).toStringAsFixed(2));
		final int cholesterol = 300;

		return (totalFat: totalFat, saturatedFat: saturatedFat, unsaturatedFat: unsaturatedFat, omega3: omega3, omega6: omega6, cholesterol: cholesterol);
	}

	static ({int totalCarb, int solubleFibre, int insolubleFibre, int sugar}) carb(double tdee, int totalProtein, int totalFat, double totalFibre)
	{
		final int carb = ((tdee - (totalProtein * 4) - (totalFat * 9)) / 4).round();
		final int fibre = (totalFibre).round();
		final int solubleFibre = (fibre * 0.4).round();
		final int insolubleFibre = (fibre * 0.6).round();
		final int sugar = ((tdee * 0.1) / 4).round();

		return (totalCarb: carb, solubleFibre: solubleFibre, insolubleFibre: insolubleFibre, sugar: sugar);
	}

	static ({double minBaseWater, double maxBaseWater, double minExerciseWater, double maxExerciseWater}) water(double weight, double activityDuration, double metFactor, double cardioDistance, double cardioFactor)
	{
		final double minBaseWater = double.parse((weight * 0.030).toStringAsFixed(2));
		final double maxBaseWater = double.parse((weight * 0.035).toStringAsFixed(2));

		final durationWater = waterDurationScaler(activityDuration, metFactor);
		
		final double minDurationWater = durationWater.min;
		final double maxDurationWater = durationWater.max;

		final double distanceWater = waterDistanceScaler(cardioDistance, cardioFactor);

		final double minExerciseWater = minDurationWater + distanceWater;
		final double maxExerciseWater = maxDurationWater + distanceWater;

		return (minBaseWater: minBaseWater, maxBaseWater: maxBaseWater, minExerciseWater: minExerciseWater, maxExerciseWater: maxExerciseWater);
	}

	static ({double min, double max}) waterDurationScaler(double activityDuration, double metFactor)
	{
		double multiplier;

		if(metFactor <= 0)
		{
			multiplier = 0.0;
		}
		else if(metFactor > 0 && metFactor < 4.0)
		{
			multiplier = 0.5;
		}
		else if(metFactor >= 4.0 && metFactor < 8.0)
		{
			multiplier = 1.0;
		}
		else
		{
			multiplier = 1.5;
		}

		// Baseline: 0.7L per hour of moderate work
		final double min = (activityDuration / 60) * 0.5 * multiplier;
		final double max = (activityDuration / 60) * 1 * multiplier;

		return (min: min, max: max);
	}

	static double waterDistanceScaler(double cardioDistance, double cardioFactor)
	{
		// Running (cardioFactor 1.0) approx 0.1L per km
		// Cycling (cardioFactor 0.33) approx 0.033L per km
		return cardioDistance * 0.1 * cardioFactor;
	}

	static int electrolyteCalculator(Micronutrient micro, bool male, double activityDuration, double metFactor, double cardioDistance, double cardioFactor)
	{
		double baseValue = male == true ? micro.maleValue : micro.femaleValue;

		final double durationSweat = durationBasedElectrolyteNumber(micro, activityDuration, metFactor);
		final double distanceSweat = distanceBasedElectrolyteNumber(micro, cardioDistance, cardioFactor);
		
		final int trueSweat = (baseValue + durationSweat + distanceSweat).round();

		return trueSweat;
	}

	static double durationBasedElectrolyteNumber(Micronutrient micro, double activityDuration, double metFactor)
	{
		double multiplier;

		if(metFactor <= 0)
		{
			multiplier = 0.0;
		}
		else if(metFactor > 0 && metFactor < 4.0)
		{
			multiplier = 0.5;
		}
		else if(metFactor >= 4.0 && metFactor < 8.0)
		{
			multiplier = 1.0;
		}
		else
		{
			multiplier = 1.5;
		}

		final double sweatScale = (activityDuration / 60) * multiplier;

		final int factor = durationSweatFactor[micro] ?? 0;

		final double sweat = sweatScale * factor;

		return sweat;
	}

	static final Map<Micronutrient, int> durationSweatFactor = 
	{
		Electrolytes.sodium: 250,
		Electrolytes.chloride: 250,
		Electrolytes.potassium: 50,
		Electrolytes.magnesium: 10,
	};

	static final Map<Micronutrient, double> distanceSweatFactor = 
	{
		Electrolytes.sodium: 65,
		Electrolytes.chloride: 65,
		Electrolytes.potassium: 12,
		Electrolytes.magnesium: 2.5,
	};

	static double distanceBasedElectrolyteNumber(Micronutrient micro, double cardioDistance, double cardioFactor)
	{
		final double factor = distanceSweatFactor[micro] ?? 0;

		final double sweat = cardioDistance * factor * cardioFactor;

		return sweat;
	}
}