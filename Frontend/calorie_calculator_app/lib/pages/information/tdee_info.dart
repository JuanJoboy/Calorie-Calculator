import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class TDEEInfo extends Information
{
    const TDEEInfo({super.key});

    @override
    String get appBarText => "TDEE Info";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final formulaCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            Utils.header('Total Daily Energy Expenditure', 32, FontWeight.bold, color: textCol),

			_componentSection
			(
				context,
				textCol,
				"Definition",
				[
					const TextSpan(text: "The total number of calories you burn in a given day. "),
					HyperLinker.hyperlinkText("Your TDEE is the sum of four metabolic components:", "https://steelfitusa.com/blogs/health-and-wellness/calculate-tdee", context)
				],
				[
					_componentTile(context, "BMR", "Basal Metabolic Rate", "Your \"Coma Burn\""),
					_componentTile(context, "TEF", "Thermic Effect of Food", "Energy used for digestion"),
					_componentTile(context, "NEAT", "Non-Exercise Activity", "Daily movement (walking, chores)"),
					_componentTile(context, "TEA", "Thermic Effect of Activity", "Intentional exercise (gym, sports)"),
				]
			),

			_componentSection
			(
				context,
				textCol,
				"Multipliers",
				[
					const TextSpan(text: '''Standard calculators use generic multipliers that bundle your gym time into your lifestyle. To ensure high fidelity, this app isolates TEA to avoid double dipping. So instead of using the traditional multipliers below that other calculators use, PAL's are used instead.''')
				],
				[
					_componentTile(context, "1.2", "Sedentary", "Desk job, no exercise"),
					_componentTile(context, "1.375", "Lightly Active", "1-3 days/week"),
					_componentTile(context, "1.55", "Moderately Active", "3-5 days/week"),
					_componentTile(context, "1.725", "Very Active", "6-7 days/week"),
					_componentTile(context, "1.9", "Extremely Active", "2x daily / hard labor"),
				]
			),

			_componentSection
			(
				context,
				textCol,
				"Physical Activity Level",
				[
					const TextSpan(text: '''When choosing a '''),
					HyperLinker.hyperlinkText("Physical Activity Level (PAL) ", "https://www.fao.org/4/y5686e/y5686e07.htm", context),
					const TextSpan(text: ''', it should be based solely on your job and general movement outside of the gym:''')
				],
				[
					_palCard
					(	context,
						"1. Sedentary / Lightly Active",
						"1.45",
						[
							'''Lifestyle: Desk jobs, students, or remote workers.''', 
							'''Movement: You drive to most places and spend the majority of your day sitting.''', 
							'''Note: Use this if you plan to manually track every gym session or sport in this app.'''
						],
						textCol
					),

					_palCard
					(	context,
						"2. Moderately Active",
						"1.75",
						[
							'''Lifestyle: Jobs that require constant standing or movement (Waiters, Nurses, Retail staff, Teachers).''', 
							'''Movement: You are on your feet for 7+ hours a day, even if you aren't "exercising."'''
						],
						textCol
					),

					_palCard
					(	context,
						"3. Active",
						"2.00",
						[
							'''Lifestyle: High-movement occupations like warehouse workers.''', 
							'''Movement: You rarely sit down during the day and easily clock 15,000+ steps just through your routine.'''
						],
						textCol
					),

					_palCard
					(	context,
						"4. Vigorously Active",
						"2.20",
						[
							'''Lifestyle: Construction workers, farmers, or athletes.''', 
							'''Movement: Heavy manual labor.'''
						],
						textCol
					),
				]
			),

            Utils.header("Formula", 24, FontWeight.w600, color: textCol),
			const SizedBox(height: 20),
            _formulaCard
			(
                context, 
                textColour: textCol, 
                formulaColour: formulaCol, 
                formula: "TDEE = BMR × PAL", 
                example: "1700 × 1.2 = 2,040 kcal"
            ),

			Utils.header("Note", 24, FontWeight.w600, color: textCol, padding: 50),
            _note(context, textCol),
            const SizedBox(height: 100),
        ];
    }

	Widget _componentTile(BuildContext context, String acronym, String title, String subtitle)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return Padding
        (
            padding: const EdgeInsets.only(bottom: 12),
            child: Row
            (
                children: 
                [
                    Container
                    (
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration
                        (
                            color: bmrCol.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center
                        (
                            child: Text
                            (
                                acronym, 
                                style: TextStyle(fontWeight: FontWeight.bold, color: bmrCol, fontSize: 14)
                            ),
                        ),
                    ),
                    const SizedBox(width: 16),
                    Expanded
                    (
                        child: Column
                        (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textCol)),
                                Text(subtitle, style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 14)),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

	Widget _componentSection(BuildContext context, Color textCol, String header, List<InlineSpan> paragraph, List<Widget> components)
	{
		return Column
		(
			children: 
			[
				Utils.header(header, 24, FontWeight.w600, color: textCol),
				const SizedBox(height: 20),

				Text.rich
				(
					TextSpan
					(
						style: TextStyle(fontSize: 16, height: 1.5, color: textCol),
						children: paragraph
					)
				),

				const SizedBox(height: 20),

				for(var component in components)
					component,
			],
		);
	}

    Widget _palCard(BuildContext context, String title, String val, List<String> items, Color textCol)
    {
		return Container
        (
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                color: textCol.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textCol.withOpacity(0.1)),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Row
                    (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: 
                        [
                            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textCol)),
                            Text("PAL $val", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).extension<AppColours>()!.bmr)),
                        ],
                    ),
                    const Divider(height: 24),
                    _bulletList(context, items)
                ],
            ),
        );
    }

    Widget _bulletList(BuildContext context, List<String> items)
    {
        return BulletedList
        (
            listItems: items,
            bulletColor: Theme.of(context).extension<AppColours>()!.text!,
            style: TextStyle(fontSize: 16, color: Theme.of(context).extension<AppColours>()!.text!, height: 1.5),
        );
    }
	
    Widget _formulaCard(BuildContext context, {required Color textColour, required Color formulaColour, required String formula, required String example})
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
                    Text(formula, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: formulaColour, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
                    Text("Example: $example", style: TextStyle(fontSize: 16, color: textColour.withOpacity(0.7))),
                ],
            ),
        );
    }

    Widget _note(BuildContext context, Color textCol)
    {
		final accentColor = Theme.of(context).extension<AppColours>()!.text!.withOpacity(0.3);
		
        return Container
        (
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: BoxDecoration
            (
				border: Border(left: BorderSide(color: accentColor, width: 3)),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text.rich
                    (
                        TextSpan
                        (
                            style: TextStyle(fontSize: 16, height: 1.6, color: textCol),
                            children:
                            [
                                const TextSpan(text: "The "),
                                const TextSpan(text: "1.2 ", style: TextStyle(fontWeight: FontWeight.bold)),
                                const TextSpan(text: "is a standardized constant used in the Mifflin St-Jeor and Harris-Benedict equations to account for the ~20% of energy that your body uses for Thermic Effect of Food (~10%) and "),
                                HyperLinker.hyperlinkText("Non-Exercise Activity Thermogenesis", "https://pubmed.ncbi.nlm.nih.gov/12468415/", context),
                                const TextSpan(text: " (~10%).\n"),
                            ]
                        )
                    ),
                    Text
					(
                        '''Even if you describe yourself as "sedentary," you aren't in a coma. The 1.2 constant acts as a base multiplier and a biological floor for a person who moves at all during the day. But for the majority of people, a more accurate starting point would be 1.45.''',
                        style: TextStyle(fontSize: 16, color: textCol, height: 1.6),
                    ),
                ],
            ),
        );
    }
}