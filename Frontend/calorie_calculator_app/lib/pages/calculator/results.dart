import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatefulWidget
{
	final double personWeight;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	final double epoc;

	const ResultsPage({super.key, required this.personWeight, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn, required this.epoc});

	@override
	State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
{
	late AllCalculations _list;

	@override void initState()
	{
    	super.initState();
		
		final AllCalculations list = context.read<AllCalculations>(); // Since there's no context available here, I just read, rather than making and adding the widget to the tree

		_list = list;
  	}

	@override
	Widget build(BuildContext context)
	{
		final double total = widget.tdee + widget.activityBurn + widget.cardioBurn + widget.epoc;

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
							header("Caloric Breakdown", 30, FontWeight.bold),

							
							header("Basal Metabolic Rate", 25, FontWeight.w600),
							displayInfo("BMR", "${widget.bmr.round()}", padding: 40),
							
							header("Total Daily Energy Expenditure", 25, FontWeight.w600),
							displayInfo("TDEE", "${widget.tdee.round()}", padding: 40),
							
							header("Activity Burn", 25, FontWeight.w600),
							displayInfo("MET Method", "${widget.activityBurn.round()}", padding: 40),
							
							header("Running Burn", 25, FontWeight.w600),
							displayInfo("Distance Method", "${widget.cardioBurn.round()}", padding: 40),
							
							header("Recovery Burn", 25, FontWeight.w600),
							displayInfo("EPOC", "${widget.epoc.round()}", padding: 40),
							
							header("Todays Caloric Ceiling", 25, FontWeight.w600),
							displayInfo("Maintenance Calories", "${total.round()}", padding: 40),

							submitButton(total)
						],
					)
				)
			)
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

	Widget displayInfo(String header, String info, {double? padding})
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 105,
				width: 230,
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
												child: Center(child: Text(info, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
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

	Widget submitButton(double total)
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
							newCalculation(widget.personWeight, widget.bmr, widget.tdee, widget.activityBurn, widget.cardioBurn, widget.epoc, total);
							
							Navigator.popUntil
							(
								context,
								(route) => route.isFirst
							);
						},
						child: const Text("Upload To Timeline", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
					)
				),
			),
		);
	}

	void newCalculation(double weight, double bmr, double tdee, double activityBurn, double cardioBurn, double epoc, double total)
	{
		Calculation calc = Calculation(id: null, date: DateTime.now().toIso8601String(), personWeight: weight, bmr: bmr, tdee: tdee, weightLiftingBurn: activityBurn, cardioBurn: cardioBurn, epoc: epoc, totalBurn: total);

		_list.uploadCalc(calc);
	}
}