import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/results.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';

class EPOCPage extends StatefulWidget
{
	final double personWeight;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	
	const EPOCPage({super.key, required this.personWeight, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn});

	@override
	State<EPOCPage> createState() => _EPOCPageState();
}

class _EPOCPageState extends State<EPOCPage>
{
	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("EPOC Calculator")),
			body: Column
			(
				children:
				[
					button("Low Intensity (Steady State): 5% EPOC", 0.05),
					button("High Intensity (HIIT / Weights): 10% EPOC", 0.1),
					button("Extreme Intensity (RPE 10 / Failure): 15% EPOC", 0.15)
				],
			)
		);
	}

	Widget button(String text, double epocFactor)
	{
		return Card
		(
			child: ElevatedButton
			(
				onPressed: ()
				{
					final double epoc = (widget.activityBurn + widget.cardioBurn) * epocFactor;

					Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, ResultsPage(personWeight: widget.personWeight, bmr: widget.bmr, tdee: widget.tdee, activityBurn: widget.activityBurn, cardioBurn: widget.cardioBurn, epoc: epoc))) // Takes you to the page that shows all the locations connected to the restaurant
					);
				},
				child: Padding
				(
					padding: const EdgeInsets.all(16.0),
					child: Text(text, textAlign: TextAlign.center,),
				),
			)
		);
	}
}