import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/pages/calculator/epoc.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BurnPage extends StatefulWidget
{
	final double bmr;
	final double tdee;
	final double personWeight;
	
	const BurnPage({super.key, required this.bmr, required this.tdee, required this.personWeight});

	@override
	State<BurnPage> createState() => _BurnPageState();
}

enum MET
{
	light,
	intermediate,
	heavy,
	yoga,
	badminton,
	tennis,
}

extension METValues on MET
{
	double get metValue
	{
		switch (this)
		{
			case MET.light: return 3.5;
			case MET.intermediate: return 5.0;
			case MET.heavy: return 6.0;
			case MET.yoga: return 2.5;
			case MET.badminton: return 4.5;
			case MET.tennis: return 7.0;
		}
	}

	String get metText
	{
		switch (this)
		{
			case MET.light: return "Light Weights";
			case MET.intermediate: return "Intermediate Weights";
			case MET.heavy: return "Heavy Weights";
			case MET.yoga: return "Yoga";
			case MET.badminton: return "Badminton";
			case MET.tennis: return "Tennis";
		}
	}
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

class _BurnPageState extends State<BurnPage>
{
	double? metFactor;
	String? activityName;

	final TextEditingController sportDuration = TextEditingController();

	final TextEditingController upperDuration = TextEditingController();
	final TextEditingController accessoriesDuration = TextEditingController();
	final TextEditingController lowerDuration = TextEditingController();

	final TextEditingController distance = TextEditingController();
	Cardio? chosenCardio;
	Color? runColour;
	Color? cycleColour;

	late CalculationFields _calcs;

	@override
	void dispose()
	{
		super.dispose();
		sportDuration.dispose();
		upperDuration.dispose();
		accessoriesDuration.dispose();
		lowerDuration.dispose();
		distance.dispose();
	}

	@override void initState()
	{
    	super.initState();

		final CalculationFields list = context.read<CalculationFields>();
		_calcs = list;

		sportDuration.text = _calcs.s;
		upperDuration.text = _calcs.up;
		accessoriesDuration.text = _calcs.ac;
		lowerDuration.text = _calcs.lo;
		distance.text = _calcs.d;
  	}

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Burn Calculator")),
			body: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Center
				(
					child: Column
					(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.center,
						children:
						[
							met(),
							switcher(),
							cardio(),
							nextButton(),
						],
					),
				)
			)
		);
	}

	Widget met()
	{
		return Column
		(
			children:
			[
				header("Activity Selection", 30, FontWeight.bold),
			
				Row
				(
					children:
					[
						Expanded // Tells each column to take up 50% of the width, otherwise they'd just bunch up at the start
						(
							child: Column
							(
								children:
								[
									header("Gym", 25, FontWeight.w600),
									option(MET.light.metText, MET.light.metValue, padding: 5),
									option(MET.intermediate.metText, MET.intermediate.metValue, padding: 5),
									option(MET.heavy.metText, MET.heavy.metValue, padding: 5)
								]
							),
						),
			
						Expanded
						(
							child: Column
							(
								children:
								[
									header("Sport", 25, FontWeight.w600),
									option(MET.yoga.metText, MET.yoga.metValue, padding: 7.5),
									option(MET.badminton.metText, MET.badminton.metValue, padding: 7.5),
									option(MET.tennis.metText, MET.tennis.metValue, padding: 7.5)
								]
							),
						)
					],
				)
			],
		);
	}

	Widget header(String text, double fontSize, FontWeight fontWeight)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 40),
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

	Widget option(String text, double factor, {double? padding})
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 80,
				width: 210,
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
					child: Padding
					(
						padding: EdgeInsets.only(top: padding ?? 5),
						child: RadioListTile<double>
						(
							title: Text(text),
							value: factor,
							groupValue: metFactor,
							onChanged: (newValue)
							{
								setState(()
								{
									metFactor = newValue;
									activityName = text;
								});
							},
						),
					)
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
															case 1: _calcs.updateControllers(sport: value);
															case 2: _calcs.updateControllers(upper: value);
															case 3: _calcs.updateControllers(accessories: value);
															case 4: _calcs.updateControllers(lower: value);
															case 5: _calcs.updateControllers(distance: value);
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

	Widget switcher()
	{
		return AnimatedCrossFade
		(
			firstChild: metFactor == null ? const SizedBox.shrink() : sportWidget(),
			secondChild: metFactor == null ? const SizedBox.shrink() : weightLifting(),
			crossFadeState: selectedSport() ? CrossFadeState.showFirst : CrossFadeState.showSecond,
			duration: const Duration(milliseconds: 200)
		);
	}

	Widget sportWidget()
	{
		return Column
		(
			children:
			[
				const Padding(padding: EdgeInsetsGeometry.all(5)),

				header(activityName ?? "", 25, FontWeight.w600),

				textBox("Activity Duration", "mins", sportDuration, fieldToSave: 1)
			]
		);
	}

	bool selectedSport()
	{
		if((metFactor == null) || (metFactor == MET.yoga.metValue) || (metFactor == MET.badminton.metValue) || (metFactor == MET.tennis.metValue))
		{
			return true;
		}

		return false;
	}

	Widget weightLifting()
	{
		return Column
		(
			children:
			[
				const Padding(padding: EdgeInsetsGeometry.all(10)),

				header("Targeted Muscle Group", 25, FontWeight.w600),

				textBox("Upper Body Duration", "mins", upperDuration, fieldToSave: 2), // Compound
				textBox("Accessories Duration", "mins", accessoriesDuration, fieldToSave: 3), // Isolation
				textBox("Lower Body Duration", "mins", lowerDuration, fieldToSave: 4), // Compound
			]
		);
	}

	Widget cardio()
	{
		return Column
		(
			children:
			[
				header("Cardio", 25, FontWeight.w600),

				textBox("Distance", "km", distance, fieldToSave: 5),

				Row
				(
					mainAxisAlignment: MainAxisAlignment.center,
					children:
					[
						run(),
						cycle(),
					]
				),
			],
		);
	}

	Widget run()
	{
		Color unselectedGreen = Theme.of(context).extension<AppColours>()!.runUnColour!;
		Color selectedGreen = Theme.of(context).extension<AppColours>()!.runSeColour!;
		
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(runColour == null)
					{
						runColour = selectedGreen;
						cycleColour = null;
						chosenCardio = Cardio.run;
						return;
					}

					if(runColour == selectedGreen)
					{
						runColour = null;
						cycleColour = null;
						chosenCardio = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: runColour == null ? unselectedGreen : selectedGreen,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.run_circle_outlined, size: 80, color: Colors.black),
				),
			),
		);
	}

	Widget cycle()
	{
		Color unselectedYellow = Theme.of(context).extension<AppColours>()!.cycleUnColour!;
		Color selectedYellow = Theme.of(context).extension<AppColours>()!.cycleSeColour!;
		
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(cycleColour == null)
					{
						cycleColour = selectedYellow;
						runColour = null;
						chosenCardio = Cardio.cycle;
						return;
					}

					if(cycleColour == selectedYellow)
					{
						cycleColour = null;
						runColour = null;
						chosenCardio = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: cycleColour == null ? unselectedYellow : selectedYellow,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Padding
					(
						padding: EdgeInsets.all(8.0),
						child: Icon(Icons.directions_bike_rounded, size: 60, color: Colors.black),
					),
				),
			),
		);
	}

	Widget nextButton()
	{
		return Padding
		(
			padding: const EdgeInsets.only(bottom: 100.0),
			child: SizedBox
			(
				height: 70,
				width: 120,
				child: Card
				(
					shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
					elevation: 2,
					child: ListenableBuilder
					(
						listenable: Listenable.merge([sportDuration, upperDuration, accessoriesDuration, lowerDuration, distance]), // Combines all the controllers together to say "Track all these guys's changes"
						builder: (context, child)
						{
							return ElevatedButton
							(
								style: ElevatedButton.styleFrom
								(
									backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
								),
								onPressed: areFieldsEmpty() ? null : ()
								{
									final double sportDurationNum = double.tryParse(sportDuration.text.trim()) ?? 0;
									final double upperDurationNum = double.tryParse(upperDuration.text.trim()) ?? 0;
									final double accDurationNum = double.tryParse(accessoriesDuration.text.trim()) ?? 0;
									final double lowerDurationNum = double.tryParse(lowerDuration.text.trim()) ?? 0;
									final double distanceNum = double.tryParse(distance.text.trim()) ?? 0;

									// Systemic Load Multipliers
									final double upperBurn = metCalculator(upperDurationNum, 1.2);
									final double accBurn = metCalculator(accDurationNum, 1.0);
									final double lowerBurn = metCalculator(lowerDurationNum, 1.4);
				
									final double weightLiftingBurn = (upperBurn + accBurn + lowerBurn) * 0.8;
									final double sportBurn = metCalculator(sportDurationNum, 1);

									final double activityBurn = extractCorrectActivity(weightLiftingBurn, sportBurn);

									final double cardioBurn = widget.personWeight * distanceNum * (chosenCardio?.caloricValue ?? 0);
				
									Navigator.push
									(
										context,
										MaterialPageRoute(builder: (context) => Utils.switchPage(context, EPOCPage(personWeight: widget.personWeight, bmr: widget.bmr, tdee: widget.tdee, activityBurn: activityBurn, cardioBurn: cardioBurn))) // Takes you to the page that shows all the locations connected to the restaurant
									);
								},
								child: const Text("Next", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
							);
						}
					)
				),
			),
		);
	}

	double extractCorrectActivity(double weight, double sport)
	{
		if((metFactor == MET.yoga.metValue) || (metFactor == MET.badminton.metValue) || (metFactor == MET.tennis.metValue))
		{
			return sport;
		}

		return weight;
	}

	double metCalculator(double durationNum, double burnMultiplier)
	{
		return ((((metFactor ?? 0) * 3.5 * widget.personWeight) / 200) * durationNum) * burnMultiplier;
	}

	bool areFieldsEmpty()
	{
		if((metFactor == null) && sportDuration.text.isNotEmpty)
		{
			return true;
		}
		if((metFactor == null) && ((upperDuration.text.isNotEmpty) || (accessoriesDuration.text.isNotEmpty) || (lowerDuration.text.isNotEmpty)))
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