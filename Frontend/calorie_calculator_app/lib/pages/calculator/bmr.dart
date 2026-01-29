import 'package:calorie_calculator_app/utilities/colours.dart';
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

enum Tdee
{
	sedentary,
	lightlyActive,
	moderatelyActive,
	heavilyActive
}

extension TdeeValues on Tdee
{
	double get tdeeValue
	{
		switch (this)
		{
			case Tdee.sedentary: return 1.2;
			case Tdee.lightlyActive: return 1.375;
			case Tdee.moderatelyActive: return 1.55;
			case Tdee.heavilyActive: return 1.725;
		}
	}
}

class _BMRPageState extends State<CalculatorPage>
{
	final TextEditingController weight = TextEditingController();
	final TextEditingController height = TextEditingController();
	final TextEditingController age = TextEditingController();

	int isTdeeSelected = 0;
	double selectedTdee = 1.2;

	Gender? chosenGender;
	Color? maleColour;
	Color? femaleColour;

	Object? latestBMR;
	Object? latestTDEE;
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
		return SingleChildScrollView
		(
			child: Center
			(
				child: Column
				(
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children:
					[
						header("Calorie Calculator", 30, FontWeight.bold),

						header("Measurements", 25, FontWeight.w600),
						textBox("Weight", "kg", weight, fieldToSave: 1),
						textBox("Height", "cm", height, fieldToSave: 2),
						textBox("Age", "years", age, fieldToSave: 3, padding: 47),

						header("Baseline Activity Level", 25, FontWeight.w600),
						Column
						(
							children:
							[
								Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										tdeeChip("Sedentary", Tdee.sedentary, 0),
										tdeeChip("Lightly Active", Tdee.lightlyActive, 1),
									]
								),
								Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										tdeeChip("Moderately Active", Tdee.moderatelyActive, 2),
										tdeeChip("Heavily Active", Tdee.heavilyActive, 3),
									]
								),
							],
						),

						header("Gender", 25, FontWeight.w600),
						Row
						(
							mainAxisAlignment: MainAxisAlignment.center,
							children:
							[
								male(),
								female(),
							]
						),
					
						Row
						(
							mainAxisAlignment: MainAxisAlignment.center,
							children:
							[
								const Padding(padding: EdgeInsetsGeometry.only(top: 100)),
								nextButton(),
								const Padding(padding: EdgeInsetsGeometry.only(left: 15, right: 15)),
								continueWithButton(),
							]
						)
					],
				),
			),
		);
	}

	Widget header(String text, double fontSize, FontWeight fontWeight)
	{
		return Padding
		(
			padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
			child: Text
			(
				text,
				style: TextStyle
				(
					fontSize: fontSize,
					fontWeight: fontWeight,
				),
			),
		);
	}
	
	Widget textBox(String header, String unit, TextEditingController controller, {int? fieldToSave, double? padding})
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 105,
				width: 300,
				child: Card
				(
					color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
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
				
							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								children:
								[
									Padding
									(
										padding: EdgeInsets.only(left: padding ?? 30.0),
										child: SizedBox
										(
											height: 40,
											width: 100,
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
														fontSize: 15,
														color: Colors.black
													),
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
													inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
													keyboardType: const TextInputType.numberWithOptions(decimal: true),
												),
											),
										),
									),
					
									Padding
									(
										padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
										child: Text
										(
											unit,
											style: const TextStyle
											(
												fontSize: 17,
												fontWeight: FontWeight.bold
											),
										),
									)
								],
							)
						],
					),
				),
			),
		);
	}

	Widget tdeeChip(String label, Tdee tdee, int index)
	{
		return Padding
		(
			padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
			child: ChoiceChip
			(
				label: Text(label, style: TextStyle(color: Colors.black)),
				selected: isTdeeSelected == index,
				onSelected: (value)
				{
					setState(()
					{
						selectedTdee = tdee.tdeeValue;
						isTdeeSelected = index;
					});
				},
				selectedColor: Theme.of(context).extension<AppColours>()!.secondaryColour!,
				backgroundColor: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
				checkmarkColor: Colors.black,
			),
		);
	}

	Widget male()
	{
		Color? blue = Colors.blue[200];
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(maleColour == null)
					{
						maleColour = blue;
						femaleColour = null;
						chosenGender = Gender.male;
						return;
					}

					if(maleColour == blue)
					{
						maleColour = null;
						femaleColour = null;
						chosenGender = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: maleColour == null ? Colors.blue[50] : blue,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.male_rounded, size: 70, color: Colors.black),
				),
			),
		);
	}

	Widget female()
	{
		Color? pink = Colors.pink[200];
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(femaleColour == null)
					{
						femaleColour = pink;
						maleColour = null;
						chosenGender = Gender.female;
						return;
					}

					if(femaleColour == pink)
					{
						femaleColour = null;
						maleColour = null;
						chosenGender = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: femaleColour == null ? Colors.pink[50] : pink,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.female_rounded, size: 70, color: Colors.black),
				),
			),
		);
	}

	Widget nextButton()
	{
		return SizedBox
		(
			height: 70,
			width: 120,
			child: Card
			(
				shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
				elevation: 2,
				child: ListenableBuilder
				(
					listenable: Listenable.merge([weight, height, age]), // Combines all the controllers together to say "Track all these guys's changes"
					builder: (context, child)
					{
						return ElevatedButton
						(
							style: ElevatedButton.styleFrom
							(
								backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
							),
							onPressed: areFieldsEmpty() ? null : () async // Async so that the nav.push can be awaited, so that as soon as the user comes back to this page after coming from the results page, the page is rebuilt via setState and the bmr checker runs, allowing the button to be usable. Instead of forcing the user to go to another page, then back here so that the page rebuilds
							{
								final double weightNum = double.parse(weight.text.trim());
								final double heightNum = double.parse(height.text.trim());
								final double ageNum = double.parse(age.text.trim());
				
								final double bmr = (10 * weightNum) + (6.25 * heightNum) - (5 * ageNum) + chosenGender!.caloricValue;
								final double tdee = bmr * selectedTdee;
				
								await Navigator.push
								(
									context,
									MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage(bmr: bmr, tdee: tdee, personWeight: weightNum))) // Takes you to the page that shows all the locations connected to the restaurant
								);
				
								setState(()
								{
									bmrExistsAlready();
								});
							},
							child: const Text("Next", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			),
		);
	}

	Widget continueWithButton()
	{
		return SizedBox
		(
			height: 70,
			width: 170,
			child: Card
			(
				shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
				elevation: 2,
				child: FutureBuilder
				(
					future: bmrExistsAlready(),
					builder: (context, snapshot)
					{
						bool notFound = snapshot.data ?? false;

						return ElevatedButton
						(
							style: ElevatedButton.styleFrom
							(
								backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
							),
							onPressed: !notFound ? null : () async // if the fields are empty then grey out the button
							{
								await Navigator.push
								(
									context,
									MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage(bmr: latestBMR as double, tdee: latestTDEE as double, personWeight: latestWeight as double))) // Takes you to the page that shows all the locations connected to the restaurant
								);

								setState(()
								{
									bmrExistsAlready();
								});
							},
							child: Text("Stick with ${(latestTDEE as double?)?.round() ?? 0.round()} TDEE", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
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
			latestTDEE = allCalcs.last[dbInstance.calcsTDEEColumnName];
			latestWeight = allCalcs.last[dbInstance.calcsWeightColumnName];
			return true;
		}
	}
}