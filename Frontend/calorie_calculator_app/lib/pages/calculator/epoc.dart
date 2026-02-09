import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/results.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class EPOCPage extends StatefulWidget
{
	final double personWeight;
	final double age;
	final bool male;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	final double additionalCalories;
	final bool weeklyPlanner;
	final double cardioDistance;
	final double protein;
	final double fat;
	final double metFactor;
	final double cardioFactor;
	final String activityName;
	final double sportDuration;
	final double upperDuration;
	final double accessoryDuration;
	final double lowerDuration;
	final String cardioName;
	final int? weeklyPlanId;
	final int dayId;
	
	const EPOCPage({super.key, required this.personWeight, required this.age, required this.male, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn, required this.additionalCalories, required this.weeklyPlanner, required this.cardioDistance, required this.protein, required this.fat, required this.metFactor, required this.cardioFactor, required this.activityName, required this.sportDuration, required this.upperDuration, required this.accessoryDuration, required this.lowerDuration, required this.cardioName, required this.weeklyPlanId, required this.dayId});

	@override
	State<EPOCPage> createState() => _EPOCPageState();
}

enum Epoc
{
	low(value: 0.05, label: 'Light / Aerobic'),
	mid(value: 0.10, label: 'Moderate / Anaerobic'),
	high(value: 0.13, label: 'Vigorous / Maximal');

	final double value;
	final String label;

	const Epoc({required this.value, required this.label});
}

class _EPOCPageState extends State<EPOCPage>
{
	late DailyEntryNotifier _entry;

	@override void initState()
	{
    	super.initState();

		final DailyEntryNotifier entry = context.read<DailyEntryNotifier>();
		_entry = entry;
  	}

	@override
	Widget build(BuildContext context)
	{
		Color aeOutline = Theme.of(context).extension<AppColours>()!.aerobicOutlineColour!;
		Color aeBackground = Theme.of(context).extension<AppColours>()!.aerobicBackgroundColour!;
		Color anOutline = Theme.of(context).extension<AppColours>()!.anaerobicOutlineColour!;
		Color anBackground = Theme.of(context).extension<AppColours>()!.anaerobicBackgroundColour!;
		Color maOutline = Theme.of(context).extension<AppColours>()!.maximalOutlineColour!;
		Color maBackground = Theme.of(context).extension<AppColours>()!.maximalBackgroundColour!;

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("EPOC Calculator")),
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
							Utils.widgetPlusHelper(Utils.header("Activity Intensity Level", 30, FontWeight.bold), HelpIcon(msg: "Select your Intensity based on RPE (Rate of Perceived Exertion). The more you exerted yourself, the higher your RPE.",), top: 50, right: 17.5),

							Utils.header(Epoc.low.label, 25, FontWeight.w600),
							button("RPE 1-4", "Breathing is easy;", "conversation is possible", Epoc.low.value, aeOutline, aeBackground),

							Utils.header(Epoc.mid.label, 25, FontWeight.w600),
							button("RPE 5-8", "Heavy lifting or fast pace;", "conversation is difficult", Epoc.mid.value, anOutline, anBackground),
							
							Utils.header(Epoc.high.label, 25, FontWeight.w600),
							button("RPE 9-10", "To failure, and gasping for air;", "conversation is impossible", Epoc.high.value, maOutline, maBackground),

							const Padding(padding: EdgeInsetsGeometry.all(50))
						],
					),
				)
			)
		);
	}

	Widget button(String header, String subtitle1, String subtitle2, double epocFactor, Color background, Color outline)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 150,
				width: 300,
				child: Card
				(
					color: background,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: outline,
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
								padding: const EdgeInsets.only(top: 10.0),
								child: Text
								(
									header,
									style: const TextStyle
									(
										fontSize: 20,
										fontWeight: FontWeight.w500
									)
								),
							),
				
							SizedBox
							(
								height: 50,
								width: 100,
								child: Card
								(
									shape: RoundedRectangleBorder
									(
										side: BorderSide
										(
											color: outline,
											width: 2
										),
										borderRadius: BorderRadiusGeometry.circular(100)
									),
									color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
									child: ElevatedButton
									(
										onPressed: () async
										{
											await processInfo(epocFactor, subtitle1);
										},
										child: const Text("Next", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
,
									)
								),
							),
			
							Text
							(
								subtitle1,
								style: const TextStyle
								(
									fontSize: 17,
									fontWeight: FontWeight.w600
								),
							),
							Text
							(
								subtitle2,
								style: const TextStyle
								(
									fontSize: 15,
									fontWeight: FontWeight.w500
								),
							),
						],
					),
				),
			),
		);
	}

	Future<void> processInfo(double epocFactor, String subtitle1) async
	{
		final double epoc = (widget.activityBurn + widget.cardioBurn) * epocFactor;

		if(widget.weeklyPlanner)
		{
			await calculate(epocFactor, epoc, subtitle1);
		}
		else
		{
			Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Utils.switchPage(context, ResultsPage(personWeight: widget.personWeight, age: widget.age, male: widget.male, bmr: widget.bmr, tdee: widget.tdee, activityBurn: widget.activityBurn, cardioBurn: widget.cardioBurn, epoc: epoc))) // Takes you to the page that shows all the locations connected to the restaurant
			);
		}
	}

	Future<void> calculate(double epocFactor, double epocCalories, String subtitle1) async
	{
		// Do all the calculations then post it
		subtitle1 = subtitle1.split(";").first;

		final existing = _entry.dailyEntries[widget.dayId];

		// Check if the existing entry belongs to the current plan.
		// If it doesn't match, this is a new plan/entry context, so id must be null.
		int? validId = (existing.weeklyPlanId == widget.weeklyPlanId) ? existing.id : null;

		await _entry.uploadOrEditDailyEntry(id: validId, weeklyPlanId: widget.weeklyPlanId, dayId: widget.dayId, weight: widget.personWeight, age: widget.age, isMale: widget.male, additionalCalories: widget.additionalCalories, bmr: widget.bmr, tdee: widget.tdee, activityFactor: widget.metFactor, activityName: widget.activityName, activityBurn: widget.activityBurn, sportDuration: widget.sportDuration, upperDuration: widget.upperDuration, accessoriesDuration: widget.accessoryDuration, lowerDuration: widget.lowerDuration, cardioFactor: widget.cardioFactor, cardioName: widget.cardioName, cardioBurn: widget.cardioBurn, cardioDistance: widget.cardioDistance, epocFactor: epocFactor, epocName: subtitle1, epocBurn: epocCalories, proteinIntensity: widget.protein, fatIntake: widget.fat);

		if(mounted)
		{
			Navigator.of(context).pop();
			Navigator.of(context).pop();
		}
	}
}