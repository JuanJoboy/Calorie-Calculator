import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
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
		final textCol = Theme.of(context).extension<AppColours>()!.text!;
		final formulaCol = Theme.of(context).extension<AppColours>()!.bmr!;

		return
		[
			const Header(text: '''Basal Metabolic Rate''', fontSize: 32, fontWeight: FontWeight.bold),

			const Header(text: "Definition", fontSize: 24, fontWeight: FontWeight.w600),
			const SizedBox(height: 12),
			Text('''The amount of energy your body uses to maintain basic life functions at rest. It is essentially the amount of energy you would use up in a coma.''', style: TextStyle(fontSize: 18, height: 1.5, color: textCol)),
			
			const Header(text: "Formulas", fontSize: 24, fontWeight: FontWeight.w600),
			const SizedBox(height: 12),

			_formulaCard
			(
				context,
				textColour: textCol,
				formulaColour: formulaCol,
				title: "Male Formula",
				formula: "(10 × Weight) + (6.25 × Height) - (5 × Age) + 5",
				example: "70kg, 180cm, 25y: 1705 kcal",
			),
				
			_formulaCard
			(
				context,
				textColour: textCol,
				formulaColour: formulaCol,
				title: "Female Formula",
				formula: "(10 × Weight) + (6.25 × Height) - (5 × Age) - 161",
				example: "65kg, 165cm, 25y: 1395 kcal",
			),

			const Header(text: "Note", fontSize: 24, fontWeight: FontWeight.w600),
			_note(context),
			const SizedBox(height: 100),
		];
	}

	Widget _formulaCard(BuildContext context, {required Color textColour, required Color formulaColour, required String title, required String formula, required String example})
	{
		return Container
		(
			margin: const EdgeInsets.only(bottom: 16),
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration
			(
				color: formulaColour.withOpacity(0.1),
				borderRadius: BorderRadius.circular(12),
			),
			child: Column
			(
				crossAxisAlignment: CrossAxisAlignment.start,
				children:
				[
					Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColour)),
					const SizedBox(height: 8),
					Text(formula, style: TextStyle(fontSize: 16, fontFamily: 'monospace', color: formulaColour)),
					const SizedBox(height: 4),
					Text("Example: $example", style: TextStyle(fontSize: 14, color: textColour.withOpacity(0.7))),
				],
			),
		);
	}

	Widget _note(BuildContext context)
	{
		final accentColor = Theme.of(context).extension<AppColours>()!.text!.withOpacity(0.3);
		
		return Container
		(
			padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
			decoration: BoxDecoration
			(
				border: Border(left: BorderSide(color: accentColor, width: 3)),
			),
			child: Text.rich
			(
				TextSpan
				(
					style: TextStyle
					(
						fontSize: 16,
						height: 2,
						color: Theme.of(context).extension<AppColours>()!.text,
					),
					children:
					[
						const TextSpan(text: "The "),
						HyperLinker.hyperlinkText("Mifflin-St Jeor Equation", "https://pubmed.ncbi.nlm.nih.gov/2305711/", context),
						const TextSpan(text: " is the current clinical gold standard for estimating "),
						HyperLinker.hyperlinkText("BMR", "https://www.healthline.com/health/how-to-calculate-your-basal-metabolic-rate", context),
						const TextSpan(text: ".\n\n"),

						const TextSpan(text: "Established in 1990, it replaced the older "),
						const TextSpan(text: "Harris-Benedict Equation", style: TextStyle(fontStyle: FontStyle.italic)),
						const TextSpan(text: " because it more accurately reflects modern body compositions and sedentary lifestyles.\n\n"),
						
						const TextSpan(text: "While highly reliable for the average population, it may underestimate needs for highly muscular individuals or overestimate for those with high body fat percentages, as muscle tissue is more metabolically active than fat. Which is where the "),
						const TextSpan(text: "Katch-McArdle Equation", style: TextStyle(fontStyle: FontStyle.italic)),
						const TextSpan(text: " comes in handy. However for simplicity and to accommodate the general population, the "),
						const TextSpan(text: "Mifflin-St Jeor Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
						const TextSpan(text: "is used in this app."),
					],
				),
			),
		);
	}
}