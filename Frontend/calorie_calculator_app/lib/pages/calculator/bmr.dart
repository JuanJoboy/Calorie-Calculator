import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatefulWidget
{
	const CalculatorPage({super.key});

	@override
	State<CalculatorPage> createState() => _BMRPageState();
}

enum Gender
{
	male,
	female
}

extension GenderValues on Gender
{
	int get caloricValue
	{
		switch (this)
		{
			case Gender.male: return 5;
			case Gender.female: return -161;
		}
	}
}

class _BMRPageState extends State<CalculatorPage>
{
	final TextEditingController weight = TextEditingController();
	final TextEditingController height = TextEditingController();
	final TextEditingController age = TextEditingController();

	Gender? chosenGender;

	Object? latestBMR;
	Object? latestWeight;

	late CalculationFields _calcs;

	@override
	void dispose()
	{
		// Must be disposed to avoid memory leaks
		super.dispose();
		weight.dispose();
		height.dispose();
		age.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final CalculationFields list = context.read<CalculationFields>(); // Since there's no context available here, I just read, rather than making and adding the widget to the tree
		_calcs = list;

		// On the first go, it sets all the fields to blank, but then whenever the user goes to another page, and then back here, the page will rebuild with the previous values. This is so that the fields don't keep resetting
		weight.text = _calcs.w;
		height.text = _calcs.h;
		age.text = _calcs.a;
  	}

	@override
	Widget build(BuildContext context)
	{
		return Column
		(
			children:
			[
				textBox("Weight in kg:", weight, fieldToSave: 1),
				textBox("Height in cm", height, fieldToSave: 2),
				textBox("Age in years", age, fieldToSave: 3),

				gender(),

				Row
				(
					children:
					[
						button1("Next"),
						button2(),
					]
				)
			],
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
								case 1: _calcs.updateControllers(weight: value);
								case 2: _calcs.updateControllers(height: value);
								case 3: _calcs.updateControllers(age: value);
							}
						},
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))]
					),
				],
			),
		);
	}

	Widget gender()
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
									0 => option(Icons.male_rounded, Gender.male),
									1 => option(Icons.female_rounded, Gender.female),
								  	_ => option(Icons.male_rounded, Gender.male),
								};
							},
							childCount: 2
						),
					),
				],

			)
		);
	}

	Widget option(IconData icon, Gender gender)
	{
		return Card
		(
			shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
			child: RadioListTile<Gender>
			(
				shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
				title: Padding
				(
					padding: const EdgeInsets.only(right: 60),
					child: Icon(icon, size: 60,),
				),
				radioScaleFactor: 0,
				value: gender,
				groupValue: chosenGender,
				onChanged: (newValue)
				{
					setState( ()
					{
						chosenGender = newValue;
					});
				},
				selectedTileColor: chosenGender == Gender.male ? Colors.blue : Colors.pink,
				selected: gender == chosenGender ? true : false,
			)
		);
	}

	Widget button1(String text)
	{
		return Card
		(
			child: ListenableBuilder
			(
				listenable: Listenable.merge([weight, height, age]), // Combines all the controllers together to say "Track all these guys's changes"
				builder: (context, child)
				{
					return ElevatedButton
					(
						onPressed: areFieldsEmpty() ? null : () async // Async so that the nav.push can be awaited, so that as soon as the user comes back to this page after coming from the results page, the page is rebuilt via setState and the bmr checker runs, allowing the button to be usable. Instead of forcing the user to go to another page, then back here so that the page rebuilds
						{
							final double weightNum = double.parse(weight.text.trim());
							final double heightNum = double.parse(height.text.trim());
							final double ageNum = double.parse(age.text.trim());

							final double bmr = (10 * weightNum) + (6.25 * heightNum) - (5 * ageNum) + chosenGender!.caloricValue;

							await Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage(bmr: bmr, personWeight: weightNum))) // Takes you to the page that shows all the locations connected to the restaurant
							);

							setState(()
							{
								bmrExistsAlready();
							});
						},
						child: Padding
						(
							padding: const EdgeInsets.all(16.0),
							child: Text(text, textAlign: TextAlign.center,),
						),
					);
				}
			)
		);
	}

	Widget button2()
	{
		return Card
		(
			child: FutureBuilder
			(
				future: bmrExistsAlready(),
				builder: (context, snapshot)
				{
					bool notFound = snapshot.data ?? false;

					return ElevatedButton
					(
						onPressed: !notFound ? null : () async // if the fields are empty then grey out the button
						{
							await Navigator.push
							(
								context,
								MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage(bmr: latestBMR as double, personWeight: latestWeight as double))) // Takes you to the page that shows all the locations connected to the restaurant
							);

							setState(()
							{
								bmrExistsAlready();
							});
						},
						child: Padding
						(
							padding: const EdgeInsets.all(16.0),
							child: Text("Stick with ${(latestBMR as double?)?.truncate() ?? 0.truncate()} BMR", textAlign: TextAlign.center,),
						),
					);
				}
			)
		);
	}

	bool areFieldsEmpty()
	{
		return (weight.text.trim().isEmpty) || (height.text.trim().isEmpty) || (age.text.trim().isEmpty) || (chosenGender == null); // Ensures that all the fields are filled
	}

	Future<bool> bmrExistsAlready() async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;

		final allCalcs = await db.rawQuery("SELECT * FROM ${dbInstance.calcsTableName}");
		
		if(allCalcs.isEmpty)
		{
			return false;
		}
		else
		{
			latestBMR = allCalcs.last[dbInstance.calcsBMRColumnName];
			latestWeight = allCalcs.last[dbInstance.calcsWeightColumnName];
			return true;
		}
	}
}