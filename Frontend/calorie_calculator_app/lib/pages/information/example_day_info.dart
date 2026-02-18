import 'package:calorie_calculator_app/pages/information/information.dart';
import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ExampleDayInfo extends Information
{
    const ExampleDayInfo({super.key});

    @override
    String get appBarText => "Example Day";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            const Header(text: 'Example Calculation', fontSize: 32, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Text
			(
                '''Use the following formula to determine your caloric intake for training days.''',
                style: TextStyle(fontSize: 18, height: 1.5, color: textCol),
            ),

            const Header(text: 'Formula', fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _masterFormulaCard(context, bmrCol),

            const Header(text: "Example Scenario", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),

            _calculationStep(context, "Sedentary Baseline", "1,700 × 1.45", "2,465 kcal", textCol),
            _calculationStep(context, "Upper Body (40m)", "((5 × 3.5 × 70) / 200) × 40 × 1.2", "294 kcal", textCol),
            _calculationStep(context, "Accessories (30m)", "((5 × 3.5 × 70) / 200) × 30 × 0.7", "129 kcal", textCol),
            _calculationStep(context, "Total Gym Expenditure", "(294 + 129) × 0.8", "338 kcal", textCol),
            _calculationStep(context, "Cardio (2km Run)", "70 × 2 × 1", "140 kcal", textCol),
            _calculationStep(context, "EPOC (Moderate)", "(338 + 140) × 0.10", "48 kcal", textCol),

            const SizedBox(height: 20),
            _finalTotalCard(context, "2,991 kcal", bmrCol, textCol),

			const Header(text: "Note", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _note(context, textCol),

            const SizedBox(height: 100),
        ];
    }

    Widget _masterFormulaCard(BuildContext context, Color bmrCol)
    {
        return Container
        (
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                color: bmrCol.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
            ),
            child:  Text
			(
                "TDEE + Activity Burn + Cardio Burn + EPOC",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'monospace', color: bmrCol),
            ),
        );
    }

    Widget _calculationStep(BuildContext context, String title, String formula, String subtotal, Color textCol)
    {
        return Container
        (
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration
            (
                color: textCol.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
            ),
            child: Row
            (
                children: 
                [
                    Expanded
                    (
                        child: Column
                        (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                                Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: textCol)),
                                Text(formula, style: TextStyle(fontSize: 12, color: textCol.withOpacity(0.6), fontFamily: 'monospace')),
                            ],
                        ),
                    ),
                    Text(subtotal, style: TextStyle(fontWeight: FontWeight.bold, color: textCol)),
                ],
            ),
        );
    }

    Widget _finalTotalCard(BuildContext context, String total, Color bmrCol, Color textCol)
    {
        return Container
        (
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration
            (
                color: bmrCol.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                boxShadow: 
                [
                    BoxShadow(color: bmrCol.withOpacity(0.1), blurRadius: 4),
                ],
            ),
            child: Row
            (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: 
                [
                 	Text("Daily Burn Total", style: TextStyle(color: textCol, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(total, style: TextStyle(color: textCol, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
            ),
        );
    }

    Widget _note(BuildContext context, Color textCol)
    {
        return Container
        (
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: BoxDecoration
            (
                border: Border(left: BorderSide(color: textCol.withOpacity(0.3), width: 4)),
            ),
            child: Text.rich
            (
                TextSpan
                (
                    style: TextStyle(fontSize: 16, height: 1.5, color: textCol),
                    children:
                    [
						const TextSpan(text: '''To double check this value, go to '''),
						HyperLinker.hyperlinkText("BMR Calculator", "https://www.calculator.net/bmr-calculator.html?cage=25&csex=m&cheightfeet=5&cheightinch=10&cpound=160&cheightmeter=180&ckg=70&cmop=0&coutunit=c&cformula=m&cfatpct=20&ctype=metric&x=Calculate", context),
						const TextSpan(text: ''' and put in a 25 year old Male that weighs 70kg and is 180cm tall.\n\nAnd you'll see that the value provided here is very close to the value associated with "Intense exercise 6-7 times/week".\n\nWhich makes sense, because if you did this intense workout every single day, you definitely would need around 3,000 calories everyday to retain basic bodily functions.'''),
                    ],
                ),
            ),
        );
    }
}