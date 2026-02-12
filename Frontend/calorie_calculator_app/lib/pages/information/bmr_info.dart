import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class BMRInfo extends StatelessWidget
{
  	const BMRInfo({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("BMR Info")),
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
					const Text('''1. Basal Metabolic Rate (BMR)'''),

					const Text.rich
					(
						TextSpan
						(
							children:
							[
								TextSpan(text: "Definition: ", style: TextStyle(fontWeight: FontWeight.bold)),
								TextSpan(text: '''Your "Coma" burn; the energy required to maintain basic life functions at rest.'''),
							]
						)
					),
					
					const BulletedList
					(
						listItems: ['''Male Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) + 5''', '''Example (70kg | 180cm | 25 years | Male): (10 * 70) + (6.25 * 180) - (5 * 25) + 5 = 1705''', '''Female Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) - 161''', '''Example (65kg | 165cm | 25 years | Female): (10 * 65) + (6.25 * 165) - (5 * 25) - 161 = 1395'''],
					),
					
					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Note: ", style: TextStyle(fontWeight: FontWeight.bold)),
								const TextSpan(text: "The "),
								HyperLinker.hyperlinkText("Mifflin-St Jeor Equation", "https://pubmed.ncbi.nlm.nih.gov/2305711/", context),
								const TextSpan(text: " is the current clinical gold standard for estimating "),
								HyperLinker.hyperlinkText("BMR", "https://www.healthline.com/health/how-to-calculate-your-basal-metabolic-rate", context),
								const TextSpan(text: ". Established in 1990, it replaced the older "),
								const TextSpan(text: "Harris-Benedict Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "because it more accurately reflects modern body compositions and sedentary lifestyles. While highly reliable for the average population, it may underestimate needs for highly muscular individuals or overestimate for those with high body fat percentages, as muscle tissue is more metabolically active than fat. Which is where the "),
								const TextSpan(text: "Katch-McArdle Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "comes in handy. However for simplicity and to accommodate the general population, the "),
								const TextSpan(text: "Mifflin-St Jeor Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "is used in the app."),
							]
						)
					),					
				],
			),
		);
	}
}