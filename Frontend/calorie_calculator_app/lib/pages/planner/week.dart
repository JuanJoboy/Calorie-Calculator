import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class WeekPage extends StatefulWidget
{
	final int? weeklyPlanId;
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	
	const WeekPage({super.key, required this.weeklyPlanId, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories});

	@override
	State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage>
{
	late FolderNotifier _folder;
	bool _isSaving = false;

	@override
	void dispose()
	{
		super.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final FolderNotifier folder = context.read<FolderNotifier>();
		_folder = folder;
  	}

	@override
	Widget build(BuildContext context)
	{
		return PopScope
		(
			canPop: false, // Prevent immediate pop
			onPopInvokedWithResult: (didPop, result) async
			{
				if (didPop) return;

				// Delete the plan from DB since they are cancelling
				if (widget.weeklyPlanId != null && !_isSaving)
				{
					final WeeklyPlanNotifier plan = context.read<WeeklyPlanNotifier>();
					plan.deleteWeeklyPlan(widget.weeklyPlanId!);
				}

				if (context.mounted)
				{
					Navigator.pop(context);
				}
			},
			child: Scaffold
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

								button("Monday", dayId: 0),
								button("Tuesday", dayId: 1),
								button("Wednesday", dayId: 2),
								button("Thursday", dayId: 3),
								button("Friday", dayId: 4),
								button("Saturday", dayId: 5),
								button("Sunday", dayId: 6),

								button("Save Week", saveWeek: true),

								const Padding(padding: EdgeInsetsGeometry.only(top: 100))
							]
						)
					)
				)
			)
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
			_folder.name = "";

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