import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class CardioInfo extends StatelessWidget
{
  	const CardioInfo({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold
		(
			backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
			appBar: AppBar(title: const Text("XXX Info")),
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
					const Text('''4. Cardio Burn (Distance Method)'''),
					const Text('''Definition: The energy used during cardiovascular exertion within a specific distance.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Note: When running, the main 2 factors that are taken into consideration when burning calories are your body weight and how far you traveled. Naturally, as you increase speed and deal with air resistance, your caloric expenditure increases, however since those are too variable and are tedious to consistently measure. It's easier to just use the aforementioned variables. "),
								HyperLinker.hyperlinkText("MET values do exist for cardio-based activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
								const TextSpan(text: ", however since MET assumes constant movement, they wouldn't work as well for people who like to take rest breaks. Especially when running on a treadmill at a flat incline where the "),
								HyperLinker.hyperlinkText("energy cost per kilometer is 1 kcal/kg", "https://journals.physiology.org/doi/abs/10.1152/jappl.1963.18.2.367", context),
								const TextSpan(text: ", the below formulas show that difference is negligible enough to ignore. In fact, if you run in the open or on an incline, that 1 kcal/kg would increase and more closely resemble the MET formula's result."),
							]
						)
					),

					const BulletedList
					(
						listItems: ['''Distance Method: Weight in kg * Distance in km * 1''', '''Example (70kg | 10km): 70 * 10 * 1 = 700 kcal''', '''MET Method: (((MET * 3.5 * Weight in kg) / 200) * Duration in minutes)''', '''Example (10 MET | 70kg | 60 min): (((10 * 3.5 * 70) / 200) * 60) = 735 kcal'''],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Since "),
								HyperLinker.hyperlinkText("cycling is more efficient", "https://en.wikipedia.org/wiki/Bicycle_performance", context),
								const TextSpan(text: " due to mechanical assistance and weight support, the cycled distance roughly has to be 3x the distance ran to achieve the same caloric expenditure."),
							]
						)
					),

					const BulletedList
					(
						listItems: ['''Cycling Formula: Weight in kg * Distance in km * 0.3''', '''Example (70kg | 2km): 70 * 2 * 0.3 = 42 kcal'''],
					)
				],
			),
		);
	}
}