import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatefulWidget
{
	final double personWeight;
	final double bmr;
	final double weightLiftingBurn;
	final double cardioBurn;
	final double epoc;

	const ResultsPage({super.key, required this.personWeight, required this.bmr, required this.weightLiftingBurn, required this.cardioBurn, required this.epoc});

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
		final double tdee = (widget.bmr * 1.2);
		final double total = tdee + widget.weightLiftingBurn + widget.cardioBurn + widget.epoc;

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Results")),
			body: Column
			(
				children:
				[
					displayInfo("Basal Metabolic Rate (BMR)", "${widget.bmr.truncate()} kcal"),
					displayInfo("Total Daily Energy Expenditure (TDEE)", "${tdee.truncate()} kcal"),
					displayInfo("Weightlifting Burn (MET Method)", "${widget.weightLiftingBurn.truncate()} kcal"),
					displayInfo("Running Burn (Distance Method)", "${widget.cardioBurn.truncate()} kcal"),
					displayInfo("Recovery Burn (EPOC)", "${widget.epoc.truncate()} kcal"),
					displayInfo("Total Caloric Intake Required", "${total.truncate()}"),

					button(context, tdee, total)
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

	Widget button(BuildContext context, double tdee, double total)
	{
		return Card
		(
			child: ElevatedButton
			(
				onPressed: ()
				{
					newCalculation(widget.personWeight, widget.bmr, tdee, widget.weightLiftingBurn, widget.cardioBurn, widget.epoc, total);
					
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

	void newCalculation(double weight, double bmr, double tdee, double weightLiftingBurn, double cardioBurn, double epoc, double total)
	{
		Calculation calc = Calculation(id: null, date: DateTime.now().toIso8601String(), personWeight: weight, bmr: bmr, tdee: tdee, weightLiftingBurn: weightLiftingBurn, cardioBurn: cardioBurn, epoc: epoc, totalBurn: total);

		_list.uploadCalc(calc);
	}
}