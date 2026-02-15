import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class WeekPage extends StatefulWidget
{
	final int? weeklyPlanId;
	final bool isEditing;
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	
	const WeekPage({super.key, required this.weeklyPlanId, required this.isEditing, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories});

	@override
	State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage>
{
	final TextEditingController folderName = TextEditingController();

	late FolderNotifier _folder;
	late WeeklyPlanNotifier _plan;

	bool _isSaving = false;

	@override
	void dispose()
	{
		super.dispose();
		folderName.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final FolderNotifier folder = context.read<FolderNotifier>();
		_folder = folder;

		final WeeklyPlanNotifier plan = context.read<WeeklyPlanNotifier>();
		_plan = plan;

		folderName.text = _folder.name;
  	}

	@override
	Widget build(BuildContext context)
	{
		return PopScope // Theres a popScope in BMR page but its good here cause if the user exits here, then the plan is still deleted. And the deleteWeeklyPlan() method has safeguards to prevent deleting the same plan twice.
		(
			canPop: false, // Prevent immediate pop
			onPopInvokedWithResult: (didPop, result) async
			{
				if (didPop) return;

				// Delete the plan from DB since they are cancelling
				if (widget.weeklyPlanId != null && !_isSaving && widget.isEditing == false)
				{
					final WeeklyPlanNotifier plan = context.read<WeeklyPlanNotifier>();
					await plan.deleteWeeklyPlan(widget.weeklyPlanId!);
				}

				if (context.mounted)
				{
					Navigator.pop(context);
				}
			},
			child: Scaffold
			(
				backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
				appBar: AppBar(title: const Text("Input Weekly Plan")),
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

								textBox(),

								button("Monday", dayId: 0),
								button("Tuesday", dayId: 1),
								button("Wednesday", dayId: 2),
								button("Thursday", dayId: 3),
								button("Friday", dayId: 4),
								button("Saturday", dayId: 5),
								button("Sunday", dayId: 6),

								button("Save Plan", saveWeek: true),

								const Padding(padding: EdgeInsetsGeometry.only(top: 100))
							]
						)
					)
				)
			)
		);
	}

	Widget textBox()
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
			child: SizedBox
			(
				height: 200,
				width: double.infinity,
				child: Card
				(
					color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
							width: 6
						),
						borderRadius: BorderRadiusGeometry.circular(20)
					),
					child: Column
					(
						children:
						[
							const Padding
							(
								padding: EdgeInsets.only(top: 15.0),
								child: Text
								(
									"Weekly Plan Name",
									style: TextStyle
									(
										fontSize: 30,
										fontWeight: FontWeight.w500
									)
								),
							),
				
							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[
									Padding
									(
										padding: const EdgeInsets.only(top: 30.0),
										child: SizedBox
										(
											height: 60,
											width: 250,
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
												child: TextField
												(
													textAlign: TextAlign.center,
													decoration: const InputDecoration
													(
														hintText: "...",
														border: InputBorder.none,
													),
													style: const TextStyle
													(
														fontSize: 25,
													),
													controller: folderName,
													onChanged: (value)
													{
														_folder.updateControllers(folderName: value);
													},
												),
											),
										),
									),
								],
							)
						],
					),
				),
			),
		);
	}
	
	Widget button(String text, {bool? saveWeek = false, int? dayId})
	{
		return GestureDetector
		(
			onTap: () async
			{
				if (saveWeek == false)
				{
					goToNextPage(exit: false, dayId: dayId!);
				}
				else
				{
					goToNextPage(exit: true);
				}
			},
			child: Padding
			(
				padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
				child: SizedBox
				(
					height: 130,
					width: double.infinity,
					child: Card
					(
						color: Theme.of(context).extension<AppColours>()!.fairyPink!,
						shape: RoundedRectangleBorder
						(
							side: BorderSide
							(
								color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
								width: 4
							),
							borderRadius: BorderRadiusGeometry.circular(20)
						),
						child: Center
							(
								child: Text
								(
									text,
									textAlign: TextAlign.center,
									style: TextStyle
									(
										fontSize: 40,
										fontWeight: FontWeight.w900,
										color: Theme.of(context).extension<AppColours>()!.femaleSeColour!
									)
								),
							),
					),
				),
			),
		);
	}

	void goToNextPage({bool? exit, int? dayId}) async
	{
		if(exit! == false)
		{
			await Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
				(
					body: Utils.switchPage(context, BurnPage(bmr: widget.bmr, age: widget.age, male: widget.male, tdee: widget.tdee, personWeight: widget.personWeight, additionalCalories: widget.additionalCalories, weeklyPlanner: true, weeklyPlanId: widget.weeklyPlanId, dayId: dayId!))
				))
			);
		}
		else
		{
			_isSaving = true;

			final String name = folderName.text.trim() == "" ? "New Weekly Plan" : folderName.text.trim();

			await _plan.uploadOrEditWeeklyPlan(name, widget.weeklyPlanId);

			if(mounted)
			{
				Navigator.popUntil
				(
					context,
					(route) => route.isFirst
				);
			}
		}
	}
}