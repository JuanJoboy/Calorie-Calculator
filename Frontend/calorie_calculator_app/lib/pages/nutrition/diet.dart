import 'dart:math';

import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';

class DietPage extends StatefulWidget
{
	final double weight;
	final double tdee;
	final double activityDuration;
	final double proteinIntensity;
	final double fatIntake;
	final double fibre;

	const DietPage({super.key, required this.weight, required this.tdee, required this.activityDuration, required this.proteinIntensity, required this.fatIntake, required this.fibre});

	@override
	State<DietPage> createState() => _DietPageState();
}

enum DietView
{
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
	DietView activeView = DietView.macros;

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Dietary Analysis")),
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
								segments: const
								[
									ButtonSegment(value: DietView.macros, label: Text('Macros'), icon: Icon(Icons.pie_chart)),
									ButtonSegment(value: DietView.water, label: Text('Water'), icon: Icon(Icons.water_drop)),
									ButtonSegment(value: DietView.micros, label: Text('Micros'), icon: Icon(Icons.biotech))
								],
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

	Widget displayAll()
	{
		// Macro
		final int protein = (widget.weight * widget.proteinIntensity).round();
		final int totalFat = ((widget.tdee * widget.fatIntake) / 9).round();
		final int saturatedFat = ((widget.tdee * 0.1) / 9).round();
		final int unsaturatedFat = (totalFat - saturatedFat).round();
		final double omega3 = double.parse((max((widget.fibre == 30 ? 1.6 : 1.1), (widget.tdee * 0.01) / 9)).toStringAsFixed(2));
		final double omega6 = double.parse((max((widget.fibre == 30 ? 17 : 12), (widget.tdee * 0.05) / 9)).toStringAsFixed(2));
		final int cholesterol = 300;
		final int carb = ((widget.tdee - (protein * 4) - (totalFat * 9)) / 4).round();
		final int fibre = (widget.fibre).round();
		final int solubleFibre = (fibre * 0.4).round();
		final int insolubleFibre = (fibre * 0.6).round();
		final int sugar = ((widget.tdee * 0.1) / 4).round();

		// Water
		final double minBaseWater = double.parse((widget.weight * 0.030).toStringAsFixed(2));
		final double maxBaseWater = double.parse((widget.weight * 0.035).toStringAsFixed(2));
		final double minExerciseWater = double.parse(((widget.activityDuration / 60) * 0.50).toStringAsFixed(2));
		final double maxExerciseWater = double.parse(((widget.activityDuration / 60) * 1.00).toStringAsFixed(2));

		switch(activeView)
		{
			case DietView.macros:
				return Column
				(
					key: const ValueKey(0),
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
						displayInfo("Total Carbs", "$carb", "g", padding: 20, width: 90),
						displayInfo("Soluble Fibre", "$solubleFibre", "g", padding: 20, width: 90),
						displayInfo("Insoluble Fibre", "$insolubleFibre", "g", padding: 20, width: 90),
						displayInfo("Max Sugar", "$sugar", "g", padding: 20, width: 90),
					],
				);
			case DietView.water:
				return Column
				(
					key: const ValueKey(1),
					children:
					[
						Utils.header("Daily Hydration", 25, FontWeight.w600),
						displayInfo("Base Intake", "$minBaseWater - $maxBaseWater", "L", padding: 20, width: 130),
						displayInfo("Exercise Add-on", "$minExerciseWater - $maxExerciseWater", "L", padding: 20, width: 130),
					],
				);
			case DietView.micros:
				return Column
				(
					key: const ValueKey(2),
					children:
					[
						micronutrients("Water Soluble", WaterSoluble.values),
						
						micronutrients("Fat Soluble", FatSoluble.values),
						
						micronutrients("Electrolytes", Electrolytes.values),

						micronutrients("Trace Minerals", TraceMinerals.values),
					],
				);
		}
	}

	Widget micronutrients(String header, List<Micronutrient> micros)
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
							(widget.fibre == 30 ? micro.maleValue : micro.femaleValue).toString(),
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

							// const Spacer(),

							const Padding(padding: EdgeInsetsGeometry.only(top: 5)),
				
							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[
									// Container
									// (
									// 	padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
									// 	decoration: BoxDecoration
									// 	(
									// 		color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
                      				// 		borderRadius: BorderRadius.circular(10),
									// 	),
									// 	child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
									// ),

									// const SizedBox(width: 8), // Padding

									// Text(unit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

							// const SizedBox(height: 15)
						],
					),
				),
			),
		);
	}
}