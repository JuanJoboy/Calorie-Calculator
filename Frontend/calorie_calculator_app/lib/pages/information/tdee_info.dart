import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class TDEEInfo extends StatelessWidget
{
  	const TDEEInfo({super.key});

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
					const Text('''2. Total Daily Energy Expenditure (TDEE)'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Definition: ", style: TextStyle(fontWeight: FontWeight.bold)),
								const TextSpan(text: "The total number of calories you burn in a given day. Your "),
								HyperLinker.hyperlinkText("TDEE is the sum of four metabolic components:", "https://steelfitusa.com/blogs/health-and-wellness/calculate-tdee", context)
							]
						)
					),

					const BulletedList
					(
						listItems: ['''Basal Metabolic Rate (BMR): Your "Coma Burn."''', '''Thermic Effect of Food (TEF): Energy used for digestion.''', '''Non-Exercise Activity Thermogenesis (NEAT): Energy from daily movement (walking, standing, chores).''', '''Thermic Effect of Activity (TEA): Energy from intentional exercise (gym, sports).'''],
					),
					
					const Text('''Standard calculators use generic multipliers that bundle your gym time into your lifestyle. To ensure high fidelity, this app isolates TEA to avoid double dipping. So instead of using the traditional multipliers of:'''),

					const BulletedList
					(
						listItems: ['''Sedentary (little to no exercise + work a desk job) = 1.2''', '''Lightly Active (light exercise 1-3 days / week) = 1.375''', '''Moderately Active (moderate exercise 3-5 days / week) = 1.55''', '''Very Active (heavy exercise 6-7 days / week) = 1.725''', '''Extremely Active (very heavy exercise, hard labor job, training 2x / day) = 1.9'''],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Choose a '''),
								HyperLinker.hyperlinkText("Physical Activity Level (PAL) ", "https://www.fao.org/4/y5686e/y5686e07.htm", context),
								const TextSpan(text: '''based solely on your job and general movement outside of the gym:''')
							]
						)
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''1. Sedentary / Lightly Active (PAL 1.45)''', style: TextStyle(fontWeight: FontWeight.bold,),)),
					const BulletedList
					(
						listItems: ['''Lifestyle: Desk jobs, students, or remote workers.''', '''Movement: You drive to most places and spend the majority of your day sitting.''', '''Note: Use this if you plan to manually track every gym session or sport in this app.'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''2. Moderately Active (PAL 1.75)''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Lifestyle: Jobs that require constant standing or movement (Waiters, Nurses, Retail staff, Teachers).''', '''Movement: You are on your feet for 7+ hours a day, even if you aren't "exercising."'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''3. Active (PAL 2.00)''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Lifestyle: High-movement occupations like warehouse workers.''', '''Movement: You rarely sit down during the day and easily clock 15,000+ steps just through your routine.'''],
					),

					const Align(alignment: AlignmentGeometry.centerLeft, child: Text('''4. Vigorously Active (PAL 2.20)''', style: TextStyle(fontWeight: FontWeight.bold))),
					const BulletedList
					(
						listItems: ['''Lifestyle: Construction workers, farmers, or athletes.''', '''Movement: Heavy manual labor.'''],
					),

					const Text('''Formulas & Mathematical Constants''', style: TextStyle(fontWeight: FontWeight.bold)),
					const BulletedList
					(
						listItems: ['''Formula: BMR * PAL''', '''Example: 1700 * 1.2 = 2,040 kcal'''],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Note: ", style: TextStyle(fontWeight: FontWeight.bold)),
								const TextSpan(text: "The "),
								const TextSpan(text: "1.2 ", style: TextStyle(fontWeight: FontWeight.bold)),
								const TextSpan(text: "is a standardized constant used in the Mifflin St-Jeor and Harris-Benedict equations to account for the ~20% of energy that your body uses for Thermic Effect of Food (~10%) and "),
								HyperLinker.hyperlinkText("Non-Exercise Activity Thermogenesis", "https://pubmed.ncbi.nlm.nih.gov/12468415/", context),
								const TextSpan(text: " (~10%)."),
							]
						)
					),

					const Text('''Even if you describe yourself as "sedentary," you aren't in a coma. The 1.2 constant acts as a base multiplier and a biological floor for a person who moves at all during the day. But for the majority of people, a more accurate starting point would be 1.45.'''),
				],
			),
		);
	}
}