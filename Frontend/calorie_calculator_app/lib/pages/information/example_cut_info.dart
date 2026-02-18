import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleCutInfo extends Information
{
    const ExampleCutInfo({super.key});

    @override
    String get appBarText => "Example Cut";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            const Header(text: 'Example Weekly Cut', fontSize: 32, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),

            _goalCard(context, bmrCol, textCol),

            const Header(text: "Weekly Breakdown", fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),

            _bulkDayRow(context, "Legs + Accessories (2x)", "3,011", "511", "2,500", textCol, bmrCol),
            _bulkDayRow(context, "Upper + Accessories (2x)", "2,991", "591", "2,400", textCol, bmrCol),
            _bulkDayRow(context, "Rest Days (3x)", "2,465", "465", "2,000", textCol, bmrCol),

            const SizedBox(height: 20),
            _weeklyTotalCard(context, "19,399", "15,800", textCol, bmrCol),

			const Header(text: "Note", fontSize: 24, fontWeight: FontWeight.w600),
            _note(context, textCol),

            const SizedBox(height: 100),
        ];
    }

    Widget _goalCard(BuildContext context, Color bmrCol, Color textCol)
    {
        return Container
        (
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration
            (
                color: bmrCol.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: bmrCol.withOpacity(0.3)),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: 
                [
                    Text
                    (
                        "Goal: Lose 450g per Week",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: bmrCol),
                    ),
                    const SizedBox(height: 8),
                    Text
                    (
                        "To lose 450g of body mass, you must be in a cumulative weekly deficit of 3,500 calories (approx. -500 calories per day).",
                        style: TextStyle(fontSize: 16, height: 1.4, color: textCol),
                    ),
                ],
            ),
        );
    }

    Widget _bulkDayRow(BuildContext context, String title, String tdee, String deficit, String intake, Color textCol, Color bmrCol)
    {
        return Container
        (
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                color: textCol.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textCol)),
                    const SizedBox(height: 12),
                    Row
                    (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: 
                        [
                            _mathColumn("Daily TDEE", tdee, textCol),
                            Text("+", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textCol)),
                            _mathColumn("Deficit", deficit, bmrCol),
                            Text("=", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textCol)),
                            _mathColumn("Target", intake, bmrCol, highlight: true),
                        ],
                    ),
                ],
            ),
        );
    }

    Widget _mathColumn(String label, String value, Color color, {bool highlight = false})
    {
        return Column
        (
            children: 
            [
                Text(label, style: TextStyle(fontSize: 17, color: color.withOpacity(0.8), fontWeight: FontWeight.bold)),
                Text
                (
                    value,
                    style: TextStyle
                    (
                        fontSize: 17,
                        fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                        color: color,
                        fontFamily: 'monospace',
                    ),
                ),
            ],
        );
    }

    Widget _weeklyTotalCard(BuildContext context, String tdeeTotal, String intakeTotal, Color textCol, Color bmrCol)
    {
        return Container
        (
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration
            (
                color: bmrCol.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                boxShadow: 
                [
                    BoxShadow(color: bmrCol.withOpacity(0.1), blurRadius: 4),
                ],
            ),
            child: Column
            (
                children: 
                [
                    Text
                    (
                        "Weekly Cumulative Total",
                        style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    Row
                    (
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                            _mathColumn("Total TDEE", tdeeTotal, textCol, highlight: true),
                            Text("-3,599", style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: 20)),
                            _mathColumn("Total Intake", intakeTotal, textCol, highlight: true),
                        ],
                    ),
                ],
            ),
        );
    }

    Widget _note(BuildContext context, Color textCol)
    {
        return Container
        (
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                border: Border(left: BorderSide(color: textCol.withOpacity(0.3), width: 4)),
            ),
            child: Text.rich
			(
				style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, height: 1.5, color: textCol),
				TextSpan
				(
					children:
					[
						const TextSpan(text: '''Energy Storage: When the body lacks 500 calories from food to perform its daily functions, it triggers '''),
						HyperLinker.hyperlinkText("lipolysis", "https://www.revitalizemedspa.ca/what-is-lipolysis-understanding-the-science-behind-fat-burning", context),
						const TextSpan(text: ''' (breaking down stored fat) to make up the energy difference. For high-intensity athletes, managing '''),
						HyperLinker.hyperlinkText("glycogen levels", "https://inscyd.com/article/muscle-glycogen-and-exercise-all-you-need-to-know/", context),
						const TextSpan(text: ''' is critical to avoid getting fatigued easily.''')
					]
				)
			),
        );
    }
}