import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator/pages/information/information.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:flutter/material.dart';

class EPOCInfo extends Information
{
    const EPOCInfo({super.key});

    @override
    String get appBarText => "EPOC Info";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;
        final col1 = Theme.of(context).extension<AppColours>()!.aerobicBackgroundColour!;
        final col2 = Theme.of(context).extension<AppColours>()!.anaerobicBackgroundColour!;
        final col3 = Theme.of(context).extension<AppColours>()!.maximalBackgroundColour!;

        return
        [
            const Header(text: 'Recovery Burn', fontSize: 32, fontWeight: FontWeight.bold),

            const Header(text: "Definition", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            Text
			(
                '''EPOC is the Excess Post-exercise Oxygen Consumption process that the body does after exercising.''',
                style: TextStyle(fontSize: 18, height: 1.5, color: textCol),
            ),
            const SizedBox(height: 20),
            
            _processCard(context, textCol),

            const Header(text: "The 3 Tiers of Intensity", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            Text.rich
            (
                TextSpan
                (
                    style: TextStyle(fontSize: 16, color: textCol),
                    children:
                    [
                        HyperLinker.hyperlinkText("There are 3 tiers that an EPOC can be", "https://pubmed.ncbi.nlm.nih.gov/17101527/", context),
                        const TextSpan(text: ''', and they're determined by your perceived intensity rather than duration:'''),
                    ]
                )
            ),
            const SizedBox(height: 20),

            _tierCard(context, "1. Light / Aerobic", "5%", "Light weights, walking.", "Metabolic disturbance is minimal.", textCol, col1),
            _tierCard(context, "2. Moderate / Anaerobic", "10%", "Heavy resistance, circuit training.", "Protein synthesis demands significant recovery energy.", textCol, col2),
            _tierCard(context, "3. Vigorous / Maximal", "13%", "Lifting to failure, sprinting.", "Largest oxygen debt and metabolic afterburn.", textCol, col3),

            const Header(text: "Formula", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _formulaCard
			(
                context,
                formula: "(Activity Burn + Cardio Burn) × EPOC %",
                example: "(551 + 700) × 0.13 = 163 kcal",
                textColour: textCol,
                formulaColour: bmrCol,
            ),
            
            const SizedBox(height: 20),
            _note(context, textCol),

            const SizedBox(height: 100),
        ];
    }

    Widget _processCard(BuildContext context, Color textCol)
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
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text.rich
                    (
                        TextSpan
                        (
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textCol),
                            children: 
                            [
                                const TextSpan(text: "After a workout, your body requires extra energy to return to its resting metabolic state.\n"),
                                HyperLinker.hyperlinkText("This recovery process involves:", "https://blog.nasm.org/excess-post-exercise-oxygen-consumption", context),
                            ]
                        )
                    ),
                    const SizedBox(height: 8),
                    BulletedList
                    (
                        listItems: const 
                        [
                            "Resynthesize ATP and Phosphocreatine.",
                            "Metabolizing Lactate back into glucose.",
                            "Restoring Blood Oxygen (Hemoglobin/Myoglobin).",
                            "Repairing cells and cooling your core temperature."
                        ],
                        bulletColor: textCol,
                        style: TextStyle(fontSize: 14, color: textCol, height: 1.4),
                    ),
                ],
            ),
        );
    }

    Widget _tierCard(BuildContext context, String title, String percentage, String examples, String impact, Color textCol, Color sideCol)
    {
        return Container
        (
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                color: sideCol.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: sideCol, width: 4)),
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
                                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textCol)),
                                const SizedBox(height: 4),
                                Text("Examples: $examples", style: TextStyle(fontSize: 13, color: textCol.withOpacity(0.7))),
                                Text("Impact: $impact", style: TextStyle(fontSize: 13, color: textCol.withOpacity(0.7), fontStyle: FontStyle.italic)),
                            ],
                        ),
                    ),
                    const SizedBox(width: 12),
                    Text(percentage, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: sideCol)),
                ],
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
                    const SizedBox(height: 8),
                    Text("Example: $example", style: TextStyle(fontSize: 14, color: textColour.withOpacity(0.7))),
                ],
            ),
        );
    }

    Widget _note(BuildContext context, Color textCol)
    {
        return Padding
        (
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text
			(
                "So by simply training harder in a shorter amount of time, you can end up burning more calories.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: textCol),
            ),
        );
    }
}