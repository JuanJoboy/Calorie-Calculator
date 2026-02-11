import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget
{
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}

late UsersTdeeNotifier _tdeeNotifier;
bool get tdeeIsNull => _tdeeNotifier.usersTdee == null;

class _HistoryPageState extends State<HistoryPage>
{
	late AllCalculations _list;

	@override
	Widget build(BuildContext context)
	{
		AllCalculations list = context.watch<AllCalculations>();
		_list = list;

		final UsersTdeeNotifier tdeeNotifier = context.watch<UsersTdeeNotifier>();
		_tdeeNotifier = tdeeNotifier;

		int? b = 0;
		int? t = 0;

		if(!tdeeIsNull)
		{
			b = _tdeeNotifier.usersTdee?.bmr.round();
			t = _tdeeNotifier.usersTdee?.tdee.round();
		}

		return Column
		(
			children:
			[
				Utils.header("BMR: $b	|	TDEE: $t", 30, FontWeight.bold, padding: 50),

				Utils.header("All units in kcal", 15, FontWeight.bold, padding: 10, color: Colors.grey[500]),

				const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

				Expanded
				(
					child: list.calcList.isNotEmpty ? ListView.builder
					(
						physics: const BouncingScrollPhysics(),
						itemCount: list.calcList.length,
						itemBuilder: (context, index)
						{
							return calorieCard(list.calcList, index); // Displays all the calculations
						},
					) : const Center(child: Text("No calcs have been lated :(")) // If the list isn't empty then only print this text
				),
			],
		);
	}

	Widget calorieCard(List<Calculation> list, int index)
	{
		final date = DateTime.parse(list[index].date);
		final day = date.day;
		final month = date.month;
		final year = date.year;
		final bmr = list[index].bmr.round();
		final tdee = list[index].tdee.round();
		final activityBurn = list[index].weightLiftingBurn.round();
		final cardioBurn = list[index].cardioBurn.round();
		final epocBurn = list[index].epoc.round();
		final ceiling = list[index].totalBurn.round();
		final totalBurn = activityBurn + cardioBurn + epocBurn;

		final bool noActivity = activityBurn == 0 && cardioBurn == 0;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0, bottom: 20),
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
									Utils.header(noActivity == true ? "Rest Day 😴" : "Training Day 🔥", 30, FontWeight.bold),

									const Padding(padding: EdgeInsetsGeometry.only(top: 15)),

									Container
									(
										padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
										decoration: BoxDecoration
										(
											color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
											borderRadius: BorderRadius.circular(20),
										),
										child: Text
										(
											"$day / $month / $year",
											style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.w600,
											color: Theme.of(context).hintColor,
											),
										)
									),

									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									dotPoint("BMR", bmr, Icons.monitor_heart_rounded, Theme.of(context).extension<AppColours>()!.maleSeColour!),
									dotPoint("Base TDEE", tdee, Icons.self_improvement_rounded, Theme.of(context).extension<AppColours>()!.maleSeColour!),
									dotPoint("Activity Burn", activityBurn, Icons.whatshot_rounded, Colors.deepOrange[400]!),
									dotPoint("Cardio Burn", cardioBurn, Icons.whatshot_rounded, Colors.deepOrange[400]!),
									dotPoint("EPOC", epocBurn, Icons.whatshot_rounded, Colors.deepOrange[400]!),
									dotPoint("Total Calories Burned", totalBurn, Icons.workspace_premium_rounded, Colors.deepOrange[400]!),
									dotPoint("Caloric Ceiling", ceiling, Icons.vertical_align_top, Theme.of(context).extension<AppColours>()!.femaleSeColour!),

									deleteButton(index),

									const Padding(padding: EdgeInsetsGeometry.only(top: 30)),
								],
							),
						)
					);
				}
			)
		);
	}

	Widget deleteButton(int index)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 10.0),
			child: GestureDetector
			(
				onTap: ()
				{
					setState(()
					{
						showDialog
						(
							context: context,
							builder: (BuildContext dialogueContext)
							{
								return AlertDialog
								(
									title: const Text("Confirm Action"),
									content: const Text("Do you want to delete this calculation?", style: TextStyle(fontSize: 20)),
									actions:
									[
										TextButton
										(
											onPressed: () async
											{
												Navigator.pop(dialogueContext); // Closes without action
												await _list.deleteCalc(index);
											},
											child: const Text("Yes", style: TextStyle(fontSize: 20)),
										),
										TextButton
										(
											onPressed: () => Navigator.pop(dialogueContext),
											child: const Text("No", style: TextStyle(fontSize: 20))
										),
									],
								);
							}
						);
					});
				},
				child: SizedBox
				(
					child: Card
					(
						shape: RoundedRectangleBorder
						(
							side: BorderSide
							(
								color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
								width: 2
							),
							borderRadius: BorderRadiusGeometry.circular(20)
						),
						color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
						child: const Padding
						(
							padding: EdgeInsets.all(8.0),
							child: Icon(Icons.delete, size: 35),
						),
					),
				),
			)
		);
	}

	Widget dotPoint(String boldText, int value, IconData icon, Color color)
	{
		return BulletedList
		(
			listItems: [richText(boldText, value, padding: 15)],
			style: const TextStyle(fontSize: 20, color: Colors.black),
			bullet: Icon(icon, size: 30, color: color)
		);
	}

	Widget richText(String boldText, int value, {double? padding})
	{
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
						TextSpan(text: '''$boldText: ''', style: const TextStyle(fontWeight: FontWeight.w500)),
						TextSpan(text: "$value")
					]
				)
			),
		);
	}
}