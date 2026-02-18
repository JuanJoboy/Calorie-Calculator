import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ActivityInfo extends Information
{
  	const ActivityInfo({super.key});

	@override
  	String get appBarText => "Activity Info";

	@override
	List<Widget> info(BuildContext context)
	{
		final textCol = Theme.of(context).extension<AppColours>()!.text!;
		final formulaCol = Theme.of(context).extension<AppColours>()!.bmr!;

		return
		[
			const Header(text: 'Activity Burn', fontSize: 32, fontWeight: FontWeight.bold),

			_componentSection
			(
				context,
				textCol,
				"Definition",
				[
					const TextSpan(text: "The cells in your muscles use oxygen to help create the energy needed to move your muscles.\n\nOne "),
					HyperLinker.hyperlinkText("MET", "https://www.healthline.com/health/what-are-mets", context),
					const TextSpan(text: " is defined as the consumption of 3.5 milliliters of oxygen per kilogram of body weight per minute."),
				]
			),

			const Header(text: "Example", fontSize: 24, fontWeight: FontWeight.w600),
			const SizedBox(height: 20),
            _metExplanationCard(context, textCol),

            const Header(text: "MET Formula", fontSize: 24, fontWeight: FontWeight.w600),
			const SizedBox(height: 20),
            _formulaCard
            (
                context,
                formula: "((MET × 3.5 × Weight) / 200) × Duration",
                example: "5 MET, 70kg, 90 min: 551 kcal",
                textColour: textCol,
                formulaColour: formulaCol,
            ),

			_componentSection
			(
				context,
				textCol,
				"Sports & Continuous Activity",
				[
					const TextSpan(text: "For the MET formula to work, it assumes constant work, so the above formula works well for sports and other "),
					HyperLinker.hyperlinkText("continuous activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
					const TextSpan(text: " where you can easily track how long you actually did an activity for.\n\nHowever for activities that incorporate lots of rest (like weightlifting), a multiplier of 0.8 is used to create a leniency factor to accommodate for the rest periods.\n\n"),
					const TextSpan(text: "Additionally for weightlifting, some parts of your body will burn more calories than other parts. "),
					HyperLinker.hyperlinkText("Doing a bicep curl will use significantly less energy than a full body squat.", "https://pmc.ncbi.nlm.nih.gov/articles/PMC5524349/", context),
					const TextSpan(text: " So for both accuracy and simplicity, this app splits up every muscle group into 3 sections"),
				]
			),

			_componentSection
			(
				context,
				textCol,
				"Weightlifting Categories",
				[
					TextSpan(text: "The metabolic cost of an exercise is determined by the volume of muscle mass activated and the total mechanical work performed.\n\nSmall isolated muscle movements are the most energy efficient, while large scale compound movements, particularly in the lower body elicit the highest cardiovascular and anaerobic demand.", style: TextStyle(fontSize: 16, height: 1.5, color: textCol)),
				],
				components:
				[
					_muscleCategoryCard(context, "1. Upper Body", "Compound movements that target multiple muscles for the upper body and back area.", "Bench Press, Overhead Press, Dips, Push-ups, Pull-ups, Chin-ups, Bent-over Rows, Lat Pulldown, Cable Rows.", textCol),
					_muscleCategoryCard(context, "2. Accessories", "Isolated movements that only target 1-2 muscle groups.", "Bicep Curl, Tricep Cable Pushdown, Lateral Raise, Leg Extensions, Leg Curl, Calf Raise, Crunches.", textCol),
					_muscleCategoryCard(context, "3. Lower Body", "Compound movements that target multiple muscles for the lower body and back.", "Squats, Deadlifts, Lunges, Bulgarian Split Squats, Step-ups.", textCol),
				]
			),

            const SizedBox(height: 100),
        ];
    }

	Widget _componentSection(BuildContext context, Color textCol, String header, List<InlineSpan> paragraph, {List<Widget>? components})
	{
		return Column
		(
			children: 
			[
				Header(text: header, fontSize: 24, fontWeight: FontWeight.w600),
				const SizedBox(height: 20),

				Text.rich
				(
					TextSpan
					(
						style: TextStyle(fontSize: 16, height: 1.5, wordSpacing: 1.5, color: textCol),
						children: paragraph
					)
				),

				if(components != null)
					const SizedBox(height: 20),

				if(components != null)
					for(var component in components)
						component,
			],
		);
	}

    Widget _metExplanationCard(BuildContext context, Color textCol)
    {
        return Container
        (
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                color: textCol.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textCol.withOpacity(0.1)),
            ),
            child: Text
			(
                "If you weigh 70kg, you consume ~245mL of oxygen per minute at rest (70kg × 3.5mL).\n\nAn exercise with a MET of 5 means you are using 5x the energy you normally consume at rest.",
                style: TextStyle(fontSize: 15, color: textCol.withOpacity(0.8), height: 2, wordSpacing: 2),
            ),
        );
    }

    Widget _formulaCard(BuildContext context, {required String formula, required String example, required Color textColour, required Color formulaColour})
    {
        return Container
        (
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration
            (
                color: formulaColour.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
            ),
            child: Column
            (
                children: 
                [
                    Text(formula, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: formulaColour, fontFamily: 'monospace')),
                    const SizedBox(height: 12),
                    Text("Example: $example", style: TextStyle(fontSize: 14, color: textColour.withOpacity(0.7))),
                ],
            ),
        );
    }

    Widget _muscleCategoryCard(BuildContext context, String title, String def, String examples, Color textCol)
    {
        return Container
        (
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                border: Border(left: BorderSide(color: textCol.withOpacity(0.2), width: 2)),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textCol)),
                    const SizedBox(height: 4),
                    Text(def, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textCol)),
                    const SizedBox(height: 8),
                    Text("Examples: $examples", style: TextStyle(fontSize: 14, color: textCol.withOpacity(0.6), fontStyle: FontStyle.italic)),
                ],
            ),
        );
    }
}