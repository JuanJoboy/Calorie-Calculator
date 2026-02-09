import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/pages/planner/week.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class SavePlanPage extends StatefulWidget
{
	final int? weeklyPlanId;
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	
	const SavePlanPage({super.key, required this.weeklyPlanId, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories});

	@override
	State<SavePlanPage> createState() => _SavePlanPageState();
}

class _SavePlanPageState extends State<SavePlanPage>
{
	final TextEditingController folderName = TextEditingController();

	late FolderNotifier _folder;
	late WeeklyPlanNotifier _plan;

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

	late WeeklyPlanNotifier _list;

	@override
	Widget build(BuildContext context)
	{
		final WeeklyPlanNotifier list = context.watch<WeeklyPlanNotifier>();
		_list = list;

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Save Plan Name")),
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

							button(),

							const Padding(padding: EdgeInsetsGeometry.only(top: 100))
						]
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
														color: Colors.black
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
	
	Widget button()
	{
		return GestureDetector
		(
			onTap: () async
			{
				await savePlanName();
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
									"Save Plan Name",
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

	Future<void> savePlanName({bool? exit, int? dayId}) async
	{
		final String name = folderName.text.trim() == "" ? "New Weekly Plan" : folderName.text.trim();

		int id = await _list.createWeeklyPlanShell();

		await _plan.uploadOrEditWeeklyPlan(name, id);

		if(mounted)
		{
			await Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Scaffold
				(
					body: Utils.switchPage(context, WeekPage(bmr: widget.bmr, age: widget.age, male: widget.male, tdee: widget.tdee, personWeight: widget.personWeight, additionalCalories: widget.additionalCalories, weeklyPlanId: id))
				))
			);
		}
	}
}