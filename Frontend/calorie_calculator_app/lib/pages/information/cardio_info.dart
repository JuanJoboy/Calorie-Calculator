import 'package:calorie_calculator/pages/information/information.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:flutter/material.dart';

class CardioInfo extends Information
{
    const CardioInfo({super.key});

    @override
    String get appBarText => "Cardio Info";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final bmrCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            const Header(text: 'Cardio Burn', fontSize: 32, fontWeight: FontWeight.bold),

            const Header(text: "Definition", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            Text
			(
                '''The energy used during cardiovascular exertion within a specific distance.''',
                style: TextStyle(fontSize: 18, height: 1.5, color: textCol),
            ),

			const Header(text: "Note", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _note(context, textCol),

			_componentSection
			(
				context,
				textCol,
				"Method Comparison",
				[
					const TextSpan(text: "When running on a treadmill at a flat incline where the "),
					HyperLinker.hyperlinkText("energy cost per kilometer is 1 kcal/kg", "https://journals.physiology.org/doi/abs/10.1152/jappl.1963.18.2.367", context),
					const TextSpan(text: ", the below formulas show that difference is negligible enough to ignore.\n\nIn fact, if you run in the open or on an incline, that 1 kcal/kg would increase and more closely resemble the MET formula's result."),
				]
			),

			const Header(text: "Running Formula", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _comparisonCard(context, textCol, bmrCol),

			_componentSection
			(
				context,
				textCol,
				"Cycling Efficiency",
				[
					const TextSpan(text: "Since "),
					HyperLinker.hyperlinkText("cycling is more efficient", "https://en.wikipedia.org/wiki/Bicycle_performance", context),
					const TextSpan(text: " due to mechanical assistance and weight support, the cycled distance roughly has to be 3x the distance ran, in order to achieve the same caloric expenditure."),
				]
			),

			const Header(text: "Cycling Formula", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
            _formulaCard
			(
                context,
                formula: "Weight × Distance × 0.33",
                example: "70kg, 30km: 693 kcal",
                textColour: textCol,
                formulaColour: bmrCol,
            ),

			_componentSection
			(
				context,
				textCol,
				"Swimming Resistance",
				[
					const TextSpan(text: "Swimming is significantly more intensive per kilometer than running due to "),
					HyperLinker.hyperlinkText("water being 800x denser than air", "https://blog.myswimpro.com/2023/01/23/is-water-really-800-times-more-dense-than-air-we-did-the-math/", context),
					const TextSpan(text: ". Because of this constant resistance and the mechanical inefficiency of moving through a fluid, you burn roughly 4x the calories per kilometer compared to running."),
					const TextSpan(text: ". Because of this constant resistance and the mechanical inefficiency of moving through a fluid, "),
					HyperLinker.hyperlinkText("you burn roughly 4x the calories per kilometer compared to running.", "https://www.loseit.com/articles/how-much-swimming-equals-running-5-miles/", context),
				]
			),

			const Header(text: "Swimming Formula", fontSize: 24, fontWeight: FontWeight.w600),
			const SizedBox(height: 20),
			_formulaCard
			(
				context,
				formula: "Weight × Distance × 4.0",
				example: "70kg, 1km: 280 kcal",
				textColour: textCol,
				formulaColour: bmrCol,
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

    Widget _comparisonCard(BuildContext context, Color textCol, Color bmrCol)
    {
        return Container
        (
            decoration: BoxDecoration
            (
                color: bmrCol.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
            ),
            child: Column
            (
                children: 
                [
                    _comparisonRow(context, "Distance Method", "Weight × Distance × 1.0", "Example: 70kg, 10km: 700kcal", "700 kcal", textCol, bmrCol),
                    _comparisonRow(context, "MET Method", "((MET × 3.5 × Weight) / 200) × Duration", "Example: 10 MET, 70kg, 60 min: 735 kcal", "735 kcal", textCol, bmrCol, isLast: true),
                ],
            ),
        );
    }

    Widget _comparisonRow(BuildContext context, String title, String formula, String example, String result, Color textCol, Color bmrCol, {bool isLast = false})
    {
        return Container
        (
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration
            (
                border: isLast ? null : Border(bottom: BorderSide(color: textCol.withOpacity(0.1))),
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
                            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textCol)),
                            Text(result, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: bmrCol)),
                        ],
                    ),
                    const SizedBox(height: 8),
                    Text(formula, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: bmrCol, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
					Text(example, style: TextStyle(fontSize: 14, color: textCol.withOpacity(0.7))),
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
                    Text("Example $example", style: TextStyle(fontSize: 14, color: textColour.withOpacity(0.7))),
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
						const TextSpan(text: "When running, the main 2 factors that are taken into consideration when burning calories are your body weight and how far you traveled.\n\nNaturally, as you increase speed and deal with air resistance, your caloric expenditure increases, however since those are too variable and are tedious to consistently measure. It's simpler to just use the aforementioned variables. \n\n"),
						HyperLinker.hyperlinkText("MET values do exist for cardio-based activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
						const TextSpan(text: ", however since MET assumes constant movement, they wouldn't work as well for people who like to take rest breaks."),
                    ],
                ),
            ),
        );
    }
}