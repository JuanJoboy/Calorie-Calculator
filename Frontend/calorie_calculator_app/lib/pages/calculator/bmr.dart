import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/pages/planner/week.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/pages/calculator/burn.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatefulWidget
{
	final String title;
	final bool isDedicatedBMRPage;
	final bool weeklyPlanner;
	final int? weeklyPlanId;

	const CalculatorPage({super.key, required this.title, required this.isDedicatedBMRPage, required this.weeklyPlanner, required this.weeklyPlanId});
	const CalculatorPage.notAWeeklyPlanner({super.key, required this.title, required this.isDedicatedBMRPage, required this.weeklyPlanner, this.weeklyPlanId});

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

	late CalculationFields _calcs;
	late UsersTdeeNotifier _tdeeNotifier;
	late WeeklyPlanNotifier _weeklyPlan;

	bool get tdeeIsNull => _tdeeNotifier.usersTdee == null; // Checks to see if usersTdee is null or not

	double sliderNumber = 0;

	bool _isSaving = false;

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

		final WeeklyPlanNotifier weeklyPlan = context.read<WeeklyPlanNotifier>();
		_weeklyPlan = weeklyPlan;

		final UsersTdeeNotifier tdeeNotifier = context.read<UsersTdeeNotifier>();
		_tdeeNotifier = tdeeNotifier;

		// On the first go, it sets all the fields to blank, but then whenever the user goes to another page, and then back here, the page will rebuild with the previous values. This is so that the fields don't keep resetting
		weight.text = _calcs.w;
		height.text = _calcs.h;
		age.text = _calcs.a;
  	}

	@override
	Widget build(BuildContext context)
	{
		if(widget.weeklyPlanner)
		{
			return PopScope
			(
				canPop: false, // Prevent immediate pop
				onPopInvokedWithResult: (didPop, result) async
				{
					if (didPop) return;

					// Delete the plan from DB since they are cancelling
					if (widget.weeklyPlanId != null && !_isSaving)
					{
						final WeeklyPlanNotifier plan = context.read<WeeklyPlanNotifier>();
						await plan.deleteWeeklyPlan(widget.weeklyPlanId!);
					}

					if (context.mounted)
					{
						Navigator.pop(context);
					}
				},
				child: Scaffold
				(
					backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
					appBar: AppBar(title: const Text("")),
					body: mainBody()
				)
			);
		}
		else
		{
			return mainBody();
		}
	}

	Widget mainBody()
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

						widget.weeklyPlanner == true ? caloricSlider() : const SizedBox(),

						buttonsThatProcessInfo(),

						widget.weeklyPlanner == true ? const Padding(padding: EdgeInsetsGeometry.only(top: 100)) : const Padding(padding: EdgeInsetsGeometry.only(top: 40))
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

	Widget caloricSlider()
	{
		return Column
		(
			children:
			[
				Utils.widgetPlusHelper(Utils.header("Calorie Slider", 25, FontWeight.w600), HelpIcon(msg: "Use the slider below to indicate if your cutting (sliding to the left) or bulking (sliding to the right). The number chosen will reflect the amount of calories that need to be uneaten / consumed everyday over the course of a week. If you just want to maintain your current weight instead, leave it on 0.",), top: 45, right: 17.5),

				Padding
				(
					padding: const EdgeInsets.all(30.0),
					child: Slider
					(
						value: sliderNumber,
						min: -1000,
						max: 1000,
						divisions: 20,
						onChanged: (newValue)
						{
							setState(()
							{
								sliderNumber = newValue;  
							});
						},
						label: sliderNumber.toString(),
						thumbColor: Theme.of(context).extension<AppColours>()!.secondaryColour!,
						activeColor: Theme.of(context).extension<AppColours>()!.femaleSeColour!,
						inactiveColor: Theme.of(context).extension<AppColours>()!.maleSeColour!,
					),
				)
			],
		);
	}

	Widget buttonsThatProcessInfo()
	{
		if(widget.weeklyPlanner)
		{
			return rowOfButtons();
		}
		else
		{
			if(widget.isDedicatedBMRPage)
			{
				return nextButton("Upload TDEE", areFieldsEmpty);
			}
			else
			{
				return rowOfButtons();
			}
		}
	}

	Widget rowOfButtons()
	{
		return Row
		(
			mainAxisAlignment: MainAxisAlignment.center,
			children:
			[
				const Padding(padding: EdgeInsetsGeometry.only(top: 100)),
				nextButton("Next", areFieldsEmpty, isNextButton: true),

				const Padding(padding: EdgeInsetsGeometry.only(left: 15, right: 15)),

				nextButton("Stick with ${(_tdeeNotifier.usersTdee?.tdee)?.round() ?? 0.round()} TDEE", tdeeDoesNotExist, isNextButton: false, moreWidth: 170),
			]
		);
	}

	Widget nextButton(String nextText, bool Function() condition, {bool? isNextButton, double? moreWidth})
	{
		return SizedBox
		(
			height: 70,
			width: moreWidth ?? 120,
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
							onPressed: condition() ? null : () async // Async so that the nav.push can be awaited, so that as soon as the user comes back to this page after coming from the results page, the page is rebuilt via setState and the bmr checker runs, allowing the button to be usable. Instead of forcing the user to go to another page, then back here so that the page rebuilds
							{
								processInfo(isNextButton: isNextButton);
							},
							child: Text(nextText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			),
		);
	}
	
	({double bmr, double ageNum, double tdee, double weightNum}) calculateBodyInfo()
	{
		final double weightNum = double.tryParse(weight.text.trim()) ?? 0;
		final double heightNum = double.tryParse(height.text.trim()) ?? 0;
		final double ageNum = double.tryParse(age.text.trim()) ?? 0;

		final double bmr = (10 * weightNum) + (6.25 * heightNum) - (5 * ageNum) + chosenGender!.caloricValue;
		final double tdee = bmr * selectedTdee;

		return (bmr: bmr, ageNum: ageNum, tdee: tdee, weightNum: weightNum);
	}

	void processInfo({bool? isNextButton}) async
	{
		if(widget.weeklyPlanner)
		{
			if(isNextButton! == true)
			{
				final (:bmr, :ageNum, :tdee, :weightNum) = calculateBodyInfo();

				int trueWeeklyPlanId = widget.weeklyPlanId ?? await _weeklyPlan.newPeanutShellPlan(weightNum, ageNum, chosenGender == Gender.male, sliderNumber, bmr, tdee);

				if(trueWeeklyPlanId == -1) return;

				if(widget.weeklyPlanId != null)
				{
					await _weeklyPlan.updatePeanutShellPlan(widget.weeklyPlanId!, weightNum, ageNum, chosenGender == Gender.male, sliderNumber, bmr, tdee);
				}

				if(mounted)
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, WeekPage(bmr: bmr, age: ageNum, male: chosenGender == Gender.male, tdee: tdee, personWeight: weightNum, additionalCalories: sliderNumber, weeklyPlanId: trueWeeklyPlanId)))
					);
				}
			}
			else
			{
				UsersTdee user = _tdeeNotifier.usersTdee!;

				int trueWeeklyPlanId = widget.weeklyPlanId ?? await _weeklyPlan.newPeanutShellPlan(user.weight, user.age, user.male, sliderNumber, user.bmr, user.tdee);
				
				if(trueWeeklyPlanId == -1) return;

				if(widget.weeklyPlanId != null)
				{
					await _weeklyPlan.updatePeanutShellPlan(widget.weeklyPlanId!, user.weight, user.age, user.male, sliderNumber, user.bmr, user.tdee);
				}

				if(mounted)
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, WeekPage(bmr: _tdeeNotifier.usersTdee!.bmr, age: _tdeeNotifier.usersTdee!.age, male: _tdeeNotifier.usersTdee!.male, tdee: _tdeeNotifier.usersTdee!.tdee, personWeight: _tdeeNotifier.usersTdee!.weight, additionalCalories: sliderNumber, weeklyPlanId: trueWeeklyPlanId)))
					);
				}
			}
		}
		else
		{
			if(widget.isDedicatedBMRPage)
			{
				await _tdeeNotifier.uploadOrEditTdee(calculateBodyInfo().bmr, calculateBodyInfo().tdee, calculateBodyInfo().weightNum, calculateBodyInfo().ageNum, chosenGender == Gender.male); // Forces a rebuild of the page which ensures that the bmrExists variable is refreshed and sees the new value instead of being on the stale old value

				if(mounted)
				{
					context.read<NavigationNotifier>().changeIndex(3);
				}
			}
			else
			{
				if(isNextButton! == true)
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage.nonWeekly(bmr: calculateBodyInfo().bmr, age: calculateBodyInfo().ageNum, male: chosenGender == Gender.male, tdee: calculateBodyInfo().tdee, personWeight: calculateBodyInfo().weightNum, weeklyPlanner: widget.weeklyPlanner)))
					);
				}
				else
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => Utils.switchPage(context, BurnPage.nonWeekly(bmr: _tdeeNotifier.usersTdee!.bmr, age: _tdeeNotifier.usersTdee!.age, male: _tdeeNotifier.usersTdee!.male, tdee: _tdeeNotifier.usersTdee!.tdee, personWeight: _tdeeNotifier.usersTdee!.weight, weeklyPlanner: widget.weeklyPlanner)))
					);
				}
			}
		}
	}

	bool areFieldsEmpty()
	{
		return (weight.text.trim().isEmpty) || (height.text.trim().isEmpty) || (age.text.trim().isEmpty) || (chosenGender == null); // Ensures that all the fields are filled
	}

	bool tdeeDoesNotExist()
	{
		if(tdeeIsNull == true)
		{
			return true;
		}

		return false;
	}
}