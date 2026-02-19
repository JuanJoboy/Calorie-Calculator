import 'package:calorie_calculator/pages/nutrition/diet.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/formulas.dart';
import 'package:calorie_calculator/utilities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
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
	final TextEditingController _weight = TextEditingController();
	final TextEditingController _tdee = TextEditingController();

	int _isProteinSelected = 0;
	double _selectedProteinIntensity = ProteinIntensity.maintenance.value;

	int _isFatSelected = 1;
	double _selectedFatIntensity = FatIntensity.mid.value;

	Gender? _chosenGender;
	Color? _maleColour;
	Color? _femaleColour;

	late NutritionFields _nutris;

	@override
	void dispose()
	{
		super.dispose();
		_weight.dispose();
		_tdee.dispose();
	}

	@override void initState()
	{
    	super.initState();

		_nutris = context.read<NutritionFields>();

		_weight.text = _nutris.we;
		_tdee.text = _nutris.td;
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
						const Header(text: "Macro Calculator", fontSize: 30, fontWeight: FontWeight.bold),

						WidgetPlusHelper(mainWidget: const Header(text: "Today's Biometrics", fontSize: 25, fontWeight: FontWeight.w600), helpIcon: HelpIcon(msg: "Input your current body weight and total caloric intake for today.",), top: 30, left: 330),

						_textBox("Weight", context.watch<WeightNotifier>().currentUnit.symbol, _weight, fieldToSave: 1, padding: 30),
						_textBox("Total Calories Today", "kcal", _tdee, fieldToSave: 2, padding: 45),

						_chips("Protein Intensity", "Select the amount of protein that you want in your diet. 'Aggressive Cut / Fat Loss' helps preserve lean mass during a deficit and increases satiety, while 'Maintenance' provides the baseline RDA for health.", ProteinIntensity.values, true),

						_chips("Fat Intake", "Select the amount of fat that you want in your diet. High Fat supports hormonal health and fat-soluble vitamin absorption (A, D, E, K), while Low Fat allows for higher carbohydrate volume to fuel high-intensity training.", FatIntensity.values, false),

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

						ListenableBuilder
						(
							listenable: Listenable.merge([_weight, _tdee]),
							builder: (context, child)
							{
								return _weightAndCaloriesDoNotLineUp() ? const Padding
								(
									padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 20),
									child: Text
									(
										"Your current configuration exceeds your Total Calories. Please adjust your inputs.",
										style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
									),
								) : const SizedBox();
							}
						),

						_processInfo(),

						const Padding(padding: EdgeInsetsGeometry.only(top: 20)),
					],
				),
			),
		);
	}

	Widget _chips(String header, String helpMsg, List<Intensity> intensity, bool isProtein)
	{
		return Column
		(
			children:
			[
				WidgetPlusHelper(mainWidget: Header(text: header, fontSize: 25, fontWeight: FontWeight.w600), helpIcon: HelpIcon(msg: helpMsg), top: 30, left: 330),
				
				for(int i = 0; i < intensity.length; i++)
					_intensityChip(intensity[i], i, isProtein)
			],
		);
	}
	
	Widget _textBox(String header, String unit, TextEditingController controller, {int? fieldToSave, double? padding})
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 105,
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
															case 1: _nutris.updateControllers(weight: value);
															case 2: _nutris.updateControllers(tdee: value);
														}
													},
													inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),],
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

	Widget _intensityChip(Intensity intensity, int index, bool isProtein)
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
			child: ChoiceChip
			(
				label: Text(intensity.label),
				selected: isProtein == true ? _isProteinSelected == index : _isFatSelected == index,
				onSelected: (value)
				{
					setState(()
					{
						if(isProtein)
						{
							_selectedProteinIntensity = intensity.value;
							_isProteinSelected = index;
						}
						else
						{
							_selectedFatIntensity = intensity.value;
							_isFatSelected = index;
						}
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

	Widget _processInfo()
	{
		final colour = Theme.of(context).extension<AppColours>()!;

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
					listenable: Listenable.merge([_weight, _tdee]),
					builder: (context, child)
					{
						return ElevatedButton
						(
							style: ElevatedButton.styleFrom
							(
								backgroundColor: colour.secondaryColour!
							),
							onPressed: _areFieldsEmpty() ? null : _weightAndCaloriesDoNotLineUp() ? null : () async
							{
								try
								{
									await Navigator.push
									(
										context,
										MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: DietPage.noActivity(weight: _parseTextFields().$1, tdee: _parseTextFields().$2, proteinIntensity: _selectedProteinIntensity, fatIntake: _selectedFatIntensity, fibre: _chosenGender!.value, caloricCeiling: _parseTextFields().$2,)))
									);
								}
								catch(e)
								{
									if(context.mounted)
									{
										ErrorHandler.showSnackBar(context, "An error occurred in processing your info");
										debugPrint("Debug Print: ${e.toString()}");
									}
								}
							},
							child: const Text("Calculate Macros", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
						);
					}
				)
			),
		);
	}
	
	(double, int) _parseTextFields()
	{
		final double weightNum = double.tryParse(_weight.text.trim().replaceAll(',', '.')) ?? 0;
		final int tdeeNum = int.tryParse(_tdee.text.trim().replaceAll(',', '.')) ?? 0;

		final double trueWeight = context.read<WeightNotifier>().currentUnit.toBase(weightNum);

		return (trueWeight, tdeeNum);
	}

	bool _weightAndCaloriesDoNotLineUp()
	{
		if(_areFieldsEmpty())
		{
			return false;
		}

		final bool isMale = _chosenGender?.label == "Male";

		final (double weight, int tdee) = _parseTextFields();

		final int protein = NutritionMath.protein(weight, _selectedProteinIntensity);
		final (:totalFat, :saturatedFat, :unsaturatedFat, :omega3, :omega6, :cholesterol) = NutritionMath.fat(tdee.toDouble(), _selectedFatIntensity, isMale);

		final int solubleFibre = isMale ? 12 : 10; // Soluble: ~2 kcal/g
		final int insolubleFibre = isMale ? 18 : 15; // Insoluble: ~0 kcal/g

		final int basicMacros = (protein * 4) + (totalFat * 9);
		final double fibre = (solubleFibre * 2) + (insolubleFibre * 0);
		final double fatComponents = saturatedFat + omega3 + omega6;

		return (basicMacros + fibre > tdee) || (fatComponents > totalFat);
	}

	bool _areFieldsEmpty()
	{
		return (_weight.text.trim().isEmpty) || (_tdee.text.trim().isEmpty) || (_chosenGender == null);
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