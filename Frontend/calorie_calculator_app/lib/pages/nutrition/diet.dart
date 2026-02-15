import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/formulas.dart';
import 'package:calorie_calculator_app/utilities/settings.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class DietPage extends StatefulWidget
{
	final double weight;
	final int tdee;
	final double metFactor;
	final String activityName;
	final int activityBurn;
	final double cardioFactor;
	final int sportDuration;
	final int upperDuration;
	final int accessoryDuration;
	final int lowerDuration;
	final String cardioName;
	final double cardioDistance;
	final int cardioBurn;
	final int epocBurn;
	final String epocIntensity;
	final int totalCaloriesBurned;
	final int caloricCeiling;
	final double proteinIntensity;
	final double fatIntake;
	final double fibre;
	final bool weeklyPlanner;

	const DietPage({
		super.key,
		required this.weight,
		required this.tdee,
		required this.metFactor,
		required this.activityName,
		required this.activityBurn,
		required this.cardioFactor,
		required this.sportDuration,
		required this.upperDuration,
		required this.accessoryDuration,
		required this.lowerDuration,
		required this.cardioName,
		required this.cardioDistance,
		required this.cardioBurn,
		required this.epocBurn,
		required this.epocIntensity,
		required this.totalCaloriesBurned,
		required this.caloricCeiling,
		required this.proteinIntensity,
		required this.fatIntake,
		required this.fibre,
		required this.weeklyPlanner,
	});

	const DietPage.noActivity({
		super.key,
		required this.weight,
		required this.tdee,
		this.metFactor = 0,
		this.activityName = "",
		this.activityBurn = 0,
		this.cardioFactor = 0,
		this.sportDuration = 0,
		this.upperDuration = 0,
		this.accessoryDuration = 0,
		this.lowerDuration = 0,
		this.cardioName = "",
		this.cardioDistance = 0,
		this.cardioBurn = 0,
		this.epocBurn = 0,
		this.epocIntensity = "",
		this.totalCaloriesBurned = 0,
		this.caloricCeiling = 0,
		required this.proteinIntensity,
		required this.fatIntake,
		required this.fibre,
		this.weeklyPlanner = false,
	});

	@override
	State<DietPage> createState() => _DietPageState();
}

enum DietView
{
	calories,
	macros,
	water,
	micros
}

abstract interface class Micronutrient
{
	double get maleValue;
	double get femaleValue;
	String get label;
	String get unit;
} 

enum WaterSoluble implements Micronutrient
{
	vitaminC(maleValue: 90, femaleValue: 75, label: 'Vitamin C', unit: 'mg'),
	thiamin(maleValue: 1.2, femaleValue: 1.1, label: 'Thiamin (B1)', unit: 'mg'),
	riboflavin(maleValue: 1.3, femaleValue: 1.1, label: 'Riboflavin (B2)', unit: 'mg'),
	niacin(maleValue: 16, femaleValue: 14, label: 'Niacin (B3)', unit: 'mg'),
	choline(maleValue: 550, femaleValue: 425, label: 'Choline (B4)', unit: 'mg'),
	pantothenicAcid(maleValue: 5, femaleValue: 5, label: 'Pantothenic Acid (B5)', unit: 'mg'),
	vitaminB6(maleValue: 1.3, femaleValue: 1.3, label: 'Vitamin B6', unit: 'mg'),
	biotin(maleValue: 30, femaleValue: 30, label: 'Biotin (B7)', unit: 'mcg'),
	folate(maleValue: 400, femaleValue: 400, label: 'Folate (B9)', unit: 'mcg'),
	vitaminB12(maleValue: 2.4, femaleValue: 2.4, label: 'Vitamin B12', unit: 'mcg');

	@override
	final double maleValue;
	@override
	final double femaleValue;
	@override
	final String label;
	@override
	final String unit;

	const WaterSoluble({required this.maleValue, required this.femaleValue, required this.label, required this.unit});
}

enum FatSoluble implements Micronutrient
{
	vitaminA(maleValue: 900, femaleValue: 700, label: 'Vitamin A', unit: 'mcg'),
	vitaminD(maleValue: 15, femaleValue: 15, label: 'Vitamin D', unit: 'mcg'),
	vitaminE(maleValue: 15, femaleValue: 15, label: 'Vitamin E', unit: 'mg'),
	vitaminK(maleValue: 120, femaleValue: 90, label: 'Vitamin K', unit: 'mcg');

	@override
	final double maleValue;
	@override
	final double femaleValue;
	@override
	final String label;
	@override
	final String unit;

	const FatSoluble({required this.maleValue, required this.femaleValue, required this.label, required this.unit});
}

enum Electrolytes implements Micronutrient
{
	calcium(maleValue: 1000, femaleValue: 1000, label: 'Calcium', unit: 'mg'),
	magnesium(maleValue: 420, femaleValue: 320, label: 'Magnesium', unit: 'mg'),
	potassium(maleValue: 3400, femaleValue: 2600, label: 'Potassium', unit: 'mg'),
	sodium(maleValue: 2300, femaleValue: 2300, label: 'Sodium', unit: 'mg'),
	phosphorus(maleValue: 700, femaleValue: 700, label: 'Phosphorus', unit: 'mg'),
	chloride(maleValue: 2300, femaleValue: 2300, label: 'Chloride', unit: 'mg');

	@override
	final double maleValue;
	@override
	final double femaleValue;
	@override
	final String label;
	@override
	final String unit;

	const Electrolytes({required this.maleValue, required this.femaleValue, required this.label, required this.unit});
}

enum TraceMinerals implements Micronutrient
{
	iron(maleValue: 8, femaleValue: 18, label: 'Iron', unit: 'mg'),
	zinc(maleValue: 11, femaleValue: 8, label: 'Zinc', unit: 'mg'),
	copper(maleValue: 900, femaleValue: 900, label: 'Copper', unit: 'mcg'),
	manganese(maleValue: 2.3, femaleValue: 1.8, label: 'Manganese', unit: 'mg'),
	iodine(maleValue: 150, femaleValue: 150, label: 'Iodine', unit: 'mcg'),
	selenium(maleValue: 55, femaleValue: 55, label: 'Selenium', unit: 'mcg'),
	molybdenum(maleValue: 45, femaleValue: 45, label: 'Molybdenum', unit: 'mcg'),
	fluoride(maleValue: 4, femaleValue: 3, label: 'Fluoride', unit: 'mg'),
	chromium(maleValue: 35, femaleValue: 25, label: 'Chromium', unit: 'mcg');

	@override
	final double maleValue;
	@override
	final double femaleValue;
	@override
	final String label;
	@override
	final String unit;

	const TraceMinerals({required this.maleValue, required this.femaleValue, required this.label, required this.unit});
}

class _DietPageState extends State<DietPage>
{
	late DietView activeView;

	@override
	void initState()
	{
		super.initState();

		activeView = widget.weeklyPlanner == true ? DietView.calories : DietView.macros;
	}

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Analysis")),
			body: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Center
				(
					child: Column
					(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children:
						[
							const Padding(padding: EdgeInsetsGeometry.only(top: 40)),

							SegmentedButton<DietView>
							(
								segments: segments(),
								selected: {activeView},
								onSelectionChanged: (Set<DietView> views)
								{
									setState(()
									{
										activeView = views.first;
									});
								},
							),

							const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

							AnimatedSwitcher
							(
								duration: const Duration(milliseconds: 200),
								child: displayAll(),
							),

							const Padding(padding: EdgeInsetsGeometry.only(top: 100)),
						],
					)
				)
			)
		);
  	}

	List<ButtonSegment<DietView>> segments()
	{
		if(widget.weeklyPlanner == true)
		{
			return const
			[
				ButtonSegment(value: DietView.calories, label: Text('Calories', style: TextStyle(fontSize: 12)), icon: Icon(Icons.fitness_center)),
				ButtonSegment(value: DietView.macros, label: Text('Macros', style: TextStyle(fontSize: 12)), icon: Icon(Icons.pie_chart)),
				ButtonSegment(value: DietView.water, label: Text('Water', style: TextStyle(fontSize: 12)), icon: Icon(Icons.water_drop)),
				ButtonSegment(value: DietView.micros, label: Text('Micros', style: TextStyle(fontSize: 12)), icon: Icon(Icons.biotech))
			];
		}
		else
		{
			return const
			[
				ButtonSegment(value: DietView.macros, label: Text('Macros'), icon: Icon(Icons.pie_chart)),
				ButtonSegment(value: DietView.water, label: Text('Water'), icon: Icon(Icons.water_drop)),
				ButtonSegment(value: DietView.micros, label: Text('Micros'), icon: Icon(Icons.biotech))
			];
		}
	}

	Widget displayAll()
	{
		// Protein
		final int protein = NutritionMath.protein(widget.weight, widget.proteinIntensity);

		// Fats
		final (:totalFat, :saturatedFat, :unsaturatedFat, :omega3, :omega6, :cholesterol) = NutritionMath.fat(widget.tdee.roundToDouble(), widget.fatIntake, widget.fibre == 30);

		// Carbs
		final (:totalCarb, :solubleFibre, :insolubleFibre, :sugar) = NutritionMath.carb(widget.tdee.roundToDouble(), protein, totalFat, widget.fibre);

		// Water
		final double activityDuration = CalorieMath.totalDuration(widget.sportDuration, widget.upperDuration, widget.accessoryDuration, widget.lowerDuration);

		final (:minBaseWater, :maxBaseWater, :minExerciseWater, :maxExerciseWater) = NutritionMath.water(widget.weight, activityDuration, widget.metFactor, widget.cardioDistance, widget.cardioFactor, context);

		final bool noActivity = widget.activityBurn == 0 && widget.cardioBurn == 0;

		switch(activeView)
		{
			case DietView.calories:
				return Column
				(
					key: const ValueKey(0),
					children:
					[
						Utils.header(noActivity == true ? "Rest Day 😴" : "Training Day 🔥", 30, FontWeight.bold),
	
						activityCard(widget.activityBurn != 0, widget.activityName, widget.activityBurn),
	
						activityCard(widget.cardioBurn != 0, widget.cardioName, widget.cardioBurn),

						activityCard(!noActivity, "EPOC", widget.epocBurn),

						calorieCard(widget.tdee, widget.totalCaloriesBurned, widget.caloricCeiling)
					],
				);
			case DietView.macros:
				return Column
				(
					key: const ValueKey(1),
					children:
					[
						Utils.header("Protein", 25, FontWeight.w600),
						displayInfo("Total Protein", "$protein", "g", padding: 20, width: 90),
						
						Utils.header("Fats", 25, FontWeight.w600),
						displayInfo("Total Fat", "$totalFat", "g", padding: 20, width: 90),
						displayInfo("Saturated Fat", "$saturatedFat", "g", padding: 20, width: 90),
						displayInfo("Unsaturated Fat", "$unsaturatedFat", "g", padding: 20, width: 90),
						displayInfo("Omega-3", "$omega3", "g", padding: 20, width: 90),
						displayInfo("Omega-6", "$omega6", "g", padding: 20, width: 90),
						displayInfo("Cholesterol", "$cholesterol", "mg", padding: 35, width: 90),
						
						Utils.header("Carbohydrates", 25, FontWeight.w600),
						displayInfo("Total Carbs", "$totalCarb", "g", padding: 20, width: 90),
						displayInfo("Soluble Fibre", "$solubleFibre", "g", padding: 20, width: 90),
						displayInfo("Insoluble Fibre", "$insolubleFibre", "g", padding: 20, width: 90),
						displayInfo("Max Sugar", "$sugar", "g", padding: 20, width: 90),
					],
				);
			case DietView.water:
				return Column
				(
					key: const ValueKey(2),
					children:
					[
						Utils.header("Daily Hydration", 25, FontWeight.w600),
						displayInfo("Base Intake", "$minBaseWater - $maxBaseWater", context.watch<WaterNotifier>().currentUnit.symbol, padding: 20, width: 130),
						displayInfo("Exercise Add-on", "$minExerciseWater - $maxExerciseWater", context.watch<WaterNotifier>().currentUnit.symbol, padding: 20, width: 130),
					],
				);
			case DietView.micros:
				return Column
				(
					key: const ValueKey(3),
					children:
					[
						micronutrients("Water Soluble", WaterSoluble.values, activityDuration),
						
						micronutrients("Fat Soluble", FatSoluble.values, activityDuration),
						
						micronutrients("Electrolytes", Electrolytes.values, activityDuration),

						micronutrients("Trace Minerals", TraceMinerals.values, activityDuration),
					],
				);
		}
	}

	Widget activityCard(bool condition, String activity, int caloricValue)
	{
		return condition ? Padding
		(
			padding: const EdgeInsets.only(top: 40.0),
			child: LayoutBuilder
			(
				builder: (context, constraints)
				{
					return SizedBox
					(
						width: constraints.maxWidth - 10,
						child: Card
						(
							color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
							shape: RoundedRectangleBorder
							(
								side: BorderSide
								(
									color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
									width: 4
								),
								borderRadius: BorderRadiusGeometry.circular(20)
							),
							child: Column
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[					
									Utils.header(activity, 25, FontWeight.w600, padding: 20),

									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									BulletedList
									(
										listItems: activityDurations(activity),
										bullet: Icon(((activity == "EPOC" ? Icons.trending_up : (activity == Cardio.run.label || activity == Cardio.cycle.label) ? Icons.route_rounded : Icons.alarm_rounded)), size: 30, color: Theme.of(context).extension<AppColours>()!.runSeColour!),
									),

									BulletedList
									(
										listItems: [richText("Calories Burned", intValue: caloricValue, unit: "kcal", padding: 20)],
										bullet: Icon(Icons.whatshot_rounded, size: 30, color: Theme.of(context).extension<AppColours>()!.caloricBurn!),
									),
								],
							),
						)
					);
				}
			)
		) : const SizedBox();
	}

	Widget calorieCard(int tdee, int total, int ceiling)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 40.0),
			child: LayoutBuilder
			(
				builder: (context, constraints)
				{
					return SizedBox
					(
						width: constraints.maxWidth - 10,
						child: Card
						(
							color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
							shape: RoundedRectangleBorder
							(
								side: BorderSide
								(
									color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
									width: 4
								),
								borderRadius: BorderRadiusGeometry.circular(20)
							),
							child: Column
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[					
									Utils.header("Caloric Breakdown", 25, FontWeight.w600, padding: 20),

									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									BulletedList
									(
										listItems: [richText("Base TDEE", intValue: tdee, unit: "kcal", padding: 15)],
										bullet: Icon(Icons.self_improvement_rounded, size: 30, color: Theme.of(context).extension<AppColours>()!.bmr!)
									),

									BulletedList
									(
										listItems: [richText("Total Calories Burned", intValue: total, unit: "kcal", padding: 15)],
										bullet: Icon(Icons.workspace_premium_rounded, size: 30, color: Theme.of(context).extension<AppColours>()!.caloricBurn!)
									),

									BulletedList
									(
										listItems: [richText("Caloric Ceiling", intValue: ceiling, unit: "kcal", padding: 15)],
										bullet: Icon(Icons.vertical_align_top, size: 30, color: Theme.of(context).extension<AppColours>()!.femaleSeColour!)
									),
								],
							),
						)
					);
				}
			)
		);
	}

	List<Widget> activityDurations(String activity)
	{
		if(activity.contains("Weights"))
		{
			return <Widget>
			[
				richText("Upper Body", intValue: widget.upperDuration, unit: "min"),
				richText("Accessories", intValue: widget.accessoryDuration, unit: "min"),
				richText("Lower Body", intValue: widget.lowerDuration, unit: "min"),
			];
		}
		else if(activity == Cardio.run.label || activity == Cardio.cycle.label)
		{
			return <Widget>
			[
				richText("Distance", doubleValue: widget.cardioDistance, unit: "km"),
			];
		}
		else if(activity == "EPOC")
		{
			return <Widget>
			[
				richText("Intensity", epocValue: widget.epocIntensity),
			];
		}
		else
		{
			return <Widget>
			[
				richText("Duration", intValue: widget.sportDuration, unit: "min"),
			];
		}
	}

	Widget richText(String text, {String? unit, double? padding, int? intValue, double? doubleValue, String? epocValue})
	{
		bool useEpoc = false;
		if(epocValue != null)
		{
			useEpoc = true;
		}

		if(unit != null && unit == "min")
		{
			if(intValue != null && intValue != 1)
			{
				unit = "${unit}s";
			}
		}

		return Padding
		(
			padding: EdgeInsets.symmetric(vertical: padding ?? 5.0),
			child: Text.rich
			(
				TextSpan
				(
					style: const TextStyle(fontSize: 20),
					children:
					[
						TextSpan(text: '''$text: ''', style: const TextStyle(fontWeight: FontWeight.w500)),
						TextSpan(text: useEpoc == true ? epocValue : ("${intValue?.toString() ?? doubleValue.toString()} $unit"))
					]
				)
			),
		);
	}

	Widget micronutrients(String header, List<Micronutrient> micros, double activityDuration)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
			child: ExpansionTile
			(
				backgroundColor: Theme.of(context).extension<AppColours>()!.tertiaryColour!.withAlpha(50),
				shape: RoundedRectangleBorder
				(
					borderRadius: BorderRadius.circular(20)
				),
				collapsedShape: RoundedRectangleBorder
				(
					borderRadius: BorderRadius.circular(20)
				),
				title: Text
				(
					header,
					style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)
				),
				children:
				[
					for (var micro in micros)
						displayInfo
						(
							micro.label,
							(NutritionMath.electrolyteCalculator(micro, widget.fibre == 30, activityDuration, widget.metFactor, widget.cardioDistance, widget.cardioFactor)).toString(),
							micro.unit,
							padding: micro.unit == "mg" ? 35 : 45,
							width: 100
						),
					const SizedBox(height: 15),
				],
			),
		);
	}

	Widget displayInfo(String header, String value, String unit, {double? padding, double? width})
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 105,
				width: 250,
				child: Card
				(
					color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
							width: 2
						),
						borderRadius: BorderRadiusGeometry.circular(20)
					),
					child: Column
					(
						children:
						[
							Padding
							(
								padding: const EdgeInsets.only(top: 10.0),
								child: Text
								(
									header,
									style: const TextStyle
									(
										fontSize: 18,
										fontWeight: FontWeight.w500
									)
								),
							),

							const Padding(padding: EdgeInsetsGeometry.only(top: 5)),
				
							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[
									Padding
									(
										padding: EdgeInsets.only(left: padding ?? 30.0),
										child: SizedBox
										(
											height: 40,
											width: width ?? 90,
											child: Card
											(
												shape: RoundedRectangleBorder
												(
													side: BorderSide
													(
														color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
														width: 2
													),
													borderRadius: BorderRadiusGeometry.circular(100)
												),
												color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
												child: Center(child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
											),
										),
									),
					
									Padding
									(
										padding: const EdgeInsets.only(left: 8.0),
										child: Text
										(
											unit,
											style: const TextStyle
											(
												fontSize: 17,
												fontWeight: FontWeight.bold
											),
										),
									)
								],
							),
						],
					),
				),
			),
		);
	}
}