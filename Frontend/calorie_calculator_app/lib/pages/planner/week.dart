import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/pages/calculator/bmr.dart';
import 'package:calorie_calculator_app/pages/history/history.dart';
import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class WeekPage extends StatefulWidget
{
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	
	const WeekPage({super.key, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories});

	@override
	State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage>
{
	final TextEditingController folderName = TextEditingController();

	late FolderNotifier _folder;

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

		folderName.text = _folder.name;
  	}

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

							textBox(),

							button("Monday"),
							button("Tuesday"),
							button("Wednesday"),
							button("Thursday"),
							button("Friday"),
							button("Saturday"),
							button("Sunday"),

							button("Save Week", saveWeek: true),

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
	
	Widget button(String text, {bool? saveWeek = false})
	{
		return Padding
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
					child: GestureDetector
					(
						onTap: () async
						{
							if (saveWeek == false)
							{
								goToNextPage(exit: false);
							}
							else
							{
								goToNextPage(exit: true);
							}
						},
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
						)
					)
				),
			),
		);
	}

	void goToNextPage({bool? exit}) async
	{
		if(exit! == false)
		{
			await Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
				(
					body: Utils.switchPage(context, BurnPage(bmr: widget.bmr, age: widget.age, male: widget.male, tdee: widget.tdee, personWeight: widget.personWeight, additionalCalories: widget.additionalCalories, weeklyPlanner: true))
				))
			);
		}
		else
		{
			// Save entire week

			// Save folder name
			// folderName.text.trim() == "" ? "New Weekly Plan" : folderName.text.trim();

			Navigator.popUntil
			(
				context,
				(route) => route.isFirst
			);
		}
	}
}