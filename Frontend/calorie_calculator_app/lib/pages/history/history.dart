import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator/pages/calculator/calculations.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget
{
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage>
{
	late AllCalculations _list;
	late UsersTdeeNotifier _tdeeNotifier;
	bool get tdeeIsNull => _tdeeNotifier.usersTdee == null;

	@override
	Widget build(BuildContext context)
	{
		_list = context.watch<AllCalculations>();

		_tdeeNotifier = context.watch<UsersTdeeNotifier>();

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
				Header(text: "BMR: $b	|	TDEE: $t", fontSize: 30, fontWeight: FontWeight.bold, topPadding: 50),

				Header(text: "All units in kcal", fontSize: 15, fontWeight: FontWeight.bold, topPadding: 10, color: Colors.grey[500], bottomPadding: 20),

				Expanded
				(
					child: _list.calcList.isNotEmpty ? ListView.builder
					(
						physics: const BouncingScrollPhysics(),
						itemCount: _list.calcList.length,
						itemBuilder: (context, index)
						{
							return _calorieCard(_list.calcList, index); // Displays all the calculations
						},
					) : const Center(child: Text("No calculations have been made :(")) // If the list isn't empty then only print this text
				),
			],
		);
	}

	Widget _calorieCard(List<Calculation> list, int index)
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

		final colour = Theme.of(context).extension<AppColours>()!;
		
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
							color: colour.tertiaryColour!,
							shape: RoundedRectangleBorder
							(
								side: BorderSide
								(
									color: colour.secondaryColour!,
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
									Header(text: noActivity == true ? "Rest Day 😴" : "Training Day 🔥", fontSize: 30, fontWeight: FontWeight.bold),

									const Padding(padding: EdgeInsetsGeometry.only(top: 15)),

									Container
									(
										padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
										decoration: BoxDecoration
										(
											color: colour.secondaryColour!,
											borderRadius: BorderRadius.circular(20),
										),
										child: Text
										(
											"$day / $month / $year",
											style: TextStyle
											(
												fontSize: 16,
												fontWeight: FontWeight.w600,
												color:Theme.of(context).hintColor,
											),
										)
									),

									const Padding(padding: EdgeInsetsGeometry.only(top: 20)),

									_dotPoint("BMR", bmr, Icons.monitor_heart_rounded, colour.bmr!),
									_dotPoint("Base TDEE", tdee, Icons.self_improvement_rounded, colour.bmr!),
									_dotPoint("Activity Burn", activityBurn, Icons.whatshot_rounded, colour.caloricBurn!),
									_dotPoint("Cardio Burn", cardioBurn, Icons.whatshot_rounded, colour.caloricBurn!),
									_dotPoint("EPOC", epocBurn, Icons.whatshot_rounded, colour.caloricBurn!),
									_dotPoint("Total Calories Burned", totalBurn, Icons.workspace_premium_rounded, colour.caloricBurn!),
									_dotPoint("Caloric Ceiling", ceiling, Icons.vertical_align_top, colour.femaleSeColour!),

									_deleteButton(index),

									const Padding(padding: EdgeInsetsGeometry.only(top: 30)),
								],
							),
						)
					);
				}
			)
		);
	}

	Widget _deleteButton(int index)
	{
		final colour = Theme.of(context).extension<AppColours>()!;
		
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
												try
												{
													Navigator.pop(dialogueContext); // Closes without action
													await _list.deleteCalc(index);
												}
												catch(e)
												{
													if(mounted)
													{
														ErrorHandler.showSnackBar(context, "An error occurred in deleting your calculation");
														debugPrint("Debug Print: ${e.toString()}");
													}
												}
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
								color: colour.secondaryColour!,
								width: 2
							),
							borderRadius: BorderRadiusGeometry.circular(20)
						),
						color: colour.secondaryColour!,
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

	Widget _dotPoint(String boldText, int value, IconData icon, Color color)
	{
		return BulletedList
		(
			listItems: [_richText(boldText, value, padding: 15)],
			bullet: Icon(icon, size: 30, color: color)
		);
	}

	Widget _richText(String boldText, int value, {double? padding})
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