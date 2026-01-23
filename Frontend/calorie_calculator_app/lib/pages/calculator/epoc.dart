import 'package:flutter/material.dart';
import 'package:food_files_app/pages/calculator/results.dart';
import 'package:food_files_app/utilities/utilities.dart';

class EPOCPage extends StatefulWidget
{
	final double bmr;
	final double weightLiftingBurn;
	final double cardioBurn;
	
	const EPOCPage({super.key, required this.bmr, required this.weightLiftingBurn, required this.cardioBurn});

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
					button("Low Intensity Session: 5% EPOC", 0.05),

					button("High Intensity Session: 10% EPOC", 0.1)
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
					final double epoc = (widget.weightLiftingBurn + widget.cardioBurn) * epocFactor;

					Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, ResultsPage(bmr: widget.bmr, weightLiftingBurn: widget.weightLiftingBurn, cardioBurn: widget.cardioBurn, epoc: epoc))) // Takes you to the page that shows all the locations connected to the restaurant
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