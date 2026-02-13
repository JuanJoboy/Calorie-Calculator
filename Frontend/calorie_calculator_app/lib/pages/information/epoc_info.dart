import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class EPOCInfo extends StatelessWidget
{
  	const EPOCInfo({super.key});

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
					const Text('''5. Recovery Burn (EPOC)'''),
					const Text('''Definition: Excess Post-exercise Oxygen Consumption; the "afterburn" from high-intensity training. It is the measurable increase in oxygen intake following strenuous activity. After a workout, your body requires extra energy to return to its resting metabolic state. This recovery process involves replenishing energy stores, balancing hormones, repairing cells, and cooling the core body temperature.'''),
					
					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''How it Works: During exercise, you create an "oxygen debt." Post-workout, '''),
								HyperLinker.hyperlinkText("the body consumes more oxygen than usual to:", "https://blog.nasm.org/excess-post-exercise-oxygen-consumption", context),
							]
						)
					),

					const BulletedList
					(
						listItems: ['''Resynthesize ATP and Phosphocreatine: Restoring the immediate energy used for muscle contractions.''', '''Metabolize Lactate: Converting lactate produced during anaerobic work back into glucose.''', '''Restore Blood Oxygen: Re-oxygenating hemoglobin and myoglobin.'''],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								HyperLinker.hyperlinkText("There are 3 tiers that an EPOC can be", "https://pubmed.ncbi.nlm.nih.gov/17101527/", context),
								const TextSpan(text: ''', and they are determined by the exercise intensity rather than duration:'''),
							]
						)
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''1. Light / Aerobic''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''EPOC Factor: 5%''', '''Examples: Light weights or walking.''', '''Impact: Metabolic disturbance is minimal.'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''2. Moderate / Anaerobic''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''EPOC Factor: 10%''', '''Examples: Heavy resistance training or circuit training.''', '''Impact: Protein synthesis demands significant recovery energy.'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''3. Vigorous / Maximal''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''EPOC Factor: 13%''', '''Examples: Lifting to failure or sprinting.''', '''Impact: Creates the largest oxygen debt and the highest metabolic afterburn.'''],
					),

					const Text("So by simply training harder in a shorter amount of time, you can end up burning more calories."),

					const BulletedList
					(
						listItems: ['''Formula: (Activity Burn + Run Burn) * EPOC Level''', '''Example: (551 + 700) * 0.13 = 163'''],
					),
				],
			),
		);
	}
}