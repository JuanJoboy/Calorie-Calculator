import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/pages/planner/folder_data.dart';
import 'package:calorie_calculator_app/pages/planner/week.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/formulas.dart';
import 'package:calorie_calculator_app/utilities/settings.dart';
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
	final bool isEditing;

	const CalculatorPage({super.key, required this.title, required this.isDedicatedBMRPage, required this.weeklyPlanner, required this.weeklyPlanId, required this.isEditing});
	const CalculatorPage.notAWeeklyPlanner({super.key, required this.title, required this.isDedicatedBMRPage, required this.weeklyPlanner, this.weeklyPlanId, this.isEditing = false});

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
	final TextEditingController _weight = TextEditingController();
	final TextEditingController _height = TextEditingController();
	final TextEditingController _feet = TextEditingController();
	final TextEditingController _age = TextEditingController();

	int _isTdeeSelected = 0;
	double _selectedTdee = Tdee.sedentary.tdeeValue;

	Gender? _chosenGender;
	Color? _maleColour;
	Color? _femaleColour;

	late CalculationFields _calcs;
	late UsersTdeeNotifier _tdeeNotifier;
	late WeeklyPlanNotifier _weeklyPlan;

	bool get _tdeeIsNull => _tdeeNotifier.usersTdee == null; // Checks to see if usersTdee is null or not

	double _sliderNumber = 0;

	bool _isSaving = false;

	@override
	void dispose()
	{
		// Must be disposed to avoid memory leaks
		super.dispose();
		_weight.dispose();
		_height.dispose();
		_feet.dispose();
		_age.dispose();
	}

	@override void initState()
	{
    	super.initState();

		_calcs = context.read<CalculationFields>(); // Since there's no context available here, I just read, rather than making and adding the widget to the tree

		_weeklyPlan = context.read<WeeklyPlanNotifier>();

		_tdeeNotifier = context.read<UsersTdeeNotifier>();

		// On the first go, it sets all the fields to blank, but then whenever the user goes to another page, and then back here, the page will rebuild with the previous values. This is so that the fields don't keep resetting
		_weight.text = _calcs.w;
		_height.text = _calcs.h;
		_feet.text = _calcs.f;
		_age.text = _calcs.a;
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
					if (widget.weeklyPlanId != null && !_isSaving && widget.isEditing == false)
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
					body: _mainBody()
				)
			);
		}
		else
		{
			return _mainBody();
		}
	}

	Widget _mainBody()
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
						Header(text: widget.title, fontSize: 30, fontWeight: FontWeight.bold),

						Padding
						(
							padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
							child: Text
							(
								"Be as honest as possible, otherwise your end-results may not accurately reflect valid values.",
								textAlign: TextAlign.center,
								style: TextStyle
								(
									fontSize: 16,
									color: Theme.of(context).hintColor,
									fontStyle: FontStyle.italic,
								),
							),
						),

						WidgetPlusHelper(mainWidget: const Header(text: "Measurements", fontSize: 25, fontWeight: FontWeight.w600, topPadding: 0), helpIcon: HelpIcon(msg: "Input your current body weight, height, and age into the text fields.",), left: 330),

						_textCard("Weight", context.watch<WeightNotifier>().currentUnit.symbol, _weight, fieldToSave: 1),
						_textCard("Height", context.watch<HeightNotifier>().currentUnit.symbol, _height, fieldToSave: 2),
						_textCard("Age", "years", _age, fieldToSave: 3),

						WidgetPlusHelper(mainWidget: const Header(text: "Physical Activity Level", fontSize: 25, fontWeight: FontWeight.w600), helpIcon: HelpIcon(msg: "Select a Physical Activity Level (PAL) based on your occupational movement and daily routine only. Do not include gym sessions or sports, as these are calculated on the next page. If an activity that you regularly do isn't listed on the next page, adjust this PAL upward to account for that additional energy demand.",), top: 30, left: 330),
						Column
						(
							children:
							[
								Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										_tdeeChip("Sedentary", Tdee.sedentary, 0),
										_tdeeChip("Moderately Active", Tdee.moderate, 1),
									]
								),
								Row
								(
									mainAxisAlignment: MainAxisAlignment.center,
									children:
									[
										_tdeeChip("Active", Tdee.active, 2),
										_tdeeChip("Vigorously Active", Tdee.vigorous, 3),
									]
								),
							],
						),

						WidgetPlusHelper(mainWidget: const Header(text: "Gender", fontSize: 25, fontWeight: FontWeight.w600), helpIcon: HelpIcon(msg: "Click on one of the 2 buttons below, that you most identify with.",), top: 30, left: 330),
						
						Row
						(
							mainAxisAlignment: MainAxisAlignment.center,
							children:
							[
								_male(),
								_female(),
							]
						),

						widget.weeklyPlanner == true ? _caloricSlider() : const SizedBox(),

						ListenableBuilder
						(
							listenable: Listenable.merge([_weight, _height, _age]),
							builder: (context, child)
							{
								return _weightAndCaloriesDoNotLineUp() ? const Padding
								(
									padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 20),
									child: Text
									(
										"The selected calorie goal is too low to meet essential protein and fat requirements for your body weight.",
										style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
									),
								) : const SizedBox();
							}
						),

						_buttonsThatProcessInfo(),

						widget.weeklyPlanner == true ? const Padding(padding: EdgeInsetsGeometry.only(top: 100)) : const Padding(padding: EdgeInsetsGeometry.only(top: 40))
					],
				),
			),
		);
	}

	Widget _textCard(String header, String unit, TextEditingController controller, {required int fieldToSave})
	{
		final bool isFoot = context.read<HeightNotifier>().currentUnit == Height.inch;
		final bool trueIsFoot = isFoot && fieldToSave == 2;

		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: trueIsFoot ? 155 : 105,
				width: 300,
				child: Card
				(
					color: colour.tertiaryColour!,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: colour.secondaryColour!,
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
				
							trueIsFoot ? Column
							(
								mainAxisAlignment: MainAxisAlignment.center,
								children:
								[
									Row
									(
										mainAxisAlignment: MainAxisAlignment.center,
										children:
										[
											_textBox(_feet, fieldToSave: 4),
											_unitName("ft")
										],
									),

									const Padding(padding: EdgeInsetsGeometry.only(top: 10)),

									Row
									(
										mainAxisAlignment: MainAxisAlignment.center,
										children:
										[
											_textBox(controller, fieldToSave: fieldToSave),
											_unitName(unit)
										],
									)
								],
							)
							: Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								children:
								[
									_textBox(controller, fieldToSave: fieldToSave),
									_unitName(unit),
								],
							)
						],
					),
				),
			),
		);
	}

	Widget _textBox(TextEditingController controller, {required int fieldToSave})
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(left: 60.5),
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
							color: colour.secondaryColour!,
							width: 2
						),
						borderRadius: BorderRadiusGeometry.circular(100)
					),
					color: colour.secondaryColour!,
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
						),
						controller: controller,
						onChanged: (value)
						{
							switch(fieldToSave)
							{
								case 1: _calcs.updateControllers(weight: value);
								case 2: _calcs.updateControllers(height: value);
								case 3: _calcs.updateControllers(age: value);
								case 4: _calcs.updateControllers(feet: value);
							}
						},
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
						keyboardType: const TextInputType.numberWithOptions(decimal: true),
					),
				),
			),
		);
	}

	Widget _unitName(String unit)
	{
		return Padding
		(
			padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
			child: SizedBox
			(
				width: 50,
				child: Text
				(
					unit,
					style: const TextStyle
					(
						fontSize: 17,
						fontWeight: FontWeight.bold
					),
				),
			),
		);
	}

	Widget _tdeeChip(String label, Tdee tdee, int index)
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
			child: ChoiceChip
			(
				label: Text(label),
				selected: _isTdeeSelected == index,
				onSelected: (value)
				{
					setState(()
					{
						_selectedTdee = tdee.tdeeValue;
						_isTdeeSelected = index;
					});
				},
				selectedColor: colour.secondaryColour!,
				backgroundColor: colour.tertiaryColour!,
			),
		);
	}

	Widget _male()
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		Color unselectedBlue = colour.maleUnColour!;
		Color selectedBlue = colour.maleSeColour!;

		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(_maleColour == null)
					{
						_maleColour = selectedBlue;
						_femaleColour = null;
						_chosenGender = Gender.male;
						return;
					}

					if(_maleColour == selectedBlue)
					{
						_maleColour = null;
						_femaleColour = null;
						_chosenGender = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: _maleColour == null ? unselectedBlue : selectedBlue,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.male_rounded, size: 70),
				),
			),
		);
	}

	Widget _female()
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		Color unselectedPink = colour.femaleUnColour!;
		Color selectedPink = colour.femaleSeColour!;
		
		return GestureDetector
		(
			onTap: ()
			{
				setState(()
				{
					if(_femaleColour == null)
					{
						_femaleColour = selectedPink;
						_maleColour = null;
						_chosenGender = Gender.female;
						return;
					}

					if(_femaleColour == selectedPink)
					{
						_femaleColour = null;
						_maleColour = null;
						_chosenGender = null;
						return;
					}
				});
			},
			child: Padding
			(
				padding: const EdgeInsets.all(30.0),
				child: Card
				(
					color: _femaleColour == null ? unselectedPink : selectedPink,
					shape: RoundedRectangleBorder
					(
						borderRadius: BorderRadiusGeometry.circular(25)
					),
					child: const Icon(Icons.female_rounded, size: 70),
				),
			),
		);
	}

	Widget _caloricSlider()
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Column
		(
			children:
			[
				WidgetPlusHelper(mainWidget: const Header(text: "Calorie Slider", fontSize: 25, fontWeight: FontWeight.w600), helpIcon: HelpIcon(msg: "Use the slider below to indicate if your cutting (sliding to the left) or bulking (sliding to the right). The number chosen will reflect the amount of calories that need to be uneaten / consumed everyday over the course of a week. If you just want to maintain your current weight instead, leave it on 0.",), top: 30, left: 330),

				Padding
				(
					padding: const EdgeInsets.all(30.0),
					child: Slider
					(
						value: _sliderNumber,
						min: -1000,
						max: 1000,
						divisions: 20,
						onChanged: (newValue)
						{
							setState(()
							{
								_sliderNumber = newValue;  
							});
						},
						label: _sliderNumber.toString(),
						thumbColor: colour.secondaryColour!,
						activeColor: colour.femaleSeColour!,
						inactiveColor: colour.maleSeColour!,
					),
				)
			],
		);
	}

	Widget _buttonsThatProcessInfo()
	{
		if(widget.weeklyPlanner)
		{
			return _rowOfButtons();
		}
		else
		{
			if(widget.isDedicatedBMRPage)
			{
				return _nextButton("Upload TDEE", _areFieldsEmpty);
			}
			else
			{
				return _rowOfButtons();
			}
		}
	}

	Widget _rowOfButtons()
	{
		return Row
		(
			mainAxisAlignment: MainAxisAlignment.center,
			children:
			[
				const Padding(padding: EdgeInsetsGeometry.only(top: 100)),
				_nextButton("Next", _areFieldsEmpty, isNextButton: true),

				const Padding(padding: EdgeInsetsGeometry.only(left: 15, right: 15)),

				_nextButton("Stick with ${(_tdeeNotifier.usersTdee?.tdee)?.round() ?? 0.round()} TDEE", _tdeeDoesNotExist, isNextButton: false, moreWidth: 170),
			]
		);
	}

	Widget _nextButton(String nextText, bool Function() condition, {bool? isNextButton, double? moreWidth})
	{
		final colour = Theme.of(context).extension<AppColours>()!;

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
					listenable: Listenable.merge([_weight, _height, _age]), // Combines all the controllers together to say "Track all these guys's changes"
					builder: (context, child)
					{
						return ElevatedButton
						(
							style: ElevatedButton.styleFrom
							(
								backgroundColor: colour.secondaryColour!
							),
							onPressed: condition() ? null : _weightAndCaloriesDoNotLineUp() ? null : () async // Async so that the nav.push can be awaited, so that as soon as the user comes back to this page after coming from the results page, the page is rebuilt via setState and the bmr checker runs, allowing the button to be usable. Instead of forcing the user to go to another page, then back here so that the page rebuilds
							{
								_processInfo(isNextButton: isNextButton);
							},
							child: Text(nextText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			),
		);
	}
	
	({double bmr, double ageNum, double tdee, double weightNum}) _calculateBodyInfo()
	{
		final double weightInput = double.tryParse(_weight.text.trim()) ?? 0;
		final double heightInput = double.tryParse(_height.text.trim()) ?? 0;
		final double feetInput = double.tryParse(_feet.text.trim()) ?? 0;
		final double ageNum = double.tryParse(_age.text.trim()) ?? 0;

		final double weightNum = context.read<WeightNotifier>().currentUnit.toBase(weightInput);

		final double trueHeight;

		if(!context.read<HeightNotifier>().isBaseMode)
		{
			trueHeight = heightInput;
		}
		else
		{
			final double heightNum = context.read<HeightNotifier>().currentUnit.toBase(heightInput);
			final double feetNum = context.read<HeightNotifier>().currentUnit.toBase(feetInput * 12);

			trueHeight = heightNum + feetNum;
		}

		final double bmr = (10 * weightNum) + (6.25 * trueHeight) - (5 * ageNum) + _chosenGender!.caloricValue;
		final double tdee = bmr * _selectedTdee;

		return (bmr: bmr, ageNum: ageNum, tdee: tdee, weightNum: weightNum);
	}

	void _processInfo({bool? isNextButton}) async
	{
		if(widget.weeklyPlanner)
		{
			if(isNextButton! == true)
			{
				final (:bmr, :ageNum, :tdee, :weightNum) = _calculateBodyInfo();

				int trueWeeklyPlanId = widget.weeklyPlanId ?? await _weeklyPlan.newPeanutShellPlan(weightNum, ageNum, _chosenGender == Gender.male, _sliderNumber, bmr, tdee);

				if(trueWeeklyPlanId == -1) return;

				if(widget.weeklyPlanId != null)
				{
					await _weeklyPlan.updatePeanutShellPlan(widget.weeklyPlanId!, weightNum, ageNum, _chosenGender == Gender.male, _sliderNumber, bmr, tdee);
				}

				if(mounted)
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: WeekPage(bmr: bmr, age: ageNum, male: _chosenGender == Gender.male, tdee: tdee, personWeight: weightNum, additionalCalories: _sliderNumber, weeklyPlanId: trueWeeklyPlanId, isEditing: widget.isEditing)))
					);
				}
			}
			else
			{
				UsersTdee user = _tdeeNotifier.usersTdee!;

				int trueWeeklyPlanId = widget.weeklyPlanId ?? await _weeklyPlan.newPeanutShellPlan(user.weight, user.age, user.male, _sliderNumber, user.bmr, user.tdee);
				
				if(trueWeeklyPlanId == -1) return;

				if(widget.weeklyPlanId != null)
				{
					await _weeklyPlan.updatePeanutShellPlan(widget.weeklyPlanId!, user.weight, user.age, user.male, _sliderNumber, user.bmr, user.tdee);
				}

				if(mounted)
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: WeekPage(bmr: _tdeeNotifier.usersTdee!.bmr, age: _tdeeNotifier.usersTdee!.age, male: _tdeeNotifier.usersTdee!.male, tdee: _tdeeNotifier.usersTdee!.tdee, personWeight: _tdeeNotifier.usersTdee!.weight, additionalCalories: _sliderNumber, weeklyPlanId: trueWeeklyPlanId, isEditing: widget.isEditing)))
					);
				}
			}
		}
		else
		{
			if(widget.isDedicatedBMRPage)
			{
				await _tdeeNotifier.uploadOrEditTdee(_calculateBodyInfo().bmr, _calculateBodyInfo().tdee, _calculateBodyInfo().weightNum, _calculateBodyInfo().ageNum, _chosenGender == Gender.male); // Forces a rebuild of the page which ensures that the bmrExists variable is refreshed and sees the new value instead of being on the stale old value

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
						MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: BurnPage.nonWeekly(bmr: _calculateBodyInfo().bmr, age: _calculateBodyInfo().ageNum, male: _chosenGender == Gender.male, tdee: _calculateBodyInfo().tdee, personWeight: _calculateBodyInfo().weightNum, weeklyPlanner: widget.weeklyPlanner)))
					);
				}
				else
				{
					await Navigator.push
					(
						context,
						MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: BurnPage.nonWeekly(bmr: _tdeeNotifier.usersTdee!.bmr, age: _tdeeNotifier.usersTdee!.age, male: _tdeeNotifier.usersTdee!.male, tdee: _tdeeNotifier.usersTdee!.tdee, personWeight: _tdeeNotifier.usersTdee!.weight, weeklyPlanner: widget.weeklyPlanner)))
					);
				}
			}
		}
	}

	bool _weightAndCaloriesDoNotLineUp()
	{
		if (_areFieldsEmpty()) return false;
		if (widget.weeklyPlanner == false) return false;

		final (:bmr, :ageNum, :tdee, :weightNum) = _calculateBodyInfo();
		
		// The actual calories the user will be eating
		final double effectiveTdee = tdee + _sliderNumber;
		final bool isMale = _chosenGender == Gender.male;

		// Use Max settings so that if the user chooses them or does something lower, all the bases are covered
		const double proteinIntensity = 2.2; 
		const double fatIntensity = 0.30;

		final int protein = NutritionMath.protein(weightNum, proteinIntensity);
		final fats = NutritionMath.fat(effectiveTdee, fatIntensity, isMale);

		final int solubleFibreKcal = isMale ? 24 : 20; // Cause soluble fibre s 2kcal per gram and its either 12 or 10 grams depending on the user's gender
		
		// 1. Checks if the TDEE can afford basic macros
		final int basicRequirement = (protein * 4) + (fats.totalFat * 9) + solubleFibreKcal;
		if (basicRequirement > effectiveTdee) return true;

		// 2. Checks if the fat budget can contain essential Omegas / Sat Fat
		final double fatComponents = fats.saturatedFat + fats.omega3 + fats.omega6;
		if ((fatComponents > fats.totalFat) || (fats.omega3 + fats.omega6 > fats.unsaturatedFat)) return true;

		return false;
	}

	bool _areFieldsEmpty()
	{
		return (_weight.text.trim().isEmpty) || (_height.text.trim().isEmpty) || (_age.text.trim().isEmpty) || (_chosenGender == null); // Ensures that all the fields are filled
	}

	bool _tdeeDoesNotExist()
	{
		if(_tdeeIsNull == true)
		{
			return true;
		}

		return false;
	}
}