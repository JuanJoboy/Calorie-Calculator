import 'package:calorie_calculator_app/pages/information/bmr_info.dart';
import 'package:calorie_calculator_app/pages/information/cardio_info.dart';
import 'package:calorie_calculator_app/pages/information/epoc_info.dart';
import 'package:calorie_calculator_app/pages/information/example_bulk_info.dart';
import 'package:calorie_calculator_app/pages/information/example_cut_info.dart';
import 'package:calorie_calculator_app/pages/information/example_day_info.dart';
import 'package:calorie_calculator_app/pages/information/nutritional_info.dart';
import 'package:calorie_calculator_app/pages/information/sports_info.dart';
import 'package:calorie_calculator_app/pages/information/tdee_info.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';

class InformationPage extends StatefulWidget
{
	const InformationPage({super.key});

	@override
	State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
{
	@override
	Widget build(BuildContext context)
	{
		return Center
		(
			child: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Column
				(
					children:
					[
						title(),

						disclaimer(),

						clickMe(),

						infoGrid(),

						infoSquare("Nutrition", const NutritionalInfo(), Theme.of(context).extension<AppColours>()!.runSeColour!, Theme.of(context).extension<AppColours>()!.runUnColour!),
					]
				),
			)
		);
  	}

	Widget title()
	{
		return Column
		(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.center,
			children:
			[
				const Header(text: "How It's Calculated", fontSize: 30, fontWeight: FontWeight.bold),
				
				Text("Concepts and Formulas", style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor, fontWeight: FontWeight.w400)),
				
				const SizedBox(height: 20),
				
				const Divider(indent: 50, endIndent: 50, height: 40),
			],
		);
	}

	Widget disclaimer()
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0),
			child: LayoutBuilder
			(
				builder: (context, constraints)
				{
					return SizedBox
					(
						width: constraints.maxWidth - 40,
						child: Card
						(
							color: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
							shape: RoundedRectangleBorder
							(
								side: BorderSide
								(
									color: Theme.of(context).extension<AppColours>()!.secondaryColour!,
									width: 6
								),
								borderRadius: BorderRadiusGeometry.circular(20)
							),
							child: Column
							(
								children:
								[
									Padding
									(
										padding: const EdgeInsets.only(top: 20.0),
										child: Text
										(
											"Disclaimer",
											style: TextStyle
											(
												fontSize: 20,
												fontWeight: FontWeight.w900,
												color: Theme.of(context).extension<AppColours>()!.disclaimer!
											)
										),
									),
						
									SizedBox
									(
										child: Padding
										(
											padding: const EdgeInsets.all(8.0),
											child: BulletedList
											(
												listItems: ['''The caloric data provided are simply mathematical estimations, not clinical measurements.''', '''Individual factors (genetics, body composition, hormonal health, etc) are too variable and are beyond the scope of this calculator.''', '''This means that these figures serve as a guide rather than an absolute value. The same goes with the nutritional information, they're based on the standards for a healthy adult, not an elderly person or a child. So use these results at your own discretion.''', '''For precise nutritional or medical planning, consult a certified professional.'''],
												style: TextStyle(fontSize: 15, fontWeight: .w700, color: Theme.of(context).extension<AppColours>()!.disclaimer!),
												bullet: Icon(Icons.warning_amber_rounded, size: 30, color: Theme.of(context).extension<AppColours>()!.disclaimer!, fontWeight: .w500),
											)
										)
									)
								],
							),
						),
					);
				}
			),
		);
	}

	Widget clickMe()
	{
		return Column
		(
			crossAxisAlignment: CrossAxisAlignment.center,
			mainAxisAlignment: MainAxisAlignment.center,
			children:
			[
				const SizedBox(height: 20),

				const Divider(indent: 50, endIndent: 50, height: 40),

				Padding
				(
					padding: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
					child: Text("Select one of the categories below to learn more", style: TextStyle(color: Theme.of(context).hintColor)),
				),

				const Icon(Icons.arrow_downward_rounded, size: 30, fontWeight: .w500)
			],
		);
	}

	Widget infoGrid()
	{
		return GridView.count
		(
			crossAxisCount: 2, // Number of columns
			shrinkWrap: true,   // Allows the grid to take only as much space as it needs
			physics: const NeverScrollableScrollPhysics(), // Disables internal scrolling
			children:
			[
				infoSquare("BMR", const BMRInfo(), Theme.of(context).extension<AppColours>()!.bmr!, Theme.of(context).extension<AppColours>()!.maleUnColour!),
				infoSquare("TDEE", const TDEEInfo(), Theme.of(context).extension<AppColours>()!.bmr!, Theme.of(context).extension<AppColours>()!.maleUnColour!),
				infoSquare("Activity", const ActivityInfo(), Theme.of(context).extension<AppColours>()!.caloricBurn!, Theme.of(context).extension<AppColours>()!.caloricBurn2!),
				infoSquare("Cardio", const CardioInfo(), Theme.of(context).extension<AppColours>()!.caloricBurn!, Theme.of(context).extension<AppColours>()!.caloricBurn2!),
				infoSquare("Epoc", const EPOCInfo(), Theme.of(context).extension<AppColours>()!.caloricBurn!, Theme.of(context).extension<AppColours>()!.caloricBurn2!),
				infoSquare("Example Day", const ExampleDayInfo(), Theme.of(context).extension<AppColours>()!.outerYellow!, Theme.of(context).extension<AppColours>()!.innerYellow!),
				infoSquare("Example Bulk", const ExampleBulkInfo(), Theme.of(context).extension<AppColours>()!.outerYellow!, Theme.of(context).extension<AppColours>()!.innerYellow!),
				infoSquare("Example Cut", const ExampleCutInfo(), Theme.of(context).extension<AppColours>()!.outerYellow!, Theme.of(context).extension<AppColours>()!.innerYellow!),
			],
		);
	}

	Widget infoSquare(String title, Widget infoPage, Color outline, Color background)
	{
		return Padding
		(
			padding: const EdgeInsets.all(20),
			child: SizedBox
			(
				width: 200,
				height: 100,
				child: GestureDetector
				(
					onTap: () async
					{
						await Navigator.push
						(
							context,
							MaterialPageRoute(builder: (context) => PageSwitcher(nextPage: infoPage))
						);
					},
					child: Card
					(
						color: background,
						shape: RoundedRectangleBorder
						(
							side: BorderSide
							(
								color: outline,
								width: 4
							),
							borderRadius: BorderRadiusGeometry.circular(20)
						),
						child:
						Center
						(
							child: Padding
							(
								padding: const EdgeInsets.all(10.0),
								child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: .w500)),
							),
						)
					),
				)
			),
		);
	}
}

abstract class Information extends StatelessWidget
{
	String get appBarText;

  	const Information({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: Text(appBarText)),
			body: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Center
				(
					child: baseCard(info(context))
				)
			)
		);
	}

	Widget baseCard(List<Widget> infoText)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 30.0),
			child: Column
			(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: infoText
			),
		);
	}

	List<Widget> info(BuildContext context);
}