import 'package:calorie_calculator_app/pages/calculator/bmr.dart';
import 'package:calorie_calculator_app/pages/planner/days.dart';
import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
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
	late WeeklyPlanNotifier _list;

	@override
	Widget build(BuildContext context)
	{
		final WeeklyPlanNotifier list = context.watch<WeeklyPlanNotifier>();
		_list = list;

		return Column
		(
			children:
			[
				Utils.header("Weekly Planner", 30, FontWeight.bold),

				Expanded
				(
					child: list.weeklyPlans.isNotEmpty ? ListView.builder
					(
						physics: const BouncingScrollPhysics(),
						itemCount: list.weeklyPlans.length,
						itemBuilder: (context, index)
						{
							return weeklyPlans(list.weeklyPlans, index);
						},
					) : const Center(child: Text("No plans have been made :("))
				),

				newPlanButton()
			],
		);
	}

	Widget weeklyPlans(List<WeeklyPlan> plans, int index)
	{
		final String title = plans[index].folderName;
		final int? id = plans[index].id;

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
									iconButton(Icons.remove_red_eye_rounded, 1, id),
									iconButton(Icons.edit, 2, id),
									iconButton(Icons.delete, 3, id)
								],
							)
						],
					),
				),
			),
		);
	}

	Widget iconButton(IconData icon, int action, int? id)
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
						if(mounted)
						{
							await Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Utils.switchPage(context, DaysPage(weeklyPlanId: id!)))
							);
						}
					}
					else if(action == 2)
					{
						await Navigator.push
						(
							context,
							MaterialPageRoute(builder: (context) => Scaffold
							(
								body: Utils.switchPage(context, CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true, weeklyPlanId: id!))
							))
						);
					}
					else
					{
						setState(()
						{
							delete(id!);
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

	void delete(int id)
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
							onPressed: ()
							{
								Navigator.pop(dialogueContext); // Closes without action
								_list.deleteWeeklyPlan(id);
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
	}

	Widget newPlanButton()
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(vertical: 10.0),
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
									body: Utils.switchPage(context, const CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true, weeklyPlanId: null))
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