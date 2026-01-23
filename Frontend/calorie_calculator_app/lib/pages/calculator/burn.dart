import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_files_app/pages/calculator/calculations.dart';
import 'package:food_files_app/pages/calculator/epoc.dart';
import 'package:food_files_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BurnPage extends StatefulWidget
{
	final double bmr;
	final double weight;
	
	const BurnPage({super.key, required this.bmr, required this.weight});

	@override
	State<BurnPage> createState() => _BurnPageState();
}

class _BurnPageState extends State<BurnPage>
{
	double? metFactor;
	final TextEditingController workoutDuration = TextEditingController();
	final TextEditingController distance = TextEditingController();

	late CalculationFields _calcs;

	@override
	void dispose()
	{
		super.dispose();
		workoutDuration.dispose();
		distance.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final CalculationFields list = context.read<CalculationFields>();
		_calcs = list;

		workoutDuration.text = _calcs.wd;
		distance.text = _calcs.d;
  	}

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Burn Calculator")),
			body: Column
			(
				children:
				[
					met(),

					textBox("Workout Duration in minutes", workoutDuration, fieldToSave: 1),
					textBox("Distance in km", distance, fieldToSave: 2),

					button(),
				],
			)
		);
	}

	Widget met()
	{
		return GridView.count
		(
			shrinkWrap: true, // Takes up only the required space instead of being infinite
			crossAxisCount: 2, // Number of columns
			crossAxisSpacing: 10, // Horizontal space between items
			mainAxisSpacing: 10, // Vertical space between items
			children:
			[
				const Row
				(
					children:
					[
						Expanded(child: Text("Light | < 3.0 METs", textAlign: TextAlign.center,)),
						Expanded(child: Text("Moderate | 3.0 - 8.0 METs", textAlign: TextAlign.center,)),
					]
				),

				option("Sitting: 1.3", 1.3),
				option("Weight training (lighter weights): 3.5", 3.5),
				option("Standing: 1.8", 1.8),
				option("Weight training (heavier weights): 5", 5),
				option("Yoga: 2.5", 2.5),
				option("Tennis: 8", 8),
			],
		);
	}

	Widget option(String text, double factor)
	{
		return RadioListTile<double>
		(
			title: Text(text),
			value: factor,
			onChanged: (m)
			{
				setState(() => metFactor = m);
      		},
    	);
	}

	Widget textBox(String text, TextEditingController controller, {TextStyle? textStyle, int? fieldToSave})
	{
		return Card
		(
			child: Column
			(
				children:
				[
					Text(text, style: textStyle?.copyWith(fontSize: 20)),

					TextField
					(
						style: textStyle?.copyWith(fontSize: 20),
						controller: controller,
						onChanged: (value)
						{
							switch(fieldToSave)
							{
								case 1: _calcs.updateControllers(workoutDuration: value);
								case 2: _calcs.updateControllers(distance: value);
							}
						},
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))]
					),
				],
			),
		);
	}

	Widget button()
	{
		return Card
		(
			child: ListenableBuilder
			(
				listenable: Listenable.merge([workoutDuration, distance]), // Combines all the controllers together to say "Track all these guys's changes"
				builder: (context, child)
				{
					return ElevatedButton
					(
						onPressed: metFactor == null ? null : ()
						{
							final double durationNum = double.tryParse(workoutDuration.text.trim()) ?? 0;
							final double distanceNum = double.tryParse(distance.text.trim()) ?? 0;

							final double weightLiftingBurn = metFactor! * widget.weight * (durationNum / 60) * 0.8;
							final double cardioBurn = widget.weight * distanceNum;

							Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Utils.switchPage(context, EPOCPage(bmr: widget.bmr, weightLiftingBurn: weightLiftingBurn, cardioBurn: cardioBurn))) // Takes you to the page that shows all the locations connected to the restaurant
							);
						},
						child: const Padding
						(
							padding: EdgeInsets.all(16.0),
							child: Text("Next", textAlign: TextAlign.center,),
						),
					);
				}
			)
		);
	}
}