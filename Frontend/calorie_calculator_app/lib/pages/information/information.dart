import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:url_launcher/url_launcher.dart';

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
				physics: const BouncingScrollPhysics(),
				child: Column
				(
					children:
					[
						disclaimer(),
						bmr(context),
						tdee(context),
						weightLiftingBurn(context),
						cardioBurn(context),
						epoc(context),
						summary(context),
						gainWeight2(context),
						gainWeight(),
						loseWeight2(context),
						loseWeight(),
						nutrition(context)
					],
				),
			)
		);
  	}

	Widget disclaimer()
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text('''Disclaimer'''),
					Text('''The caloric data provided are simply mathematical estimations, not clinical measurements. Individual factors (genetics, body composition, hormonal health, etc) are too variable and are beyond the scope of this calculator. This means that these figures serve as a guide rather than an absolute value. Use these results at your own discretion. For precise nutritional or medical planning, consult a certified professional.'''),
				],
			),
		);
	}

	Widget bmr(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text('''1. Basal Metabolic Rate (BMR)'''),

					const Text.rich
					(
						TextSpan
						(
							children:
							[
								TextSpan(text: "Definition: ", style: TextStyle(fontWeight: FontWeight.bold)),
								TextSpan(text: '''Your "Coma" burn; the energy required to maintain basic life functions at rest.'''),
							]
						)
					),
					
					const BulletedList
					(
						listItems: ['''Male Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) + 5''', '''Example (70kg | 180cm | 25 years | Male): (10 * 70) + (6.25 * 180) - (5 * 25) + 5 = 1705''', '''Female Formula: (10 * Weight in kg) + (6.25 * Height in cm) - (5 * Age in years) - 161''', '''Example (65kg | 165cm | 25 years | Female): (10 * 65) + (6.25 * 165) - (5 * 25) - 161 = 1395'''],
					),
					
					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: "Note: ", style: TextStyle(fontWeight: FontWeight.bold)),
								const TextSpan(text: "The "),
								hyperlinkText("Mifflin-St Jeor Equation", "https://pubmed.ncbi.nlm.nih.gov/2305711/", context),
								const TextSpan(text: " is the current clinical gold standard for estimating "),
								hyperlinkText("BMR", "https://www.healthline.com/health/how-to-calculate-your-basal-metabolic-rate", context),
								const TextSpan(text: ". Established in 1990, it replaced the older "),
								const TextSpan(text: "Harris-Benedict Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "because it more accurately reflects modern body compositions and sedentary lifestyles. While highly reliable for the average population, it may underestimate needs for highly muscular individuals or overestimate for those with high body fat percentages, as muscle tissue is more metabolically active than fat. Which is where the "),
								const TextSpan(text: "Katch-McArdle Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "comes in handy. However for simplicity and to accommodate the general population, the "),
								const TextSpan(text: "Mifflin-St Jeor Equation ", style: TextStyle(fontStyle: FontStyle.italic)),
								const TextSpan(text: "is used in the app."),
							]
						)
					),					
				],
			),
		);
	}

	Widget tdee(BuildContext context)
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
								hyperlinkText("TDEE is the sum of four metabolic components:", "https://steelfitusa.com/blogs/health-and-wellness/calculate-tdee", context)
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
								hyperlinkText("Physical Activity Level (PAL) ", "https://www.fao.org/4/y5686e/y5686e07.htm", context),
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
								hyperlinkText("Non-Exercise Activity Thermogenesis", "https://pubmed.ncbi.nlm.nih.gov/12468415/", context),
								const TextSpan(text: " (~10%)."),
							]
						)
					),

					const Text('''Even if you describe yourself as "sedentary," you aren't in a coma. The 1.2 constant acts as a base multiplier and a biological floor for a person who moves at all during the day. But for the majority of people, a more accurate starting point would be 1.45.'''),
				],
			),
		);
	}

	Widget weightLiftingBurn(BuildContext context)
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
								hyperlinkText("MET", "https://www.healthline.com/health/what-are-mets", context),
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
								hyperlinkText("continuous activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
								const TextSpan(text: " where you can easily track how long you actually did an activity for. For activities that incorporate lots of rest (like weightlifting), then multiplying by 0.8 creates a leniency factor to accommodate for the rest periods."),
								const TextSpan(text: "Additionally for weightlifting, some parts of your body will burn more calories than other parts. "),
								hyperlinkText("Doing a bicep curl will use significantly less energy than a full body squat.", "https://pmc.ncbi.nlm.nih.gov/articles/PMC5524349/", context),
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

	Widget cardioBurn(BuildContext context)
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
								hyperlinkText("MET values do exist for cardio-based activities", "https://media.hypersites.com/clients/1235/filemanager/MHC/METs.pdf", context),
								const TextSpan(text: ", however since MET assumes constant movement, they wouldn't work as well for people who like to take rest breaks. Especially when running on a treadmill at a flat incline where the "),
								hyperlinkText("energy cost per kilometer is 1 kcal/kg", "https://journals.physiology.org/doi/abs/10.1152/jappl.1963.18.2.367", context),
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
								hyperlinkText("cycling is more efficient", "https://en.wikipedia.org/wiki/Bicycle_performance", context),
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

	Widget epoc(BuildContext context)
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
								hyperlinkText("the body consumes more oxygen than usual to:", "https://blog.nasm.org/excess-post-exercise-oxygen-consumption", context),
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
								hyperlinkText("There are 3 tiers that an EPOC can be", "https://pubmed.ncbi.nlm.nih.gov/17101527/", context),
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

	Widget summary(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text('''Daily Calculation Summary'''),
					const Text('''Use the following formula to determine intake requirements for training days: TDEE + Activity Burn + Run Burn + EPOC'''),

					const Text('''Example Scenario (70kg User)'''),

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
									textOption("1,700 * 1.45"),
									textOption("2,465 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Heavy Weight Lifting (40 minutes of upper body)"),
									textOption("((5 * 3.5 * 70) / 200) * 40 * 1.2"),
									textOption("294 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Heavy Weight Lifting (30 minutes of accessories)"),
									textOption("((5 * 3.5 * 70) / 200) * 30 * 0.7"),
									textOption("129 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Total Gym Expenditure"),
									textOption("(294 + 129) * 0.8"),
									textOption("338 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Cardio (2km Running)"),
									textOption("70 * 2 * 1"),
									textOption("140 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("EPOC (Moderate / Anaerobic)"),
									textOption("(338 + 140) * 0.10"),
									textOption("48 kcal")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Total Burn"),
									textOption("(1,700 * 1.45) + (((((5 * 3.5 * 70) / 200) * 40 * 1.2) + (((5 * 3.5 * 70) / 200) * 30 * 0.7)) * 0.8) + (70 * 2 * 1) + ((338 + 140) * 0.10)"),
									textOption("2,991 kcal")
								]
							)
						],
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''To double check this value, go to '''),
								hyperlinkText("BMR Calculator", "https://www.calculator.net/bmr-calculator.html?cage=25&csex=m&cheightfeet=5&cheightinch=10&cpound=160&cheightmeter=180&ckg=70&cmop=0&coutunit=c&cformula=m&cfatpct=20&ctype=metric&x=Calculate", context),
								const TextSpan(text: ''' and put in a 25 year old Male that weighs 70kg and is 180cm tall. And you'll see that the value provided here is very close to the value associated with "Intense exercise 6-7 times/week". Which makes sense, because if you did this intense workout every single day, you definitely would need around 3,000 calories everyday to retain basic bodily functions.'''),
							]
						)
					),
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
									headerOption("Legs + Accessories Gym Day (2x)"),
									textOption("3,011"),
									textOption("3,511"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Upper + Accessories Gym Day (2x)"),
									textOption("2,991"),
									textOption("3,491"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (3x)"),
									textOption("2,465"),
									textOption("2,965"),
									textOption("+500")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("19,399"),
									textOption("22,899"),
									textOption("+3,500")
								]
							)
						],
					)
				],
			),
		);
	}

	Widget gainWeight2(BuildContext context)
	{
		return const Card
		(
			child: Column
			(
				children:
				[
					Text.rich
					(
						TextSpan
						(
							children:
							[
								TextSpan(text: '''How to Gain 450g per Week''', style: TextStyle(fontSize: 20, fontWeight: .bold)),
								TextSpan(text: '''\nTo gain 450g of weight, you must create a cumulative weekly surplus of 3,500 calories.'''),
								TextSpan(text: '''\nThere are 2 main ways this extra energy is stored. If you are exercising consistently, a portion of this will be stored as muscle glycogen and tissue. If you are sedentary, the vast majority will be stored as fat.''')
							]
						)
					),
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
									headerOption("Legs + Accessories Gym Day (2x)"),
									textOption("3,011"),
									textOption("2,500"),
									textOption("-511")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Upper + Accessories Gym Day (2x)"),
									textOption("2,991"),
									textOption("2,400"),
									textOption("-591")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Rest Day (3x)"),
									textOption("2,465"),
									textOption("2,000"),
									textOption("-465")
								]
							),
							TableRow
							(
								children:
								[
									headerOption("Weekly Total"),
									textOption("19,399"),
									textOption("15,800"),
									textOption("-3,599")
								]
							)
						],
					),
				],
			),
		);
	}

	Widget loseWeight2(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''How to Lose 450g per Week''', style: TextStyle(fontSize: 20, fontWeight: .bold)),
								const TextSpan(text: '''\nTo lose 450g of fat, you must create a cumulative weekly deficit of 3,500 calories. This means your body must burn 3,500 more calories than it consumes over 7 days.'''),
								const TextSpan(text: '''\nWhen the body lacks 500 calories from food to perform its daily functions, it triggers '''),
								hyperlinkText("lipolysis", "https://www.revitalizemedspa.ca/what-is-lipolysis-understanding-the-science-behind-fat-burning", context),
								const TextSpan(text: ''' (breaking down stored fat) to make up the energy difference. For high-intensity athletes, managing '''),
								hyperlinkText("glycogen levels", "https://inscyd.com/article/muscle-glycogen-and-exercise-all-you-need-to-know/", context),
								const TextSpan(text: ''' is critical to avoid getting fatigued easily.''')
							]
						)
					),
				],
			),
		);
	}

	Widget nutrition(BuildContext context)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					const Text("To calculate macros, micros and water intake, you must first establish how much you weigh and your Total Daily Energy Expenditure (TDEE)."),

					const Text('''1. Protein''', style: TextStyle(fontSize: 15, fontWeight: .bold)),
					const Text('''Protein is calculated by body weight, not by a percentage of calories. This ensures you maintain muscle mass regardless of whether you are in a deficit or surplus.'''),
					const Text('''Depending on how active you are, your intake should be between 1.6g to 2.2g per kg of body weight.'''),
					const Text('''Example (70kg person): 70 * 1.8 = 126g of Protein.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Protein is extremely important to eat, as it's what keeps your body physically fit. It's also the most expensive macro to digest, meaning you burn more calories just processing it, and it keeps you full longer during a cut. It also plays a role in '''),
								hyperlinkText("bone strength and cellular function and other bodily functions.", "https://www.healthline.com/nutrition/10-reasons-to-eat-more-protein", context),
								const TextSpan(text: '''When losing weight, it's better to lean towards the higher end of the 1.6g - 2.2g scale, as that will help prevent your body from burning your own muscle for energy.''')
							]
						)
					),

					const Text('''2. Fats''', style: TextStyle(fontSize: 15, fontWeight: .bold)),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Fats are essential for hormone production and '''),
								hyperlinkText("absorbing fat-soluble vitamins found vegetables, like Vitamin A, D, E, and K.", "https://www.healthline.com/nutrition/fat-soluble-vitamins", context),
							]
						)
					),

					const Text('''Your intake should be around 20 to 30% of your TDEE'''),
					const Text('''Example (2,465 TDEE): (2,465 * 0.25) / 9 = 68g of total fat.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Dropping below 20% for extended periods can lead to '''),
								hyperlinkText("hormonal disruption", "https://www.baptisthealth.com/blog/endocrinology/how-diet-affects-hormones", context),
								const TextSpan(text: ''' and '''),
								hyperlinkText("brain fog", "https://thejemfoundation.com/why-your-brain-needs-fat/#:~:text=Fats%2C%20Mood%2C%20and%20Mental%20Health,%2C%20anxiety%2C%20and%20brain%20fog.", context),
								const TextSpan(text: '''; and going above 30% would create unnecessarily high-fat diets that cut into your protein and carbohydrate intakes.''')
							]
						)
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Now to break it down even further, for Saturated Fats, '''),
								hyperlinkText("you shouldn't consume any more than 10%", "https://www.healthline.com/nutrition/how-much-fat-to-eat#how-much-is-healthy", context),
								const TextSpan(text: ''' of your TDEE. However, that also doesn't mean that you should try eat 0%. Saturated Fat is a precursor to cholesterol, which is a '''),
								hyperlinkText("building block of vitamin D, hormones, and fat-dissolving bile acids.", "https://www.health.harvard.edu/heart-health/how-its-made-cholesterol-production-in-your-body", context),
							]
						)
					),

					const Text('''Example (2,465 TDEE): (2,465 * 0.1) / 9 = 27g of Saturated Fat.'''),
					const Text('''Unsaturated Fats should make up the majority of your total fat (the other 41g of fat).'''),
					const Text('''And Trans Fats should be kept as low as possible.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								hyperlinkText("To meet your fat goals", "https://www.myjuniper.com/blog/how-much-fat-per-day", context),
								const TextSpan(text: ''', foods with higher '''),
								hyperlinkText("Monounsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Avocados, almonds, cashews, etc) and '''),
								hyperlinkText("Polyunsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Oily fish (salmon, sardines, mackerel), walnuts, flaxseeds, etc) should be eaten.'''),
							]
						)
					),

					const Text('''If Polyunsaturated Fats are hard to come by, Triple-Strength Fish Oil tablets are a great substitute.'''),

					const Text('''3. Carbohydrates''', style: TextStyle(fontSize: 15, fontWeight: .bold)),
					const Text('''Carbohydrates are the primary source of fuel for the body. They provide energy for cells, tissues, and organs like the brain. Simple carbs (fruit, white-bread, sugary food) are great for pre-workout meals as they allow for immediate energy; and complex carbs (whole grains, beans, starchy food) are great for providing steady energy throughout the day.'''),
					const Text('''To calculate how many to eat, simply get take the result thats leftover after calculating your protein and fat.'''),
					const Text('''Calculation: TDEE - (Protein + Fat calories) = Carbohydrate Calories.'''),
					const Text('''Conversion factors: Protein = 4kcal/g, Carbs = 4kcal/g, Fats = 9kcal/g.'''),
					const Text('''Example (2,465 TDEE): (2,465 - (126 * 4) - (68 * 9)) / 4 = 337g of Carbohydrates'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''To break it down further, your carbs should also contain a mix of '''),
								hyperlinkText("soluble and insoluble fibre", "https://www.healthline.com/health/soluble-vs-insoluble-fiber", context),
								const TextSpan(text: ''', and you should aim to get '''),
								hyperlinkText("25 to 30 grams of fibre per day.", "https://my.clevelandclinic.org/health/articles/15416-carbohydrates", context),
							]
						)
					),

					const Text('''Soluble fibre dissolves in water to form a gel-like substance in the digestive tract, which slows digestion, aids in stabilizing blood sugar levels, and helps lower LDL ("bad") cholesterol. It acts as a pre-biotic, feeds beneficial gut bacteria, and increases satiety to assist with weight management.'''),
					const Text('''Good sources include: fruit and vegetables, oats, beans and soy products.'''),
					const Text('''Insoluble fibre, which does not dissolve in water, acts as a bulking agent that speeds up the passage of food and waste through the digestive system. It adds bulk to stool, makes it softer and easier to pass, and prevents constipation, promoting regular bowel movements.'''),
					const Text('''Good sources include: beans, whole grain products, nuts and green vegetables.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''And in regards to the other carbohydrate, Sugar is the only nutrient where the optimal intake can be 0g. Your body has no biological requirement for added sugar (unless you suffer from a medical condition). This is because your liver can do a process called '''),
								hyperlinkText("Gluconeogenesis", "https://teachmephysiology.com/biochemistry/atp-production/gluconeogenesis/", context),
								const TextSpan(text: ''', where it converts non-carbohydrate sources into glucose to maintain your sugar levels.'''),
								const TextSpan(text: '''So if there's no floor for how much I should consume, then what's the ceiling? According to the WHO, you should cut off your sugar intake around '''),
								hyperlinkText("the 10% mark of your TDEE.", "https://www.healthdirect.gov.au/sugar", context),
							]
						)
					),

					const Text('''Example (2,465 TDEE): (2,465 * 0.1) / 4 = 62g of Sugar'''),
					const Text('''And just to be clear, eating natural sugars from fruits and vegetables are perfectly fine (within reason) as they come within the whole-food matrix of fibre and other nutrients, which allows for slow absorption and a steady release of insulin.'''),
					const Text('''Added Sugars, like those found in syrups are just empty calories as they don't provide any micronutrient benefit.'''),

					const Text('''4. Micronutrients''', style: TextStyle(fontSize: 15, fontWeight: .bold)),
					const Text('''This term refers to the vitamins and minerals found in food. These can then be divided into macrominerals, trace minerals and water soluble vitamins and fat soluble vitamins.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''In order to get every micro needed for your body, it's important to eat a balanced diet with foods from different sources. However if you can't eat from a wide range of foods, Multivitamin Tablets provide many micros needed. An issue with them though is that they don't contain the full matrix of complimentary structures that vegetables contain when you digest them. Nutrients in a whole-food matrix are released slower and absorbed more completely than the flash flood of nutrients from a pill, which often just results in it being flushed away in your urine. Additionally, some vitamins like A, D, E, and K need fat in order to be absorbed, so its always good to eat them with a fatty food. But if vegetables are unaccessible, it's still a good option. For more information, '''),
								hyperlinkText("refer to this website.", "https://www.healthline.com/nutrition/micronutrients", context),
							]
						)
					),

					const Text('''5. Water''', style: TextStyle(fontSize: 15, fontWeight: .bold)),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								hyperlinkText("Water intake", "https://www.nuffieldhealth.com/article/how-much-water-should-you-drink-per-day", context),
								const TextSpan(text: ''' depends on 2 factors: body weight and activity level.'''),
							]
						)
					),

					const Text('''Your base water intake should be between 30ml to 35ml of water per kg of body weight.'''),
					const Text('''Example (70kg person): 70 * 30 = 2,100ml | 70 * 35 = 2,450ml'''),
					const Text('''And then for every hour of exercise, add on 500ml to 1000ml of additional water.'''),
					const Text('''To tell how hydrated you truly are, check the color of your urine. Aim for a pale straw color. If it is dark yellow, you are dehydrated; if it is completely clear, you may be over-hydrated and flushing out electrolytes.'''),
					const Text('''Water doesn't just help with quenching your thirst, it's also fundamental to your body operating properly.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''For every 1g of glycogen in your muscles, '''),
								hyperlinkText("your body needs around 3g of water", "https://pubmed.ncbi.nlm.nih.gov/25911631/", context),
								const TextSpan(text: '''. If you are dehydrated your muscles won't be saturated properly and will be flat and weaker than normal.'''),
							]
						)
					),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Additionally, the '''),
								hyperlinkText("synovial fluid", "https://blog.rheosense.com/news/synovial-fluids-and-the-importance-of-viscosity-a-comprehensive-guide", context),
								const TextSpan(text: ''' that lubricates your joints is made primarily of water. So by dehydrating yourself and exercising, you can easily cause connective tissue injuries.'''),
							]
						)
					),

					const Text('''6. Electrolytes''', style: TextStyle(fontSize: 15, fontWeight: .bold)),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''While your main macros and micros help build your body, electrolytes actually operate it and allow you to move properly. They are crucial in contracting your muscles and sending nerve impulses.'''),
								const TextSpan(text: '''The primary electrolyte that gets the most attention is sodium. It regulates blood volume and muscle contractions, and depletes quickly through sweat. It's important not to consume too much, but it's also important to consume enough to not lose strength and develop headaches.'''),
								const TextSpan(text: '''Furthermore, if you are drinking large amounts of water (3L+) and training hard, don't be afraid to salt your food or use an electrolyte powder. If you only hydrate yourself without also replacing your electrolytes, you can easily dilute your blood and decrease your performance.'''),
								const TextSpan(text: '''. For more information, '''),
								hyperlinkText("refer to this website.", "https://www.healthline.com/nutrition/electrolytes", context),
							]
						)
					),
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

	TextSpan hyperlinkText(String hyperText, String websiteUri, BuildContext context)
	{
		return TextSpan
		(
			children:
			[
				TextSpan
				(
					text: hyperText,
					style: const TextStyle
					(
						color: Colors.blue,
						decoration: TextDecoration.underline,
					),
					recognizer: TapGestureRecognizer()..onTap = ()
					{
						_launchURL(Uri.parse(websiteUri), context);
					},
				),
			],
		);
	}

	Future<void> _launchURL(Uri url, BuildContext context) async
	{
		try
		{
			await launchUrl(url, mode: LaunchMode.inAppBrowserView);
		}
		catch(e)
		{
			if(context.mounted)
			{
				ScaffoldMessenger.of(context).showSnackBar
				(
					SnackBar
					(
						content: const Center
						(
							child: Text
							(
								'''Couldn't open website''',
								style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
							)
						),
						width: 200,
						backgroundColor: Theme.of(context).extension<AppColours>()!.tertiaryColour!,
						behavior: SnackBarBehavior.floating,
						shape: RoundedRectangleBorder
						(
							borderRadius: BorderRadius.circular(50),
						),
					),
				);
			}
		}
	}
}