import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';

class InformationPage extends StatelessWidget
{
	const InformationPage({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Center
		(
			child: SingleChildScrollView
			(
				child: Column
				(
					children:
					[
						bmr(),
						tdee(),
						weightLiftingBurn(),
						cardioBurn(),
						epoc(),
						summary(),
						gainWeight(),
						loseWeight()
						// Add references and make them open the website. if u do [1] as ur referencing, then see if when clicking on that, it'll either take u to the reference section or straight to website
					],
				),
			)
		);
  	}

	Widget bmr()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''1. Basal Metabolic Rate (BMR)'''),
					Text('''**Definition:** Your "Coma" burn; the energy required to maintain basic life functions at rest.'''),
					
					BulletedList
					(
						listItems: ['''Male Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) + 5''', '''Example (65kg | 165cm | 20 years | Male): (10 * 65) + (6.25 * 165) - (5 * 20) + 5 = 1586''', '''Female Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) - 161''', '''Example (65kg | 165cm | 20 years | Female): (10 * 65) + (6.25 * 165) - (5 * 20) - 161 = 1420'''],
					),

					Text('''**Note:** The Mifflin-St Jeor Equation is the current clinical gold standard for estimating BMR. Established in 1990, it replaced the older Harris-Benedict formula because it more accurately reflects modern body compositions and sedentary lifestyles. While highly reliable for the average population, it may underestimate needs for highly muscular individuals or overestimate for those with high body fat percentages, as muscle tissue is more metabolically active than fat.''')
				],
			),
		);
	}

	Widget tdee()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''2. Total Daily Energy Expenditure (TDEE)'''),
					Text('''**Definition:** Includes NEAT (Non-Exercise Activity Thermogenesis) like walking, university, and general movement.'''),
					
					BulletedList
					(
						listItems: ['''Formula: BMR * 1.2''', '''Example: 1600 * 1.2 = 1,920 kcal'''],
					),

					Text('''**Note:** The **1.2** is a standardized constant used in the **Mifflin St-Jeor** and **Harris-Benedict** equations to account for the **Thermic Effect of Food (TEF)** and **Non-Exercise Activity Thermogenesis (NEAT)**.'''),

					BulletedList
					(
						listItems: ['''- **TEF (~10%):** The energy your body uses to chew, swallow, digest, and process nutrients.''', '''- **NEAT (~10%):** The energy used for everything that isn't sleeping or intentional exercise. This includes walking to uni, standing in line, fidgeting, and maintaining posture while sitting in lectures.'''],
					),

					Text('''Even if you describe yourself as "sedentary," you aren't in a coma. Multiplying BMR by 1.2 is the scientific floor for a person who moves at all during the day.''')
				],
			),
		);
	}

	Widget weightLiftingBurn()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''3. Weightlifting Burn (MET Method)'''),
					Text('''Definition: The cells in your muscles use oxygen to help create the energy needed to move your muscles. One MET is defined as the consumption of 3.5 milliliters of oxygen per kilogram of body weight per minute. So, for example, if you weigh 65kg, you consume about 227.5 milliliters of oxygen per minute while you're at rest (65 kg x 3.5 mL). And with this factor, the intensity of a physical activity can be measured. So if an exercise has a MET of 5, then it means that you are using 5x the energy you normally consume at rest.'''),
					
					BulletedList
					(
						listItems: ['''Formula: (((MET * 3.5 * Weight in kg) / 200) * Duration in minutes) * 0.8''', '''Example (5 MET | 65kg | 90 min): (((5 * 3.5 * 65) / 200 )* 90) * 0.8 = 409.5 kcal'''],
					),

					Text('''Note: Since you have rests between lifts, the total is multiplied by 0.8 as a leniency factor.''')
				],
			),
		);
	}

	Widget cardioBurn()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''4. Cardio Burn (Distance Method)'''),
					Text('''Definition: Energy used during cardiovascular exertion.'''),
					Text('''Note: When running, your speed minimally impacts your caloric expenditure. The main factor is your body weight and how far you traveled. Since cycling is more efficient due to mechanical assistance and weight support, the cycled distance roughly has to be 3x the distance ran to achieve the same expenditure.'''),

					BulletedList
					(
						listItems: ['''Running Formula: Weight in kg * Distance in km''', '''Example (65kg | 2km): 65 * 2 = 130 kcal''', '''Cycling Formula: Weight in kg * Distance in km * 0.3''', '''Example (65kg | 2km): 65 * 2 * 0.3 = 39 kcal'''],
					)
				],
			),
		);
	}

	Widget epoc()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''5. Recovery Burn (EPOC)'''),
					Text('''Definition: Excess Post-exercise Oxygen Consumption; the "afterburn" from high-intensity training.'''),
					
					BulletedList
					(
						listItems: ['''Formula: (Lift Burn + Run Burn) * 0.10''', '''Example: (390 + 130) * 0.1 = 52'''],
					),
					
					Text('''Note: The 0.1 (10%) comes from clinical studies on Excess Post-exercise Oxygen Consumption.'''),
					
					BulletedList
					(
						listItems: ['''Aerobic Exercise: Low-intensity cardio (like a slow jog) typically has an EPOC of about 3% to 5%.''', '''Resistance Training: Heavy lifting—especially sessions involving compound movements (Bench, Rows) and high intensity (RPE 10)—creates a significantly higher metabolic disturbance.''', '''The Research: Studies on heavy resistance training consistently show an EPOC effect ranging from 6% to 15% of the total calories burned during the session.''', '''Selection: 10% is used as a reliable middle-ground for someone doing high-intensity work. It accounts for the energy your body spends over the following 12-24 hours returning your heart rate, body temperature, and hormone levels to baseline.'''],
					)
				],
			),
		);
	}

	Widget summary()
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text('''Daily Calculation Summary'''),
					const Text('''Use the following formula to determine intake requirements for training days: Total Gym Day Burn = (**BMR** * **1.2**) + **Lift Burn** + **Run Burn** + **EPOC**'''),

					const Text('''Example Scenario (65kg User)'''),

					Table
					(
						border: TableBorder.all(color: Colors.grey),
						children:
						[
							TableRow
							(
								children:
								[
									headerOption("Component"),
									headerOption("Calculation"),
									headerOption("Subtotal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Sedentary Baseline"),
									textOption("1,600 * 1.2"),
									textOption("1,920 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weight Lifting (90 minutes)"),
									textOption("(5 * 65 * (90 / 60)) * 0.8"),
									textOption("390 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Cardio (2km)"),
									textOption("65 * 2"),
									textOption("130 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("EPOC (High Intensity)"),
									textOption("(390 + 130) * 0.10"),
									textOption("52 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Total Burn"),
									textOption("(1,600 * 1.2) + ((5 * 65 * 1.5) * 0.8) + (65 * 2) + ((390 + 130) * 0.10)"),
									textOption("2,492 kcal")
								]
							)
						],
					)
				]
			),
		);
	}

	Widget gainWeight()
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text("Example Weekly Bulk Breakdown"),

					Table
					(
						children:
						[
							TableRow
							(
								children:
								[
									headerOption("Day Type"),
									headerOption("Total TDEE (kcal)"),
									headerOption("Caloric Intake (kcal)"),
									headerOption("Daily Difference (kcal)")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Gym Day (3x)"),
									textOption("2,492"),
									textOption("2,992"),
									textOption("+1500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (4x)"),
									textOption("1,920"),
									textOption("2,420"),
									textOption("+2000")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("15,156"),
									textOption("18,656"),
									textOption("+3500")
								]
							)
						],
					)
				],
			),
		);
	}

	Widget loseWeight()
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text("Example Weekly Cut Breakdown"),
					
					Table
					(
						children:
						[
							TableRow
							(
								children:
								[
									headerOption("Day Type"),
									headerOption("Total TDEE (kcal)"),
									headerOption("Caloric Intake (kcal)"),
									headerOption("Daily Difference (kcal)")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Gym Day (3x)"),
									textOption("2,492"),
									textOption("1,700"),
									textOption("-792")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (4x)"),
									textOption("1,920"),
									textOption("1,600"),
									textOption("-320")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("15,156"),
									textOption("11,500"),
									textOption("-3,656")
								]
							)
						],
					)
				],
			),
		);
	}

	Widget headerOption(String text)
	{
		return TableCell
		(
			verticalAlignment: TableCellVerticalAlignment.middle,
			child: Padding
			(
				padding: const EdgeInsetsGeometry.all(8),
				child: Center
				(
					child: Text
					(
						text,
						textAlign: TextAlign.center,
						style: const TextStyle
						(
							fontWeight: FontWeight.bold,
							fontSize: 15
						),
					)
				)
			),
		);
	}

	Widget textOption(String text)
	{
		return TableCell
		(
			verticalAlignment: TableCellVerticalAlignment.middle,
			child: Padding
			(
				padding: const EdgeInsetsGeometry.all(8),
				child: Center
				(
					child: Text
					(
						text,
						textAlign: TextAlign.center,
					)
				)
			)
		);
	}
}