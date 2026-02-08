import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/pages/calculator/bmr.dart';
import 'package:calorie_calculator_app/pages/history/history.dart';
import 'package:calorie_calculator_app/pages/nutrition/diet.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class DaysPage extends StatefulWidget
{
	const DaysPage({super.key});

	@override
	State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage>
{
	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Days")),
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

							button("Monday"),
							button("Tuesday"),
							button("Wednesday"),
							button("Thursday"),
							button("Friday"),
							button("Saturday"),
							button("Sunday"),

							const Padding(padding: EdgeInsetsGeometry.only(top: 100))
						]
					)
				)
			)
		);
	}
	
	Widget button(String text)
	{
		final String caloriesBurned = "1234";
		final String caloricCeiling = "9999";
		final String protein = "165g";
		final String fat = "72g";
		final String carbs = "480g";

		return GestureDetector
		(
			onTap: () async
			{
				goToNextPage();
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
							Column
							(
								children:
								[
									paddedText(header1, size: 21, weight: FontWeight.w700),
									paddedText(text1),
								]
							),

							Column
							(
								children:
								[
									paddedText(header2, size: 21, weight: FontWeight.w700),
									paddedText(text2),
								]
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
			child: Text(text, style: TextStyle(fontSize: size ?? 20, fontWeight: weight ?? FontWeight.w500)),
		);
	}

	Widget paddedColumn(String header, String text)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 20.0),
			child: Column
			(
				children:
				[
					paddedText(header, size: 21, weight: FontWeight.w700),
					paddedText(text),
				]
			),
		);
	}

	void goToNextPage() async
	{
		await Navigator.push
		(
			context,
			MaterialPageRoute
			(
				builder: (context) => Utils.switchPage
				(
					context,
					const DietPage
					(
						weight: 85.5,
						tdee: 2500,
						metFactor: 10,
						activityName: "Weights",
						activityBurn: 300,
						cardioFactor: 10,
						sportDuration: 60,
						upperDuration: 45,
						accessoryDuration: 15,
						lowerDuration: 1,
						cardioName: "Running",
						cardioDistance: 5.0,
						cardioBurn: 400,
						epocBurn: 50,
						epocIntensity: "High",
						totalCaloriesBurned: 750,
						caloricCeiling: 3200,
						proteinIntensity: 2.2,
						fatIntake: 70.5,
						fibre: 35.0,
						activityDuration: 100,
						weeklyPlanner: true,
					),
				),
			)
		);
	}
}