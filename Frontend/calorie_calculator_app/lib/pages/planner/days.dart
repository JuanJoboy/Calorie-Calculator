import 'package:calorie_calculator_app/pages/nutrition/diet.dart';
import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/formulas.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class DaysPage extends StatefulWidget
{
	final int weeklyPlanId;

	const DaysPage({super.key, required this.weeklyPlanId});

	@override
	State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage>
{
	@override
	void initState()
	{
		super.initState();

		// Use addPostFrameCallback to ensure the provider is called after the first build start
		WidgetsBinding.instance.addPostFrameCallback((_)
		{
			context.read<DailyEntryNotifier>().loadEntries(widget.weeklyPlanId);
		});
	}

	@override
	Widget build(BuildContext context)
	{
		final notifier = context.watch<DailyEntryNotifier>();

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Days")),
			body: Center
			(
				child: notifier.isLoading ? const Center(child: CircularProgressIndicator()) : Column
				(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children:
					[
						const Padding(padding: EdgeInsetsGeometry.only(top: 40)),

						Expanded
						(
							child: ListView.builder
							(
								physics: const BouncingScrollPhysics(),
								itemCount: notifier.dailyEntries.length,
								itemBuilder: (context, index)
								{
									return button(notifier.dailyEntries, index);
								},
							)
						),

						const Padding(padding: EdgeInsetsGeometry.only(top: 100))
					]
				)
			)
		);
	}

	String whatDayIsIt(int index)
	{
		return switch (index)
		{
			0 => "Monday",
			1 => "Tuesday",
			2 => "Wednesday",
			3 => "Thursday",
			4 => "Friday",
			5 => "Saturday",
			6 => "Sunday",
			_   => "Today",
		};
	}
	
	Widget button(List<DailyEntry> list, int index)
	{
		final String text = whatDayIsIt(index);

		final double weight = list[index].weight;
		final bool isMale = list[index].isMale;
		final double additionalCalories = list[index].additionalCalories;
		final double tdee = list[index].tdee;
		final double activityBurn = list[index].activityBurn;
		final double cardioBurn = list[index].cardioBurn;
		final double epocBurn = list[index].epocBurn;
		final double proteinIntensity = list[index].proteinIntensity;
		final double fatIntake = list[index].fatIntake;

		// Calories
		final int total = CalorieMath.totalCaloriesToday(tdee, activityBurn, cardioBurn, epocBurn, additionalCalories: additionalCalories).round();
		final int totalBurn = CalorieMath.totalCaloriesBurnedToday(activityBurn, cardioBurn, epocBurn).round();

		// Protein
		final int proteinNumber = NutritionMath.protein(weight, proteinIntensity);

		// Fats
		final (:totalFat, :saturatedFat, :unsaturatedFat, :omega3, :omega6, :cholesterol) = NutritionMath.fat(tdee, fatIntake, isMale);

		// Carbs
		final (:totalCarb, :solubleFibre, :insolubleFibre, :sugar) = NutritionMath.carb(tdee, proteinNumber, totalFat, isMale ? 30 : 25);

		final String caloriesBurned = "$totalBurn";
		final String caloricCeiling = "$total";
		final String protein = "${proteinNumber}g";
		final String fat = "${totalFat}g";
		final String carbs = "${totalCarb}g";

		return GestureDetector
		(
			onTap: () async
			{
				goToNextPage(list, index);
			},
			child: Padding
			(
				padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
				child: SizedBox
				(
					height: 280,
					width: 360,
					child: Card
					(
						color: Colors.pink[50],
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
								children:
								[
									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									Text
									(
										text,
										textAlign: TextAlign.center,
										style: TextStyle
										(
											fontSize: 40,
											fontWeight: FontWeight.w900,
											color: Theme.of(context).extension<AppColours>()!.maleSeColour!
										)
									),

									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									shortDescription1("Calories Burned", caloriesBurned, "Caloric Ceiling", caloricCeiling),

									shortDescription2("Protein", protein, "Fat", fat, "Carbs", carbs),
								]
							),
					),
				),
			),
		);
	}

	Widget shortDescription1(String header1, String text1, String header2, String text2)
	{
		return Card
		(
			color: Theme.of(context).extension<AppColours>()!.anaerobicOutlineColour!,
			shape: RoundedRectangleBorder
			(
				side: BorderSide
				(
					color: Theme.of(context).extension<AppColours>()!.anaerobicBackgroundColour!,
					width: 2
				),
				borderRadius: BorderRadiusGeometry.circular(15)
			),
			child: Column
			(
				children:
				[
					Row
					(
						mainAxisAlignment: MainAxisAlignment.center,
						children:
						[
							Expanded
							(
								child: Column
								(
									children:
									[
										paddedText(header1, size: 21, weight: FontWeight.w700),
										paddedText(text1),
									]
								),
							),

							Expanded
							(
								child: Column
								(
									children:
									[
										paddedText(header2, size: 21, weight: FontWeight.w700),
										paddedText(text2),
									]
								),
							),

							const Padding(padding: EdgeInsetsGeometry.only(bottom: 75))
						],
					)
				],
			)
		);
	}

	Widget shortDescription2(String header1, String text1, String header2, String text2, String header3, String text3)
	{
		return Card
		(
			color: Theme.of(context).extension<AppColours>()!.aerobicOutlineColour!,
			shape: RoundedRectangleBorder
			(
				side: BorderSide
				(
					color: Theme.of(context).extension<AppColours>()!.aerobicBackgroundColour!,
					width: 2
				),
				borderRadius: BorderRadiusGeometry.circular(15)
			),
			child: Column
			(
				children:
				[
					Row
					(
						mainAxisAlignment: MainAxisAlignment.center,
						children:
						[
							const Padding(padding: EdgeInsetsGeometry.only(top: 75)),

							paddedColumn(header1, text1),
							paddedColumn(header2, text2),
							paddedColumn(header3, text3)
						],
					)
				],
			)
		);
	}

	Widget paddedText(String text, {double? horizontal, double? vertical, double? size, FontWeight? weight})
	{
		return Padding
		(
			padding: EdgeInsets.symmetric(horizontal: horizontal ?? 10.0, vertical: vertical ?? 5),
			child: Text(text, overflow: TextOverflow.fade, maxLines: 1, style: TextStyle(fontSize: size ?? 20, fontWeight: weight ?? FontWeight.w500))
		);
	}

	Widget paddedColumn(String header, String text)
	{
		return Expanded
		(
			child: Padding
			(
				padding: EdgeInsets.symmetric(horizontal: 10.0),
				child: Column
				(
					children:
					[
						paddedText(header, size: 21, weight: FontWeight.w700),
						paddedText(text),
					]
				),
			)
		);
	}

	void goToNextPage(List<DailyEntry> list, int index) async
	{
		final double weight = list[index].weight;
		final bool isMale = list[index].isMale;
		final double additionalCalories = list[index].additionalCalories;
		final double bmr = list[index].bmr;
		final double tdee = list[index].tdee;
		final double activityFactor = list[index].activityFactor;
		final String activityName = list[index].activityName;
		final double activityBurn = list[index].activityBurn;
		final double sportDuration = list[index].sportDuration;
		final double upperDuration = list[index].upperDuration;
		final double accessoriesDuration = list[index].accessoriesDuration;
		final double lowerDuration = list[index].lowerDuration;
		final double cardioFactor = list[index].cardioFactor;
		final String cardioName = list[index].cardioName;
		final double cardioBurn = list[index].cardioBurn;
		final double cardioDistance = list[index].cardioDistance;
		final String epocName = list[index].epocName;
		final double epocBurn = list[index].epocBurn;
		final double proteinIntensity = list[index].proteinIntensity;
		final double fatIntake = list[index].fatIntake;

		// Calories
		final double total = CalorieMath.totalCaloriesToday(tdee, activityBurn, cardioBurn, epocBurn, additionalCalories: additionalCalories);

		final (tdee: roundedTdee, :activity, :cardio, :epoc, totalCal: roundedTotal, :totalBurn, bmr: roundedBmr) = CalorieMath.roundValues(bmr, tdee, activityBurn, cardioBurn, epocBurn, total);

		final (sportDuration: roundedSportDuration, upperDuration: roundedUpperDuration, accessoryDuration: roundedAccessoryDuration, lowerDuration: roundedLowerDuration) = CalorieMath.roundedDurations(sportDuration, upperDuration, accessoriesDuration, lowerDuration);

		await Navigator.push
		(
			context,
			MaterialPageRoute
			(
				builder: (context) => Utils.switchPage
				(
					context,
					DietPage
					(
						weight: weight,
						tdee: roundedTdee,
						metFactor: activityFactor,
						activityName: activityName,
						activityBurn: activity,
						cardioFactor: cardioFactor,
						sportDuration: roundedSportDuration,
						upperDuration: roundedUpperDuration,
						accessoryDuration: roundedAccessoryDuration,
						lowerDuration: roundedLowerDuration,
						cardioName: cardioName,
						cardioDistance: cardioDistance,
						cardioBurn: cardio,
						epocBurn: epoc,
						epocIntensity: epocName,
						totalCaloriesBurned: totalBurn,
						caloricCeiling: roundedTotal,
						proteinIntensity: proteinIntensity,
						fatIntake: fatIntake,
						fibre: isMale == true ? 30.0 : 25.0,
						weeklyPlanner: true,
					),
				),
			)
		);
	}
}