import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatefulWidget
{
	final double personWeight;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	final double epoc;

	const ResultsPage({super.key, required this.personWeight, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn, required this.epoc});

	@override
	State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
{
	late AllCalculations _list;

	@override void initState()
	{
    	super.initState();
		
		final AllCalculations list = context.read<AllCalculations>(); // Since there's no context available here, I just read, rather than making and adding the widget to the tree

		_list = list;
  	}

	@override
	Widget build(BuildContext context)
	{
		final double total = widget.tdee + widget.activityBurn + widget.cardioBurn + widget.epoc;

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Results")),
			body: Column
			(
				children:
				[
					displayInfo("Basal Metabolic Rate (BMR)", "${widget.bmr.round()} kcal"),
					displayInfo("Total Daily Energy Expenditure (TDEE)", "${widget.tdee.round()} kcal"),
					displayInfo("Activity Burn (MET Method)", "${widget.activityBurn.round()} kcal"),
					displayInfo("Running Burn (Distance Method)", "${widget.cardioBurn.round()} kcal"),
					displayInfo("Recovery Burn (EPOC)", "${widget.epoc.round()} kcal"),
					displayInfo("Total Caloric Intake Required", "${total.round()}"),

					button(context, total)
				],
			)
		);
  	}

	Widget displayInfo(String header, String info, {TextStyle? textStyle})
	{
		return Card
		(
			child: Column
			(
				children:
				[
					Text(header, style: textStyle?.copyWith(fontSize: 20)),
					Text(info, style: textStyle?.copyWith(fontSize: 20)),
				],
			),
		);
	}

	Widget button(BuildContext context, double total)
	{
		return Card
		(
			child: ElevatedButton
			(
				onPressed: ()
				{
					newCalculation(widget.personWeight, widget.bmr, widget.tdee, widget.activityBurn, widget.cardioBurn, widget.epoc, total);
					
					Navigator.popUntil
					(
						context,
						(route) => route.isFirst
					);
				},
				child: const Padding
				(
					padding: EdgeInsets.all(16.0),
					child: Text("Upload To Timeline", textAlign: TextAlign.center,),
				),
			)
		);
	}

	void newCalculation(double weight, double bmr, double tdee, double activityBurn, double cardioBurn, double epoc, double total)
	{
		Calculation calc = Calculation(id: null, date: DateTime.now().toIso8601String(), personWeight: weight, bmr: bmr, tdee: tdee, weightLiftingBurn: activityBurn, cardioBurn: cardioBurn, epoc: epoc, totalBurn: total);

		_list.uploadCalc(calc);
	}
}