import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/results.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';

class EPOCPage extends StatefulWidget
{
	final double personWeight;
	final double bmr;
	final double tdee;
	final double activityBurn;
	final double cardioBurn;
	
	const EPOCPage({super.key, required this.personWeight, required this.bmr, required this.tdee, required this.activityBurn, required this.cardioBurn});

	@override
	State<EPOCPage> createState() => _EPOCPageState();
}

class _EPOCPageState extends State<EPOCPage>
{
	@override
	Widget build(BuildContext context)
	{
		Color aeOutline = Theme.of(context).extension<AppColours>()!.aerobicOutlineColour!;
		Color aeBackground = Theme.of(context).extension<AppColours>()!.aerobicBackgroundColour!;
		Color anOutline = Theme.of(context).extension<AppColours>()!.anaerobicOutlineColour!;
		Color anBackground = Theme.of(context).extension<AppColours>()!.anaerobicBackgroundColour!;
		Color maOutline = Theme.of(context).extension<AppColours>()!.maximalOutlineColour!;
		Color maBackground = Theme.of(context).extension<AppColours>()!.maximalBackgroundColour!;

		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("EPOC Calculator")),
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
							Utils.widgetPlusHelper(Utils.header("Activity Intensity Level", 30, FontWeight.bold), HelpIcon(msg: "Select your Intensity based on RPE (Rate of Perceived Exertion). The more you exerted yourself, the higher your RPE.",), top: 50, right: 17.5),

							Utils.header("Light / Aerobic", 25, FontWeight.w600),
							button("RPE 1-4", "Breathing is easy;", "conversation is possible", 0.05, aeOutline, aeBackground),

							Utils.header("Moderate / Anaerobic", 25, FontWeight.w600),
							button("RPE 5-8", "Heavy lifting or fast pace;", "conversation is difficult", 0.1, anOutline, anBackground),
							
							Utils.header("Vigorous / Maximal", 25, FontWeight.w600),
							button("RPE 9-10", "To failure, and gasping for air;", "conversation is impossible", 0.15, maOutline, maBackground),

							const Padding(padding: EdgeInsetsGeometry.all(50))
						],
					),
				)
			)
		);
	}

	Widget button(String header, String subtitle1, String subtitle2, double epocFactor, Color background, Color outline)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: SizedBox
			(
				height: 150,
				width: 300,
				child: Card
				(
					color: background,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: outline,
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
				
							SizedBox
							(
								height: 50,
								width: 100,
								child: Card
								(
									shape: RoundedRectangleBorder
									(
										side: BorderSide
										(
											color: outline,
											width: 2
										),
										borderRadius: BorderRadiusGeometry.circular(100)
									),
									color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
									child: ElevatedButton
									(
										onPressed: ()
										{
											final double epoc = (widget.activityBurn + widget.cardioBurn) * epocFactor;

											Navigator.push
											(
												context,
												MaterialPageRoute(builder: (context) => Utils.switchPage(context, ResultsPage(personWeight: widget.personWeight, bmr: widget.bmr, tdee: widget.tdee, activityBurn: widget.activityBurn, cardioBurn: widget.cardioBurn, epoc: epoc))) // Takes you to the page that shows all the locations connected to the restaurant
											);
										},
										child: const Text("Next", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black))
,
									)
								),
							),
			
							Text
							(
								subtitle1,
								style: const TextStyle
								(
									fontSize: 17,
									fontWeight: FontWeight.w600
								),
							),
							Text
							(
								subtitle2,
								style: const TextStyle
								(
									fontSize: 15,
									fontWeight: FontWeight.w500
								),
							),
						],
					),
				),
			),
		);
	}
}