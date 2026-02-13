import 'package:bulleted_list/bulleted_list.dart';
import 'package:calorie_calculator_app/utilities/hyperlinker.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';

class NutritionalInfo extends StatelessWidget
{
  	const NutritionalInfo({super.key});

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
					const Text("To calculate macros, micros and water intake, you must first establish how much you weigh and what your caloric ceiling is for today."),

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
								HyperLinker.hyperlinkText("bone strength and cellular function and other bodily functions.", "https://www.healthline.com/nutrition/10-reasons-to-eat-more-protein", context),
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
								HyperLinker.hyperlinkText("absorbing fat-soluble vitamins found vegetables, like Vitamin A, D, E, and K.", "https://www.healthline.com/nutrition/fat-soluble-vitamins", context),
							]
						)
					),

					const Text('''Your intake should be around 20 to 30% of your Total Calories'''),
					const Text('''Example (2,465 kcal): (2,465 * 0.25) / 9 = 68g of total fat.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''Dropping below 20% for extended periods can lead to '''),
								HyperLinker.hyperlinkText("hormonal disruption", "https://www.baptisthealth.com/blog/endocrinology/how-diet-affects-hormones", context),
								const TextSpan(text: ''' and '''),
								HyperLinker.hyperlinkText("brain fog", "https://thejemfoundation.com/why-your-brain-needs-fat/#:~:text=Fats%2C%20Mood%2C%20and%20Mental%20Health,%2C%20anxiety%2C%20and%20brain%20fog.", context),
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
								HyperLinker.hyperlinkText("you shouldn't consume any more than 10%", "https://www.healthline.com/nutrition/how-much-fat-to-eat#how-much-is-healthy", context),
								const TextSpan(text: ''' of your Total Calories. However, that also doesn't mean that you should try eat 0%. Saturated Fat is a precursor to cholesterol, which is a '''),
								HyperLinker.hyperlinkText("building block of vitamin D, hormones, and fat-dissolving bile acids.", "https://www.health.harvard.edu/heart-health/how-its-made-cholesterol-production-in-your-body", context),
							]
						)
					),

					const Text('''Example (2,465 kcal): (2,465 * 0.1) / 9 = 27g of Saturated Fat.'''),
					const Text('''Unsaturated Fats should make up the majority of your total fat (the other 41g of fat).'''),
					const Text('''And Trans Fats should be kept as low as possible.'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								HyperLinker.hyperlinkText("To meet your fat goals", "https://www.myjuniper.com/blog/how-much-fat-per-day", context),
								const TextSpan(text: ''', foods with higher '''),
								HyperLinker.hyperlinkText("Monounsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Avocados, almonds, cashews, etc) and '''),
								HyperLinker.hyperlinkText("Polyunsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Oily fish (salmon, sardines, mackerel), walnuts, flaxseeds, etc) should be eaten.'''),
							]
						)
					),

					const Text('''If Polyunsaturated Fats are hard to come by, Triple-Strength Fish Oil tablets are a great substitute.'''),

					const Text('''3. Carbohydrates''', style: TextStyle(fontSize: 15, fontWeight: .bold)),
					const Text('''Carbohydrates are the primary source of fuel for the body. They provide energy for cells, tissues, and organs like the brain. Simple carbs (fruit, white-bread, sugary food) are great for pre-workout meals as they allow for immediate energy; and complex carbs (whole grains, beans, starchy food) are great for providing steady energy throughout the day.'''),
					const Text('''To calculate how many to eat, simply get take the result thats leftover after calculating your protein and fat.'''),
					const Text('''Calculation: Total Calories - (Protein + Fat calories) = Carbohydrate Calories.'''),
					const Text('''Conversion factors: Protein = 4kcal/g, Carbs = 4kcal/g, Fats = 9kcal/g.'''),
					const Text('''Example (2,465 kcal): (2,465 - (126 * 4) - (68 * 9)) / 4 = 337g of Carbohydrates'''),

					Text.rich
					(
						TextSpan
						(
							children:
							[
								const TextSpan(text: '''To break it down further, your carbs should also contain a mix of '''),
								HyperLinker.hyperlinkText("soluble and insoluble fibre", "https://www.healthline.com/health/soluble-vs-insoluble-fiber", context),
								const TextSpan(text: ''', and you should aim to get '''),
								HyperLinker.hyperlinkText("25 to 30 grams of fibre per day.", "https://my.clevelandclinic.org/health/articles/15416-carbohydrates", context),
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
								HyperLinker.hyperlinkText("Gluconeogenesis", "https://teachmephysiology.com/biochemistry/atp-production/gluconeogenesis/", context),
								const TextSpan(text: ''', where it converts non-carbohydrate sources into glucose to maintain your sugar levels.'''),
								const TextSpan(text: '''So if there's no floor for how much I should consume, then what's the ceiling? According to the WHO, you should cut off your sugar intake around '''),
								HyperLinker.hyperlinkText("the 10% mark of your Total Calories.", "https://www.healthdirect.gov.au/sugar", context),
							]
						)
					),

					const Text('''Example (2,465 kcal): (2,465 * 0.1) / 4 = 62g of Sugar'''),
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
								HyperLinker.hyperlinkText("refer to this website.", "https://www.healthline.com/nutrition/micronutrients", context),
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
								HyperLinker.hyperlinkText("Water intake", "https://www.nuffieldhealth.com/article/how-much-water-should-you-drink-per-day", context),
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
								HyperLinker.hyperlinkText("your body needs around 3g of water", "https://pubmed.ncbi.nlm.nih.gov/25911631/", context),
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
								HyperLinker.hyperlinkText("synovial fluid", "https://blog.rheosense.com/news/synovial-fluids-and-the-importance-of-viscosity-a-comprehensive-guide", context),
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
								HyperLinker.hyperlinkText("refer to this website.", "https://www.healthline.com/nutrition/electrolytes", context),
							]
						)
					),
				],
			),
		);
	}
}