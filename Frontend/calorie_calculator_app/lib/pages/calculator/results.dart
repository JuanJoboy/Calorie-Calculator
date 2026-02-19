import 'package:calorie_calculator/main.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/formulas.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator/pages/calculator/calculations.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatefulWidget
{
	final double personWeight;
	final double age;
	final bool male;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	final double epoc;

	const ResultsPage({super.key, required this.personWeight, required this.age, required this.male, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn, required this.epoc});

	@override
	State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
{
	late AllCalculations _list;
	late CalculationFields _calcs;
	late UsersTdeeNotifier _usersNotifier;

	@override void initState()
	{
    	super.initState();
		
		_list = context.read<AllCalculations>();

		_calcs = context.read<CalculationFields>();

		_usersNotifier = context.read<UsersTdeeNotifier>();
  	}

	@override
	Widget build(BuildContext context)
	{
		final double total = CalorieMath.totalCaloriesToday(widget.tdee, widget.activityBurn, widget.cardioBurn, widget.epoc);

		final (:bmr, :tdee, :activity, :cardio, :epoc, totalCal: roundedTotal, :totalBurn) = CalorieMath.roundValues(widget.bmr, widget.tdee, widget.activityBurn, widget.cardioBurn, widget.epoc, total);

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("Results")),
			body: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Center
				(
					child: Column
					(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children:
						[
							const Header(text: "Caloric Breakdown", fontSize: 30, fontWeight: FontWeight.bold),
							
							const Header(text: "Basal Metabolic Rate", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("BMR", "$bmr", padding: 40),
							
							const Header(text: "Total Daily Energy Expenditure", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("TDEE", "$tdee", padding: 40),
							
							const Header(text: "Activity Burn", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("MET Method", "$activity", padding: 40),
							
							const Header(text: "Running Burn", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("Distance Method", "$cardio", padding: 40),
							
							const Header(text: "Recovery Burn", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("EPOC", "$epoc", padding: 40),

							const Header(text: "Total Calories Burned", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("Total Exercise", "$totalBurn", padding: 40),
							
							const Header(text: "Todays Caloric Ceiling", fontSize: 25, fontWeight: FontWeight.w600),
							_displayInfo("Maintenance Calories", "$roundedTotal", padding: 40),

							_submitButton(total)
						],
					)
				)
			)
		);
  	}

	Widget _displayInfo(String header, String info, {double? padding})
	{
		final colour = Theme.of(context).extension<AppColours>()!;
		
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 105,
				width: 230,
				child: Card
				(
					color: colour.tertiaryColour,
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
								crossAxisAlignment: CrossAxisAlignment.center,
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
												child: Center(child: Text(info, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
											),
										),
									),
					
									const Padding
									(
										padding: EdgeInsets.only(left: 8.0),
										child: Text
										(
											"kcal",
											style: TextStyle
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

	Widget _submitButton(double total)
	{
		return Padding
		(
			padding: const EdgeInsets.only(bottom: 100.0, top: 50),
			child: SizedBox
			(
				height: 100,
				width: 150,
				child: Card
				(
					shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(112)),
					elevation: 2,
					child: ElevatedButton
					(
						style: ElevatedButton.styleFrom
						(
							backgroundColor: Theme.of(context).extension<AppColours>()!.secondaryColour!
						),
						onPressed: ()
						{
							_newCalculation(widget.personWeight, widget.bmr, widget.tdee, widget.activityBurn, widget.cardioBurn, widget.epoc, total, widget.age, widget.male);
							
							Navigator.popUntil
							(
								context,
								(route) => route.isFirst
							);

							context.read<NavigationNotifier>().changeIndex(3);
						},
						child: const Text("Upload To Timeline", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
					)
				),
			),
		);
	}

	Future<void> _newCalculation(double weight, double bmr, double tdee, double activityBurn, double cardioBurn, double epoc, double total, double age, bool male) async
	{
		try
		{
			Calculation calc = Calculation(id: null, date: DateTime.now().toIso8601String(), personWeight: weight, bmr: bmr, tdee: tdee, weightLiftingBurn: activityBurn, cardioBurn: cardioBurn, epoc: epoc, totalBurn: total);

			await _list.uploadCalc(calc);

			await _usersNotifier.uploadOrEditTdee(bmr, tdee, weight, age, male);

			_resetControllers();
		}
		catch(e)
		{
			if(mounted)
			{
				ErrorHandler.showSnackBar(context, "An error occurred in saving your calculation");
				debugPrint("Debug Print: ${e.toString()}");
			}
		}
	}

	void _resetControllers()
	{
		_calcs.updateControllers(sport: "", upper: "", accessories: "", lower: "", distance: "");
	}
}