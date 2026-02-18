import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleBulkInfo extends Information
{
    const ExampleBulkInfo({super.key});

    @override
    String get appBarText => "Example Bulk";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            const Header(text: 'Example Weekly Bulk', fontSize: 32, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),

            _goalCard(context, bmrCol, textCol),

            const Header(text: "Weekly Breakdown", fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),

            _bulkDayRow(context, "Legs + Accessories (2x)", "3,011", "3,511", textCol, bmrCol),
            _bulkDayRow(context, "Upper + Accessories (2x)", "2,991", "3,491", textCol, bmrCol),
            _bulkDayRow(context, "Rest Days (3x)", "2,465", "2,965", textCol, bmrCol),

            const SizedBox(height: 20),
            _weeklyTotalCard(context, "19,399", "22,899", textCol, bmrCol),

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
                        "Goal: Gain 450g per Week",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: bmrCol),
                    ),
                    const SizedBox(height: 8),
                    Text
                    (
                        "To gain 450g of body mass, you must create a cumulative weekly surplus of 3,500 calories (approx. +500 calories per day).",
                        style: TextStyle(fontSize: 16, height: 1.4, color: textCol),
                    ),
                ],
            ),
        );
    }

    Widget _bulkDayRow(BuildContext context, String title, String tdee, String intake, Color textCol, Color bmrCol)
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
                            _mathColumn("Surplus", "500", bmrCol),
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
                            Text("+3,500", style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: 20)),
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
            child: Text
            (
                "Energy Storage: If you are exercising consistently, a portion of this surplus is stored as muscle glycogen and tissue. If sedentary, the vast majority is stored as fat.",
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, height: 1.5, color: textCol),
            ),
        );
    }
}