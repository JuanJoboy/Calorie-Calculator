import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/pages/calculator/bmr.dart';
import 'package:calorie_calculator_app/pages/history/history.dart';
import 'package:calorie_calculator_app/pages/planner/days.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class PlannerPage extends StatefulWidget
{
	const PlannerPage({super.key});

	@override
	State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage>
{
	@override
	Widget build(BuildContext context)
	{
		return Column
		(
			children:
			[
				Utils.header("Weekly Planner", 30, FontWeight.bold),

				weeklyPlans(List.empty(), 0),

				// Expanded
				// (
				// 	child: list.calcList.isNotEmpty ? ListView.builder
				// 	(
				// 		physics: const BouncingScrollPhysics(),
				// 		itemCount: list.calcList.length,
				// 		itemBuilder: (context, index)
				// 		{
				// 			return weeklyPlans(list.calcList, index);
				// 		},
				// 	) : const Center(child: Text("No weeks have been planned :("))
				// ),

				newPlanButton()
			],
		);
	}

	Widget weeklyPlans(List<Object> a, int index)
	{
		final String title = "Upper + Cardio";

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 140,
				width: 300,
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
								padding: const EdgeInsets.only(top: 10),
								child: Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										Padding
										(
											padding: const EdgeInsets.only(top: 10.0),
											child: Text
											(
												title,
												style: const TextStyle
												(
													fontSize: 25,
													fontWeight: FontWeight.w500
												)
											),
										)
									],
								),
							),

							const Padding(padding: EdgeInsetsGeometry.only(top: 10)),

							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								children:
								[
									iconButton(Icons.remove_red_eye_rounded, 1),
									iconButton(Icons.edit, 2),
									iconButton(Icons.delete, 3)
								],
							)
						],
					),
				),
			),
		);
	}

	Widget iconButton(IconData icon, int action)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 10.0),
			child: GestureDetector
			(
				onTap: () async
				{
					if(action == 1)
					{
						await Navigator.push
						(
							context,
							MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
							(
								body: Utils.switchPage(context, const DaysPage())
							))
						);
					}
					else if(action == 2)
					{
						await Navigator.push
						(
							context,
							MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
							(
								body: Utils.switchPage(context, const CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true))
							))
						);
					}
					else
					{
						setState(()
						{
							delete();
						});
					}
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
						child: Padding
						(
							padding: const EdgeInsets.all(8.0),
							child: Icon(icon, size: 30,),
						),
					),
				),
			)
		);
	}

	void delete()
	{
		showDialog
		(
			context: context,
			builder: (BuildContext dialogueContext)
			{
				return AlertDialog
				(
					title: const Text("Confirm Action"),
					content: const Text("Do you want to delete this weekly plan?", style: TextStyle(fontSize: 20)),
					actions:
					[
						TextButton
						(
							onPressed: () => Navigator.pop(dialogueContext), // Closes without action
							child: const Text("Yes", style: TextStyle(fontSize: 20))
						),
						TextButton
						(
							onPressed: () => Navigator.pop(dialogueContext), // Closes without action
							child: const Text("No", style: TextStyle(fontSize: 20))
						),
					],
				);
			}
		);
	}

	Widget newPlanButton()
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(vertical: 40.0),
			child: SizedBox
			(
				height: 60,
				width: 220,
				child: Card
				(
					shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
					elevation: 2,
					child: ElevatedButton
					(
						style: ElevatedButton.styleFrom
						(
							backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
						),
						onPressed: () async
						{
							await Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
								(
									body: Utils.switchPage(context, const CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true))
								))
							);
						},
						child: const Text("Create New Plan", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
					)
				)
			),
		);
	}
}