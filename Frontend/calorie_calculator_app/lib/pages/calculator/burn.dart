import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/pages/calculator/epoc.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BurnPage extends StatefulWidget
{
	final double bmr;
	final double personWeight;
	
	const BurnPage({super.key, required this.bmr, required this.personWeight});

	@override
	State<BurnPage> createState() => _BurnPageState();
}

enum Cardio
{
	run,
	cycle
}

extension CardioValues on Cardio
{
	double get caloricValue
	{
		switch (this)
		{
			case Cardio.run: return 1;
			case Cardio.cycle: return 0.3;
		}
	}
}

enum WeightLifting
{
	upper,
	mix,
	lower
}

extension WeightLiftingValues on WeightLifting
{
	double get weightLiftingValue
	{
		switch (this)
		{
			case WeightLifting.upper: return 1;
			case WeightLifting.mix: return 1.2;
			case WeightLifting.lower: return 1.4;
		}
	}
}

class _BurnPageState extends State<BurnPage>
{
	double? metFactor;
	Cardio? chosenCardio;
	WeightLifting? chosenLift;
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
					weightLifting(),

					textBox("Distance in km", distance, fieldToSave: 2),
					cardio(),

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
							crossAxisCount: 3,
							childAspectRatio: 1
						),
						delegate: SliverChildBuilderDelegate
						(
							(context, index)
							{
								return switch(index)
								{
									0 => option("Light | < 4.0 METs", 0, nonRadio: true),
									1 => option("Moderate | 4.0 - 6.0 METs", 0, nonRadio: true),
									2 => option("Vigorous | < 6.0 METs", 0, nonRadio: true),
									3 => option("Yoga: 2.5", 2.5),
									4 => option("Badminton: 4.5", 4.5),
									5 => option("Heavy Weights: 6", 6),
									6 => option("Light Weights: 3.5", 3.5),
									7 => option("Moderate Weights: 5", 5),
									8 => option("Tennis: 7", 7),
								  	_ => option("", 1),
								};
							},
							childCount: 9
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

	Widget weightLifting()
	{
		return SegmentedButton<WeightLifting>
		(
			segments: const
			[
				ButtonSegment(value: WeightLifting.upper, label: Text('Upper')),
				ButtonSegment(value: WeightLifting.mix, label: Text('Upper / Lower Mix')),
				ButtonSegment(value: WeightLifting.lower, label: Text('Lower')),
			],
			selected: {?chosenLift},
			onSelectionChanged: (Set<WeightLifting> newSelection)
			{
				setState(()
				{
					chosenLift = newSelection.first;
				});
			},
			emptySelectionAllowed: true,
		);
	}

	Widget cardio()
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
							childAspectRatio: 3
						),
						delegate: SliverChildBuilderDelegate
						(
							(context, index)
							{
								return switch(index)
								{
									0 => cardioOption(Icons.run_circle_outlined, Cardio.run),
									1 => cardioOption(Icons.directions_bike_rounded, Cardio.cycle),
								  	_ => cardioOption(Icons.run_circle_outlined, Cardio.run),
								};
							},
							childCount: 2
						),
					),
				],

			)
		);
	}

	Widget cardioOption(IconData icon, Cardio cardio)
	{
		return Card
		(
			shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
			child: RadioListTile<Cardio>
			(
				shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
				title: Padding
				(
					padding: const EdgeInsets.only(right: 60),
					child: Icon(icon, size: 50,),
				),
				radioScaleFactor: 0,
				value: cardio,
				groupValue: chosenCardio,
				onChanged: (newValue)
				{
					setState( ()
					{
						chosenCardio = newValue;
					});
				},
				selectedTileColor: Colors.blueGrey[100],
				selected: cardio == chosenCardio ? true : false,
			)
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
						onPressed: areFieldsEmpty() ? null : ()
						{
							final double durationNum = double.tryParse(workoutDuration.text.trim()) ?? 0;
							final double distanceNum = double.tryParse(distance.text.trim()) ?? 0;

							final double weightLiftingBurn = ((((metFactor ?? 0) * 3.5 * widget.personWeight) / 200) * durationNum) * 0.8 * (chosenLift?.weightLiftingValue ?? 0);
							final double cardioBurn = widget.personWeight * distanceNum * (chosenCardio?.caloricValue ?? 0);

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

	bool areFieldsEmpty()
	{
		if((metFactor == null && chosenLift == null && workoutDuration.text.isEmpty) && (chosenCardio == null && distance.text.isEmpty))
		{
			return true;
		}
		else if((metFactor == null || chosenLift == null) && workoutDuration.text.isNotEmpty)
		{
			return true;
		}
		else if(chosenCardio == null && distance.text.isNotEmpty)
		{
			return true;
		}

		return false;
	}
}