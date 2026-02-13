import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleCutInfo extends StatelessWidget
{
  	const ExampleCutInfo({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("XXX Info")),
			body: SingleChildScrollView
			(
				physics: const BouncingScrollPhysics(),
				child: Center
				(
					child: info(context)
				)
			)
		);
	}

	Widget info(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text("Example Weekly Cut Breakdown"),
					
					Table
					(
						children:
						[
							TableRow
							(
								children:
								[
									headerOption("Day Type"),
									headerOption("Total TDEE (kcal)"),
									headerOption("Caloric Intake (kcal)"),
									headerOption("Daily Difference (kcal)")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Legs + Accessories Gym Day (2x)"),
									textOption("3,011"),
									textOption("2,500"),
									textOption("-511")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Upper + Accessories Gym Day (2x)"),
									textOption("2,991"),
									textOption("2,400"),
									textOption("-591")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (3x)"),
									textOption("2,465"),
									textOption("2,000"),
									textOption("-465")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("19,399"),
									textOption("15,800"),
									textOption("-3,599")
								]
							)
						],
					),
				],
			),
		);
	}

	Widget loseWeight2(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''How to Lose 450g per Week''', style: TextStyle(fontSize: 20, fontWeight: .bold)),
								const TextSpan(text: '''\nTo lose 450g of fat, you must create a cumulative weekly deficit of 3,500 calories. This means your body must burn 3,500 more calories than it consumes over 7 days.'''),
								const TextSpan(text: '''\nWhen the body lacks 500 calories from food to perform its daily functions, it triggers '''),
								HyperLinker.hyperlinkText("lipolysis", "https://www.revitalizemedspa.ca/what-is-lipolysis-understanding-the-science-behind-fat-burning", context),
								const TextSpan(text: ''' (breaking down stored fat) to make up the energy difference. For high-intensity athletes, managing '''),
								HyperLinker.hyperlinkText("glycogen levels", "https://inscyd.com/article/muscle-glycogen-and-exercise-all-you-need-to-know/", context),
								const TextSpan(text: ''' is critical to avoid getting fatigued easily.''')
							]
						)
					),
				],
			),
		);
	}

	Widget headerOption(String text)
	{
		return TableCell
		(
			verticalAlignment: TableCellVerticalAlignment.middle,
			child: Padding
			(
				padding: const EdgeInsetsGeometry.all(8),
				child: Center
				(
					child: Text
					(
						text,
						textAlign: TextAlign.center,
						style: const TextStyle
						(
							fontWeight: FontWeight.bold,
							fontSize: 15
						),
					)
				)
			),
		);
	}

	Widget textOption(String text)
	{
		return TableCell
		(
			verticalAlignment: TableCellVerticalAlignment.middle,
			child: Padding
			(
				padding: const EdgeInsetsGeometry.all(8),
				child: Center
				(
					child: Text
					(
						text,
						textAlign: TextAlign.center,
					)
				)
			)
		);
	}
}