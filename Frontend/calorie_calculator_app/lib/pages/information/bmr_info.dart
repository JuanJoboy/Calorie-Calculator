import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class BMRInfo extends Information
{
  	const BMRInfo({super.key});

	@override
  	String get appBarText => "BMR Info";

	@override
	List<Widget> info(BuildContext context)
	{
		return
		[
			Utils.header('''Basal Metabolic Rate''', 30, FontWeight.bold),

			Utils.header("Definition", 25, FontWeight.w600),

			const SizedBox(height: 20),

			const Text('''The amount of energy your body uses to maintain basic life functions at rest. It is essentially the amount of energy you would use up in a coma.''', style: TextStyle(fontSize: 20)),
			
			Utils.header("Formulas", 25, FontWeight.w600),
			Utils.header("Male Formula", 20, FontWeight.w500, padding: 25),
			bullet("(10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) + 5", context),
			Utils.header("Example", 20, FontWeight.w500, padding: 25),
			bullet("(70kg | 180cm | 25 years | Male): (10 * 70) + (6.25 * 180) - (5 * 25) + 5 = 1705", context),
			Utils.header("Female Formula", 20, FontWeight.w500, padding: 25),
			bullet("(10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) - 161", context),
			Utils.header("Example", 20, FontWeight.w500, padding: 25),
			bullet("(65kg | 165cm | 25 years | Female): (10 * 65) + (6.25 * 165) - (5 * 25) - 161 = 1395", context),

			Utils.header("Note", 25, FontWeight.w600),

			Text.rich
			(
				TextSpan
				(
					style: const TextStyle(fontSize: 20),
					children:
					[
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
		];
	}

	Widget bullet(String text, BuildContext context)
	{
		return BulletedList
		(
			listItems: [text],
			bulletColor: Theme.of(context).extension<AppColours>()!.text!,
			style: TextStyle(fontSize: 15, color: Theme.of(context).extension<AppColours>()!.text!),
		);
	}
}