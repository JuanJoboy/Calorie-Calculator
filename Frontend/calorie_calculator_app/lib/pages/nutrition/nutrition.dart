import 'package:calorie_calculator_app/pages/nutrition/diet.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class NutritionPage extends StatefulWidget
{
	const NutritionPage({super.key});

	@override
	State<NutritionPage> createState() => _NutritionPageState();
}

enum Gender
{
	male(value: 30, label: 'Male'),
	female(value: 25, label: 'Female');

	final double value;
	final String label;

	const Gender({required this.value, required this.label});
}

abstract interface class Intensity
{
	double get value;
	String get label;
}

enum ProteinIntensity implements Intensity
{
	maintenance(value: 1.6, label: 'Maintenance / Moderate Activity'),
	bulk(value: 1.9, label: 'Lean Bulk / Muscle Gain'),
	cut(value: 2.2, label: 'Aggressive Cut / Fat Loss');

	@override
	final double value;
	@override
	final String label;

	const ProteinIntensity({required this.value, required this.label});
}

enum FatIntensity implements Intensity
{
	low(value: 0.20, label: 'Low Fat Diet'),
	mid(value: 0.25, label: 'Balanced Fat Diet'),
	high(value: 0.30, label: 'High Fat Diet');

	@override
	final double value;
	@override
	final String label;

	const FatIntensity({required this.value, required this.label});
}

class _NutritionPageState extends State<NutritionPage>
{
	final TextEditingController weight = TextEditingController();
	final TextEditingController tdee = TextEditingController();

	int isProteinSelected = 0;
	double selectedProteinIntensity = ProteinIntensity.maintenance.value;

	int isFatSelected = 1;
	double selectedFatIntensity = FatIntensity.mid.value;

	Gender? chosenGender;
	Color? maleColour;
	Color? femaleColour;

	late NutritionFields _nutris;

	@override
	void dispose()
	{
		super.dispose();
		weight.dispose();
		tdee.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final NutritionFields fields = context.read<NutritionFields>();
		_nutris = fields;

		weight.text = _nutris.we;
		tdee.text = _nutris.td;
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
						Utils.header("Macro Calculator", 30, FontWeight.bold),

						Utils.widgetPlusHelper(Utils.header("Today's Biometrics", 25, FontWeight.w600), HelpIcon(msg: "Input your current body weight, caloric intake for today, and the duration of the exercise you did into the text fields. If you didn't do any exercise today, leave it blank or enter 0.",), top: 45, right: 17.5),

						textBox("Weight", "kg", weight, fieldToSave: 1, padding: 30),
						textBox("Total Calories Today", "kcal", tdee, fieldToSave: 2, padding: 45),

						chips("Protein Intensity", "Select the amount of protein that you want in your diet. 'Aggressive Cut / Fat Loss' helps preserve lean mass during a deficit and increases satiety, while 'Maintenance' provides the baseline RDA for health.", ProteinIntensity.values, true),

						chips("Fat Intake", "Select the amount of fat that you want in your diet. High Fat supports hormonal health and fat-soluble vitamin absorption (A, D, E, K), while Low Fat allows for higher carbohydrate volume to fuel high-intensity training.", FatIntensity.values, false),

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

						processInfo(),

						const Padding(padding: EdgeInsetsGeometry.only(top: 20)),
					],
				),
			),
		);
	}

	Widget chips(String header, String helpMsg, List<Intensity> intensity, bool isProtein)
	{
		return Column
		(
			children:
			[
				Utils.widgetPlusHelper(Utils.header(header, 25, FontWeight.w600), HelpIcon(msg: helpMsg), top: 45, right: 17.5),
				
				for(int i = 0; i < intensity.length; i++)
					intensityChip(intensity[i], i, isProtein)
			],
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
															case 1: _nutris.updateControllers(weight: value);
															case 2: _nutris.updateControllers(tdee: value);
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

	Widget intensityChip(Intensity intensity, int index, bool isProtein)
	{
		return Padding
		(
			padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
			child: ChoiceChip
			(
				label: Text(intensity.label, style: const TextStyle(color: Colors.black)),
				selected: isProtein == true ? isProteinSelected == index : isFatSelected == index,
				onSelected: (value)
				{
					setState(()
					{
						if(isProtein)
						{
							selectedProteinIntensity = intensity.value;
							isProteinSelected = index;
						}
						else
						{
							selectedFatIntensity = intensity.value;
							isFatSelected = index;
						}
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

	Widget processInfo()
	{
		return SizedBox
		(
			height: 70,
			width: 150,
			child: Card
			(
				shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
				elevation: 2,
				child: ListenableBuilder
				(
					listenable: Listenable.merge([weight, tdee]),
					builder: (context, child)
					{
						return ElevatedButton
						(
							style: ElevatedButton.styleFrom
							(
								backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
							),
							onPressed: areFieldsEmpty() ? null : () async
							{
								await Navigator.push
								(
									context,
									MaterialPageRoute(builder: (context) => Utils.switchPage(context, DietPage.noActivity(weight: parseTextFields().$1, tdee: parseTextFields().$2, proteinIntensity: selectedProteinIntensity, fatIntake: selectedFatIntensity, fibre: chosenGender!.value,)))
								);
							},
							child: const Text("Calculate Macros", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			),
		);
	}
	
	(double, int) parseTextFields()
	{
		final double weightNum = double.tryParse(weight.text.trim()) ?? 0;
		final int tdeeNum = int.tryParse(tdee.text.trim()) ?? 0;

		return (weightNum, tdeeNum);
	}

	bool areFieldsEmpty()
	{
		return (weight.text.trim().isEmpty) || (tdee.text.trim().isEmpty) || (chosenGender == null);
	}
}

class NutritionFields extends ChangeNotifier
{
	String we = "";
	String td = "";

	void updateControllers({String? weight, String? tdee})
	{
		if(weight != null) we = weight;
		if(tdee != null) td = tdee;
	}
}