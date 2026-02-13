import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/pages/calculator/epoc.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BurnPage extends StatefulWidget
{
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	final bool weeklyPlanner;
	final int? weeklyPlanId;
	final int dayId;
	
	const BurnPage({super.key, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories, required this.weeklyPlanner, required this.weeklyPlanId, required this.dayId});

	const BurnPage.nonWeekly({super.key, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, this.additionalCalories = 0, required this.weeklyPlanner, this.weeklyPlanId, this.dayId = 0});

	@override
	State<BurnPage> createState() => _BurnPageState();
}

abstract interface class Nutrition
{
	double get value;
	String get label;
}

enum ProteinIntensity implements Nutrition
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

enum FatIntensity implements Nutrition
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

abstract interface class Intensity
{
	double get value;
	String get label;
}

enum EasyMET implements Intensity
{
	yoga(value: 2.5001, label: 'Yoga'),
	croquet(value: 2.5002, label: 'Croquet'),
	fishing(value: 2.5003, label: 'Fishing'),
	golf(value: 2.5004, label: 'Golf'),
	canoe(value: 2.5005, label: 'Canoeing leisurely'),
	ballroom(value: 2.9001, label: 'Slow Ballroom Dancing'),
	weightLifting(value: 3.0000, label: 'Light Weights: < 60% 1RM'),
	bowling(value: 3.0001, label: 'Bowling'),
	archery(value: 3.5002, label: 'Archery');

	// Fields defined directly on the enum
	@override
	final double value;
	@override
	final String label;

	// Internal constructor
	const EasyMET({required this.value, required this.label});
}

enum MidMET implements Intensity
{
	weightLifting(value: 4.0000, label: 'Mild Weights: 60-80% 1RM'),
	horseback(value: 4.0001, label: 'Horseback Riding'),
	tableTennis(value: 4.0002, label: 'Table Tennis'),
	taiChi(value: 4.0003, label: 'Tai Chi'),
	volleyBall(value: 4.0004, label: 'Non-Competitive Volleyball'),
	badminton(value: 4.5001, label: 'Badminton'),
	tennisDoubles(value: 5.0001, label: 'Tennis, Doubles'),
	lowAerobic(value: 5.0002, label: 'Low Impact Aerobic Dance'),
	baseball(value: 5.0003, label: 'Baseball'),
	softball(value: 5.0004, label: 'Softball'),
	kayak(value: 5.0005, label: 'Kayaking'),
	skateboarding(value: 5.0006, label: 'Skateboarding'),
	snorkel(value: 5.0007, label: 'Snorkeling'),
	iceSkating(value: 5.5001, label: 'Slow Ice Skating'),
	wrestling(value: 6.0001, label: 'Wrestling'),
	ballet(value: 6.0002, label: 'Ballet'),
	fencing(value: 6.0003, label: 'Fencing'),
	surfing(value: 6.0004, label: 'Surfing'),
	waterSki(value: 6.0005, label: 'Water Skiing'),
	snowSki(value: 6.0006, label: 'Snow Skiing');

	// Fields defined directly on the enum
	@override
	final double value;
	@override
	final String label;

	// Internal constructor
	const MidMET({required this.value, required this.label});
}

enum HardMET implements Intensity
{
	weightLifting(value: 5.0000, label: 'Heavy Weights: > 80% 1RM'),
	highAerobic(value: 7.0001, label: 'High Impact Aerobic Dance'),
	iceSkating(value: 7.0002, label: 'Fast Ice Skating'),
	casualSoccer(value: 7.0003, label: 'Casual Soccer'),
	tennis(value: 7.0004, label: 'Tennis, Singles'),
	basketball(value: 8.0001, label: 'Basketball'),
	football(value: 8.0002, label: 'Football'),
	frisbee(value: 8.0003, label: 'Ultimate Frisbee'),
	iceHockey(value: 8.0004, label: 'Ice Hockey'),
	fieldHockey(value: 8.0005, label: 'Field Hockey'),
	lacrosse(value: 8.0006, label: 'Lacrosse'),
	racquetballTeam(value: 8.0007, label: 'Racquetball Team'),
	slowRope(value: 8.0008, label: 'Slow Rope Skipping'),
	mountainClimbing(value: 8.0009, label: 'Mountain Climbing'),
	volleyBall(value: 8.00011, label: 'Competitive Volleyball'),
	waterPolo(value: 10.0001, label: 'Water Polo'),
	racquetball(value: 10.0002, label: 'Racquetball'),
	mma(value: 10.0003, label: 'Martial Arts Sparring'),
	compSoccer(value: 10.0004, label: 'Competitive Soccer'),
	fastRope(value: 12.0001, label: 'Fast Rope Skipping');

	// Fields defined directly on the enum
	@override
	final double value;
	@override
	final String label;

	// Internal constructor
	const HardMET({required this.value, required this.label});
}

enum Cardio
{
	run(value: 1, label: 'Running'),
	cycle(value: 0.3, label: 'Cycling');

	final double value;
	final String label;

	const Cardio({required this.value, required this.label});
}

class _BurnPageState extends State<BurnPage>
{
	double? metFactor;
	String? activityName;

	late ScrollController offSetController;

	final TextEditingController sportDuration = TextEditingController();

	final TextEditingController upperDuration = TextEditingController();
	final TextEditingController accessoriesDuration = TextEditingController();
	final TextEditingController lowerDuration = TextEditingController();

	final TextEditingController distance = TextEditingController();
	Cardio? chosenCardio;
	Color? runColour;
	Color? cycleColour;

	int isProteinSelected = 0;
	double selectedProteinIntensity = ProteinIntensity.maintenance.value;

	int isFatSelected = 1;
	double selectedFatIntensity = FatIntensity.mid.value;

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

		offSetController = ScrollController(initialScrollOffset: 10000); // Need to initialize this offSet here otherwise it takes 10 years to initialize if i do it in listOfOptions()

		final CalculationFields list = context.read<CalculationFields>();
		_calcs = list;

		sportDuration.text = _calcs.s;
		upperDuration.text = _calcs.up;
		accessoriesDuration.text = _calcs.ac;
		lowerDuration.text = _calcs.lo;
		distance.text = _calcs.d;
		metFactor = _calcs.met;
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
							nutrition(),
							nextButton(),
						],
					),
				)
			)
		);
	}

	Widget met()
	{
		Color aeOutline = Theme.of(context).extension<AppColours>()!.aerobicOutlineColour!;
		Color aeBackground = Theme.of(context).extension<AppColours>()!.aerobicBackgroundColour!;
		Color anOutline = Theme.of(context).extension<AppColours>()!.anaerobicOutlineColour!;
		Color anBackground = Theme.of(context).extension<AppColours>()!.anaerobicBackgroundColour!;
		Color maOutline = Theme.of(context).extension<AppColours>()!.maximalOutlineColour!;
		Color maBackground = Theme.of(context).extension<AppColours>()!.maximalBackgroundColour!;

		return Column
		(
			children:
			[
				Utils.widgetPlusHelper(Utils.header("Activity Selection", 30, FontWeight.bold), HelpIcon(msg: "Select the activity that you did, to apply its MET value. This constant determines how intense your exercise was and how many calories you burned.\n\nNote: No values are needed to proceed, however if you do enter data into any field, you must select a corresponding activity to ensure the correct intensity factor is applied to your results.",), top: 50, right: 17.5),

				Text("Select only 1 activity", style: TextStyle(color: Theme.of(context).hintColor)),
			
				Column
				(
					children:
					[
						Utils.header("Light Activities", 25, FontWeight.w600),
						listOfOptions(EasyMET.values, aeOutline, aeBackground),

						Utils.header("Moderate Activities", 25, FontWeight.w600),
						listOfOptions(MidMET.values, anOutline, anBackground),

						Utils.header("Vigorous Activities", 25, FontWeight.w600),
						listOfOptions(HardMET.values, maOutline, maBackground),
					],
				)
			],
		);
	}

	Widget listOfOptions(List<Intensity> metList, Color outlineColour, Color backgroundColour)
	{
		return SizedBox
		(
			height: 100,
			width: double.infinity,

			child: ListView.builder
			(
				controller: offSetController,
				physics: const BouncingScrollPhysics(),
				scrollDirection: Axis.horizontal,
				itemCount: null, // null sets it to infinity basically
				itemBuilder: (context, index)
				{
					final Intensity item = metList[index % metList.length]; // Makes it infinitely cycle
					return option(item, outlineColour, backgroundColour, padding: 7.5);
				}
			),
		);
	}

	Widget option(Intensity item, Color outlineColour, Color backgroundColour, {double? padding})
	{
		final String text = item.label;
		final double factor = item.value;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 80,
				width: 210,
				child: Card
				(
					color: outlineColour,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: backgroundColour,
							width: 2
						),
						borderRadius: BorderRadiusGeometry.circular(20)
					),
					child: Padding
					(
						padding: EdgeInsets.only(top: padding ?? 5),
						child: RadioListTile<double>
						(
							contentPadding: const EdgeInsets.symmetric(horizontal: 0.0), // Reclaims some of the space lost by the radio tile
							title: Text(text, style: const TextStyle(fontWeight: .bold)),
							value: factor,
							groupValue: metFactor,
							onChanged: (newValue)
							{
								setState(()
								{
									metFactor = newValue;
									_calcs.updateControllers(metFactor: metFactor);
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

				Utils.widgetPlusHelper(Utils.header(activityName ?? "", 25, FontWeight.w600), HelpIcon(msg: "Enter the net time spent in active play. Exclude long periods of inactivity or halftime to maintain accuracy.\nIf you switch to a gym workout, this field is automatically bypassed.",), top: 45, right: 17.5),

				textBox("Activity Duration", "mins", sportDuration, fieldToSave: 1)
			]
		);
	}

	bool selectedSport()
	{
		if((metFactor == null) || (metFactor == EasyMET.weightLifting.value) || (metFactor == MidMET.weightLifting.value) || (metFactor == HardMET.weightLifting.value))
		{
			return false;
		}

		return true;
	}

	Widget weightLifting()
	{
		final String? name = activityName?.split(":").first;

		return Column
		(
			children:
			[
				const Padding(padding: EdgeInsetsGeometry.all(5)),

				Utils.widgetPlusHelper(Utils.header(name ?? "", 25, FontWeight.w600), HelpIcon(msg: "Enter your total time in the gym from your first set to your last. The formula used applies a 0.8 factor to account for standard rest intervals between sets. Entering data into a muscle group adjusts the intensity based on the metabolic demand of the movement type.\nIf you switch to a sport, these fields are automatically bypassed.",), top: 45, right: 17.5),

				Utils.widgetPlusHelper(textBox("Upper Body Duration", "mins", upperDuration, fieldToSave: 2), HelpIcon(msg: "Compound movements that target multiple muscles for the upper body and back area.\nExamples: Bench Press, Overhead Press, Dips, Push-ups, Pull-ups, Chin-ups, Bent-over Rows, Lat Pulldown, Cable Rows",), top: 35, right: 20), // Compound
				Utils.widgetPlusHelper(textBox("Accessories Duration", "mins", accessoriesDuration, fieldToSave: 3), HelpIcon(msg: "Isolated movements that only target 1-2 muscle groups.\nExamples: Bicep Curl, Tricep Cable Pushdown, Lateral Raise, Leg Extensions, Leg Curl, Calf Raise, Crunches",), top: 35, right: 20), // Isolation
				Utils.widgetPlusHelper(textBox("Lower Body Duration", "mins", lowerDuration, fieldToSave: 4), HelpIcon(msg: "Compound movements that target multiple muscles for the lower body and back area.\nExamples: Squats, Deadlifts, Lunges, Bulgarian Split Squats, Step-ups.",), top: 35, right: 20), // Compound
			]
		);
	}

	Widget cardio()
	{
		return Column
		(
			children:
			[
				Utils.widgetPlusHelper(Utils.header("Cardio", 25, FontWeight.w600), HelpIcon(msg: "To calculate how many calories you burned during cardio, input the distance that you traveled into the text field, and click on either the Run-Button or the Cycling-Button to apply the correct efficiency factor.",), top: 45, right: 17.5),

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
					child: const Padding
					(
						padding: EdgeInsets.all(8.0),
						child: Icon(Icons.directions_run_rounded, size: 60, color: Colors.black),
					),
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
									final double accBurn = metCalculator(accDurationNum, 0.7);
									final double lowerBurn = metCalculator(lowerDurationNum, 1.3);
				
									final double weightLiftingBurn = (upperBurn + accBurn + lowerBurn) * 0.8;
									final double sportBurn = metCalculator(sportDurationNum, 1);

									final double activityBurn = extractCorrectActivity(weightLiftingBurn, sportBurn);
									final (:name, :upper, :acc, :lower, :sport) = extractCorrectDuration(activityName, upperDurationNum, accDurationNum, lowerDurationNum, sportDurationNum);

									final double cardioBurn = widget.personWeight * distanceNum * (chosenCardio?.value ?? 0);

									_calcs.resetControllers();

									Navigator.push
									(
										context,
										MaterialPageRoute(builder: (context) => Utils.switchPage(context, EPOCPage(personWeight: widget.personWeight, age: widget.age, male: widget.male, bmr: widget.bmr, tdee: widget.tdee, activityBurn: activityBurn, cardioBurn: cardioBurn, additionalCalories: widget.additionalCalories, weeklyPlanner: widget.weeklyPlanner, cardioDistance: distanceNum, protein: selectedProteinIntensity, fat: selectedFatIntensity, metFactor: metFactor ?? 0, cardioFactor: chosenCardio?.value ?? 0, activityName: name ?? "", sportDuration: sport, upperDuration: upper, accessoryDuration: acc, lowerDuration: lower, cardioName: (chosenCardio?.label ?? ""), weeklyPlanId: widget.weeklyPlanId, dayId: widget.dayId))) // Takes you to the page that shows all the locations connected to the restaurant
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

	Widget nutrition()
	{
		return widget.weeklyPlanner == true ? Column
		(
			children:
			[
				chips("Protein Intensity", "Select the amount of protein that you want in your diet. 'Aggressive Cut / Fat Loss' helps preserve lean mass during a deficit and increases satiety, while 'Maintenance' provides the baseline RDA for health.", ProteinIntensity.values, true),

				chips("Fat Intake", "Select the amount of fat that you want in your diet. High Fat supports hormonal health and fat-soluble vitamin absorption (A, D, E, K), while Low Fat allows for higher carbohydrate volume to fuel high-intensity training.", FatIntensity.values, false),

				const Padding(padding: EdgeInsets.only(bottom: 75.0))

			]
		) : const SizedBox();
	}

	Widget chips(String header, String helpMsg, List<Nutrition> intensity, bool isProtein)
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

	Widget intensityChip(Nutrition intensity, int index, bool isProtein)
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

	({String? name, double upper, double acc, double lower, double sport}) extractCorrectDuration(String? name, double upper, double acc, double lower, double sport)
	{
		if((metFactor == EasyMET.weightLifting.value) || (metFactor == MidMET.weightLifting.value) || (metFactor == HardMET.weightLifting.value))
		{
			name = activityName?.split(":").first;
			return (name: name, upper: upper, acc: acc, lower: lower, sport: 0);
		}

		return (name: name, upper: 0, acc: 0, lower: 0, sport: sport);
	}


	double extractCorrectActivity(double weight, double sport)
	{
		if((metFactor == EasyMET.weightLifting.value) || (metFactor == MidMET.weightLifting.value) || (metFactor == HardMET.weightLifting.value))
		{
			return weight;
		}

		return sport;
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