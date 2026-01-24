import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_files_app/pages/calculator/calculations.dart';
import 'package:food_files_app/pages/calculator/epoc.dart';
import 'package:food_files_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BurnPage extends StatefulWidget
{
	final double bmr;
	final double personWeight;
	
	const BurnPage({super.key, required this.bmr, required this.personWeight});

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
		return Expanded
		(
			child: CustomScrollView
			(
				slivers:
				[
					SliverGrid
					(
						gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
						(
							crossAxisCount: 2,
							childAspectRatio: 2
						),
						delegate: SliverChildBuilderDelegate
						(
							(context, index)
							{
								return switch(index)
								{
									0 => option("Light | < 3.0 METs", 0, nonRadio: true),
									1 => option("Moderate | 3.0 - 8.0 METs", 0, nonRadio: true),
									2 => option("Sitting: 1.3", 1.3),
									3 => option("Light Weights: 3.5", 3.5),
									4 => option("Standing: 1.8", 1.8),
									5 => option("Heavy Weights: 5", 5),
									6 => option("Yoga: 2.5", 2.5),
									7 => option("Tennis: 8", 8),
								  	_ => option("", 1),
								};
							},
							childCount: 8
						),
					),
				],

			)
		);
	}

	Widget option(String text, double factor, {bool? nonRadio})
	{
		if(nonRadio == true)
		{
			return Padding
			(
				padding: const EdgeInsets.only(top: 30.0),
				child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
			);
		}
		else
		{
			return Card
			(
				child: RadioListTile<double>
				(
					title: Text(text),
					value: factor,
					groupValue: metFactor,
					onChanged: (newValue)
					{
						setState(() => metFactor = newValue);
					},
				)
			);
		}
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

							final double weightLiftingBurn = metFactor! * widget.personWeight * (durationNum / 60) * 0.8;
							final double cardioBurn = widget.personWeight * distanceNum;

							Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Utils.switchPage(context, EPOCPage(personWeight: widget.personWeight, bmr: widget.bmr, weightLiftingBurn: weightLiftingBurn, cardioBurn: cardioBurn))) // Takes you to the page that shows all the locations connected to the restaurant
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