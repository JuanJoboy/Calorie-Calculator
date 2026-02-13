import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleDayInfo extends StatelessWidget
{
  	const ExampleDayInfo({super.key});

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
					const Text('''Daily Calculation Summary'''),
					const Text('''Use the following formula to determine intake requirements for training days: TDEE + Activity Burn + Run Burn + EPOC'''),

					const Text('''Example Scenario (70kg User)'''),

					Table
					(
						border: TableBorder.all(color: Colors.grey),
						children:
						[
							TableRow
							(
								children:
								[
									headerOption("Component"),
									headerOption("Calculation"),
									headerOption("Subtotal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Sedentary Baseline"),
									textOption("1,700 * 1.45"),
									textOption("2,465 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Heavy Weight Lifting (40 minutes of upper body)"),
									textOption("((5 * 3.5 * 70) / 200) * 40 * 1.2"),
									textOption("294 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Heavy Weight Lifting (30 minutes of accessories)"),
									textOption("((5 * 3.5 * 70) / 200) * 30 * 0.7"),
									textOption("129 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Total Gym Expenditure"),
									textOption("(294 + 129) * 0.8"),
									textOption("338 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Cardio (2km Running)"),
									textOption("70 * 2 * 1"),
									textOption("140 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("EPOC (Moderate / Anaerobic)"),
									textOption("(338 + 140) * 0.10"),
									textOption("48 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Total Burn"),
									textOption("(1,700 * 1.45) + (((((5 * 3.5 * 70) / 200) * 40 * 1.2) + (((5 * 3.5 * 70) / 200) * 30 * 0.7)) * 0.8) + (70 * 2 * 1) + ((338 + 140) * 0.10)"),
									textOption("2,991 kcal")
								]
							)
						],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''To double check this value, go to '''),
								HyperLinker.hyperlinkText("BMR Calculator", "https://www.calculator.net/bmr-calculator.html?cage=25&csex=m&cheightfeet=5&cheightinch=10&cpound=160&cheightmeter=180&ckg=70&cmop=0&coutunit=c&cformula=m&cfatpct=20&ctype=metric&x=Calculate", context),
								const TextSpan(text: ''' and put in a 25 year old Male that weighs 70kg and is 180cm tall. And you'll see that the value provided here is very close to the value associated with "Intense exercise 6-7 times/week". Which makes sense, because if you did this intense workout every single day, you definitely would need around 3,000 calories everyday to retain basic bodily functions.'''),
							]
						)
					),
				]
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