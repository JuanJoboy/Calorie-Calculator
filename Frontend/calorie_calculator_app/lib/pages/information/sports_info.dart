import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class SportsInfo extends StatelessWidget
{
  	const SportsInfo({super.key});

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
					const Text('''3. Weightlifting Burn (MET Method)'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Definition: The cells in your muscles use oxygen to help create the energy needed to move your muscles. One "),
								HyperLinker.hyperlinkText("MET", "https://www.healthline.com/health/what-are-mets", context),
								const TextSpan(text: " is defined as the consumption of 3.5 milliliters of oxygen per kilogram of body weight per minute. So, for example, if you weigh 70kg, you consume about 245 milliliters of oxygen per minute while you're at rest (70 kg x 3.5 mL). And with this factor, the intensity of a physical activity can be measured. So if an exercise has a MET of 5, then it means that you are using 5x the energy you normally consume at rest."),
							]
						)
					),
					
					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''Sport''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Formula: (((MET * 3.5 * Weight in kg) / 200) * Duration in minutes)''', '''Example (5 MET | 70kg | 90 min): (((5 * 3.5 * 70) / 200) * 90) = 551 kcal'''],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "For the MET formula to work, it assumes constant work, so the above formula works well for sports and other "),
								HyperLinker.hyperlinkText("continuous activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
								const TextSpan(text: " where you can easily track how long you actually did an activity for. For activities that incorporate lots of rest (like weightlifting), then multiplying by 0.8 creates a leniency factor to accommodate for the rest periods."),
								const TextSpan(text: "Additionally for weightlifting, some parts of your body will burn more calories than other parts. "),
								HyperLinker.hyperlinkText("Doing a bicep curl will use significantly less energy than a full body squat.", "https://pmc.ncbi.nlm.nih.gov/articles/PMC5524349/", context),
								const TextSpan(text: " So for simplicity, this app splits up every muscle group into 3 sections"),
							]
						)
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''1. Upper Body''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Definition: Compound movements that target multiple muscles for the upper body and back area.''', '''Examples: Bench Press, Overhead Press, Dips, Push-ups, Pull-ups, Chin-ups, Bent-over Rows, Lat Pulldown, Cable Rows'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''2. Accessories''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Definition: Isolated movements that only target 1-2 muscle groups.''', '''Examples: Bicep Curl, Tricep Cable Pushdown, Lateral Raise, Leg Extensions, Leg Curl, Calf Raise, Crunches'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''3. Lower Body''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Definition: Compound movements that target multiple muscles for the lower body and back area.''', '''Examples: Squats, Deadlifts, Lunges, Bulgarian Split Squats, Step-ups.''']
					),

					const Text("The metabolic cost of an exercise is determined by the volume of muscle mass activated and the total mechanical work performed. Small isolated muscle movements are the most energy efficient, while large scale compound movements, particularly in the lower body elicit the highest cardiovascular and anaerobic demand."),
				],
			),
		);
	}
}