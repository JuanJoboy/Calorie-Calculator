import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleBulkInfo extends StatelessWidget
{
  	const ExampleBulkInfo({super.key});

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
					const Text("Example Weekly Bulk Breakdown"),

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
									textOption("3,511"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Upper + Accessories Gym Day (2x)"),
									textOption("2,991"),
									textOption("3,491"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (3x)"),
									textOption("2,465"),
									textOption("2,965"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("19,399"),
									textOption("22,899"),
									textOption("+3,500")
								]
							)
						],
					)
				],
			),
		);
	}

	Widget gainWeight2(BuildContext context)
	{
		return const Card
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
								TextSpan(text: '''How to Gain 450g per Week''', style: TextStyle(fontSize: 20, fontWeight: .bold)),
								TextSpan(text: '''\nTo gain 450g of weight, you must create a cumulative weekly surplus of 3,500 calories.'''),
								TextSpan(text: '''\nThere are 2 main ways this extra energy is stored. If you are exercising consistently, a portion of this will be stored as muscle glycogen and tissue. If you are sedentary, the vast majority will be stored as fat.''')
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