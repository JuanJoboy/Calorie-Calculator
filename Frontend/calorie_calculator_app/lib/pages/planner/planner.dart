import 'package:calorie_calculator/pages/calculator/bmr.dart';
import 'package:calorie_calculator/pages/planner/days.dart';
import 'package:calorie_calculator/pages/planner/folder_data.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
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
		_list = context.watch<WeeklyPlanNotifier>();

		return Column
		(
			children:
			[
				const Header(text: "Weekly Planner", fontSize: 30, fontWeight: FontWeight.bold),

				Expanded
				(
					child: _list.weeklyPlans.isNotEmpty ? ListView.builder
					(
						physics: const BouncingScrollPhysics(),
						itemCount: _list.weeklyPlans.length,
						itemBuilder: (context, index)
						{
							return _weeklyPlans(_list.weeklyPlans, index);
						},
					) : const Center(child: Text("No plans have been made :("))
				),

				_newPlanButton()
			],
		);
	}

	Widget _weeklyPlans(List<WeeklyPlan> plans, int index)
	{
		final String title = plans[index].folderName;
		final int? id = plans[index].id;

		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 140,
				width: 300,
				child: Card
				(
					color: colour.tertiaryColour!,
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
									_iconButton(Icons.remove_red_eye_rounded, 1, id),
									_iconButton(Icons.edit, 2, id),
									_iconButton(Icons.delete, 3, id)
								],
							)
						],
					),
				),
			),
		);
	}

	Widget _iconButton(IconData icon, int action, int? id)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 10.0),
			child: GestureDetector
			(
				onTap: () async
				{
					if(action == 1) // View
					{
						try
						{
							if(mounted)
							{
								await Navigator.push
								(
									context,
									MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: DaysPage(weeklyPlanId: id!)))
								);
							}
						}
						catch(e)
						{
							if(mounted)
							{
								ErrorHandler.showSnackBar(context, "An error occurred in viewing your plan");
								debugPrint("Debug Print: ${e.toString()}");
							}
						}
					}
					else if(action == 2) // Edit
					{
						try
						{
							await Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Scaffold
								(
									body: PageSwitcher(nextPage: CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true, weeklyPlanId: id!, isEditing: true))
								))
							);
						}
						catch(e)
						{
							if(mounted)
							{
								ErrorHandler.showSnackBar(context, "An error occurred in editing your plan");
								debugPrint("Debug Print: ${e.toString()}");
							}
						}
					}
					else
					{
						try
						{
							setState(() // Delete
							{
								_delete(id!);
							});
						}
						catch(e)
						{
							if(mounted)
							{
								ErrorHandler.showSnackBar(context, "An error occurred in deleting your plan");
								debugPrint("Debug Print: ${e.toString()}");
							}
						}
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
							child: Icon(icon, size: 30),
						),
					),
				),
			)
		);
	}

	void _delete(int id)
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
							onPressed: () async
							{
								Navigator.pop(dialogueContext); // Closes without action
								await _list.deleteWeeklyPlan(id);
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

	Widget _newPlanButton()
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
							try
							{
								if(mounted)
								{
									await Navigator.push
									(
										context,
										MaterialPageRoute(builder: (context) => const Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
										(
											body: PageSwitcher(nextPage: CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: false, weeklyPlanner: true, weeklyPlanId: null, isEditing: false)) // Id is null here as the plan is in the process of being made
										))
									);
								}
							}
							catch(e)
							{
								if(mounted)
								{
									ErrorHandler.showSnackBar(context, "An error occurred in creating your plan");
									debugPrint("Debug Print: ${e.toString()}");
								}
							}
						},
						child: const Text("Create New Plan", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
					)
				)
			),
		);
	}
}