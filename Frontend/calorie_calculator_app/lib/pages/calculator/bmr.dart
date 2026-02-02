import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatefulWidget
{
	final String title;
	final bool isDedicatedBMRPage;

	const CalculatorPage({super.key, required this.title, required this.isDedicatedBMRPage});

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
	moderate,
	active,
	vigorous
}

extension TdeeValues on Tdee
{
	double get tdeeValue
	{
		switch (this)
		{
			case Tdee.sedentary: return 1.45;
			case Tdee.moderate: return 1.75;
			case Tdee.active: return 2.00;
			case Tdee.vigorous: return 2.20;
		}
	}
}

class _BMRPageState extends State<CalculatorPage>
{
	final TextEditingController weight = TextEditingController();
	final TextEditingController height = TextEditingController();
	final TextEditingController age = TextEditingController();

	int isTdeeSelected = 0;
	double selectedTdee = Tdee.sedentary.tdeeValue;

	Gender? chosenGender;
	Color? maleColour;
	Color? femaleColour;

	double? latestBMR;
	double? latestTDEE;
	double? latestWeight;

	late CalculationFields _calcs;
	late UsersTdeeNotifier _tdeeNotifier;

	Future<bool>? bmrExists;

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
		final UsersTdeeNotifier tdeeNotifier = context.read<UsersTdeeNotifier>();
		_tdeeNotifier = tdeeNotifier;

		// On the first go, it sets all the fields to blank, but then whenever the user goes to another page, and then back here, the page will rebuild with the previous values. This is so that the fields don't keep resetting
		weight.text = _calcs.w;
		height.text = _calcs.h;
		age.text = _calcs.a;

		bmrExists = bmrExistsAlready(); // Initializes the Future once to ensure the database is queried only once
  	}

	@override
	Widget build(BuildContext context)
	{
		return SingleChildScrollView
		(
			physics: const BouncingScrollPhysics(),
			child: Center
			(
				child: Column
				(
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children:
					[
						Utils.header(widget.title, 30, FontWeight.bold),

						Utils.widgetPlusHelper(Utils.header("Measurements", 25, FontWeight.w600), HelpIcon(msg: "Input your current body weight, height, and age into the text fields.",), top: 45, right: 17.5),

						textBox("Weight", "kg", weight, fieldToSave: 1),
						textBox("Height", "cm", height, fieldToSave: 2),
						textBox("Age", "years", age, fieldToSave: 3, padding: 47),

						Utils.widgetPlusHelper(Utils.header("Physical Activity Level", 25, FontWeight.w600), HelpIcon(msg: "Select a Physical Activity Level (PAL) based on your occupational movement and daily routine only. Do not include gym sessions or sports, as these are calculated on the next page. If an activity that you regularly do isn't listed on the next page, adjust this PAL upward to account for that additional energy demand.",), top: 45, right: 17.5),
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
										tdeeChip("Moderately Active", Tdee.moderate, 1),
									]
								),
								Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										tdeeChip("Active", Tdee.active, 2),
										tdeeChip("Vigorously Active", Tdee.vigorous, 3),
									]
								),
							],
						),

						Utils.widgetPlusHelper(Utils.header("Gender", 25, FontWeight.w600), HelpIcon(msg: "Click on one of the 2 buttons below, that you most identify with.",), top: 45, right: 17.5),
						
						Row
						(
							mainAxisAlignment: MainAxisAlignment.center,
							children:
							[
								male(),
								female(),
							]
						),

						buttonsThatProcessInfo()
					],
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
				label: Text(label, style: const TextStyle(color: Colors.black)),
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
		Color unselectedBlue = Theme.of(context).extension<AppColours>()!.maleUnColour!;
		Color selectedBlue = Theme.of(context).extension<AppColours>()!.maleSeColour!;

		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(maleColour == null)
					{
						maleColour = selectedBlue;
						femaleColour = null;
						chosenGender = Gender.male;
						return;
					}

					if(maleColour == selectedBlue)
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
					color: maleColour == null ? unselectedBlue : selectedBlue,
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
		Color unselectedPink = Theme.of(context).extension<AppColours>()!.femaleUnColour!;
		Color selectedPink = Theme.of(context).extension<AppColours>()!.femaleSeColour!;
		
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(femaleColour == null)
					{
						femaleColour = selectedPink;
						maleColour = null;
						chosenGender = Gender.female;
						return;
					}

					if(femaleColour == selectedPink)
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
					color: femaleColour == null ? unselectedPink : selectedPink,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.female_rounded, size: 70, color: Colors.black),
				),
			),
		);
	}

	Widget buttonsThatProcessInfo()
	{
		if(widget.isDedicatedBMRPage)
		{
			return nextButton("Upload TDEE");
		}
		else
		{
			return Row
			(
				mainAxisAlignment: MainAxisAlignment.center,
				children:
				[
					const Padding(padding: EdgeInsetsGeometry.only(top: 100)),
					nextButton("Next"),
					const Padding(padding: EdgeInsetsGeometry.only(left: 15, right: 15)),
					continueWithButton(),
				]
			);
		}
	}

	Widget nextButton(String nextText)
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
								processInfo();
							},
							child: Text(nextText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
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
					future: bmrExists,
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

								// May not need
								// setState(()
								// {
								// 	bmrExistsAlready();
								// });
							},
							child: Text("Stick with ${(latestTDEE)?.round() ?? 0.round()} TDEE", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			)
		);
	}

	(double, double, double) calculateBodyInfo()
	{
		final double weightNum = double.parse(weight.text.trim());
		final double heightNum = double.parse(height.text.trim());
		final double ageNum = double.parse(age.text.trim());

		final double bmr = (10 * weightNum) + (6.25 * heightNum) - (5 * ageNum) + chosenGender!.caloricValue;
		final double tdee = bmr * selectedTdee;

		return (bmr, tdee, weightNum);
	}

	void processInfo() async
	{
		final (bmr, tdee, weightNum) = calculateBodyInfo();

		if(widget.isDedicatedBMRPage)
		{
			setState(()
			{
				_tdeeNotifier.uploadOrEditTdee(bmr, tdee, weightNum); // Forces a rebuild of the page which ensures that the bmrExists variable is refreshed and sees the new value instead of being on the stale old value
			});
		}
		else
		{
			await Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage(bmr: bmr, tdee: tdee, personWeight: weightNum))) // Takes you to the page that shows all the locations connected to the restaurant
			);
		}

		// May not need
		// setState(()
		// {
		// 	bmrExistsAlready();
		// });			
	}

	bool areFieldsEmpty()
	{
		return (weight.text.trim().isEmpty) || (height.text.trim().isEmpty) || (age.text.trim().isEmpty) || (chosenGender == null); // Ensures that all the fields are filled
	}

	Future<bool> bmrExistsAlready() async
	{
		final dbInstance = DatabaseHelper.instance;
		final db = await dbInstance.database;

		final preExistingTdee = await db.rawQuery("SELECT * FROM ${dbInstance.tdeeTableName}");
		
		if(preExistingTdee.isEmpty)
		{
			return false;
		}
		else
		{
			latestBMR = preExistingTdee.first[dbInstance.tdeeBMRColumnName] as double?;
			latestTDEE = preExistingTdee.first[dbInstance.tdeeTDEEColumnName] as double?;
			latestWeight = preExistingTdee.first[dbInstance.tdeeWeightColumnName] as double?;

			return true;
		}
	}
}