import 'package:calorie_calculator/pages/information/information.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:flutter/material.dart';

class NutritionalInfo extends Information
{
    const NutritionalInfo({super.key});

    @override
    String get appBarText => "Nutritional Info";

    @override
    List<Widget> info(BuildContext context)
    {
        final textCol = Theme.of(context).extension<AppColours>()!.text!;
        final formulaCol = Theme.of(context).extension<AppColours>()!.bmr!;

        return
        [
            const Header(text: 'Nutrition Essentials', fontSize: 32, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            Text
            (
                "To calculate macros, micros and water intake, you must first establish how much you weigh and what your caloric ceiling is for the day.",
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            
			_nutrition
			(
				context,
				"Protein",
				_sectionCard
				(
					context, 
					"1. Protein", 
					"Muscle Maintenance & Repair", 
					formulaCol, 
					[
						_bodyText("Protein is calculated by body weight, not by a percentage of calories. This ensures you maintain muscle mass regardless of whether you are in a deficit or surplus.", textCol),
						_formulaBox("Range: 1.6g – 2.2g per kg of body weight", "Example (70kg): 70 * 1.8 = 126g", formulaCol),
						_richText
						(
							[
								const TextSpan(text: '''Protein is the most expensive macro to digest, meaning you burn more calories just processing it, and it keeps you full longer during a cut. It also plays a role in '''),
								HyperLinker.hyperlinkText("bone strength and cellular function and other bodily functions.", "https://www.healthline.com/nutrition/10-reasons-to-eat-more-protein", context),
								const TextSpan(text: ''' When losing weight, it's better to lean towards the higher end of the 1.6g – 2.2g scale, as that will help prevent your body from burning your own muscle for energy.''')
							], 
							textCol
						),
					]
				),
			),
			
			_nutrition
			(
				context,
				"Fats",
				_sectionCard
				(
					context, 
					"2. Fats", 
					"Hormones & Vitamin Absorption", 
					formulaCol, 
					[
						_richText
						(
							[
								_span("Fats are essential for hormone production and "),
								_link("absorbing fat-soluble vitamins (A, D, E, K).", "https://www.healthline.com/nutrition/fat-soluble-vitamins", context),
							], 
							textCol
						),
						_formulaBox("Range: 20% – 30% of Total Calories", "Example (2,465 kcal): (2,465 * 0.25) / 9 = 68g", formulaCol),
						_richText
						(
							[
								_span("Dropping below 20% can lead to "),
								_link("hormonal disruption", "https://www.baptisthealth.com/blog/endocrinology/how-diet-affects-hormones", context),
								_span(" and "),
								_link("brain fog", "https://thejemfoundation.com/why-your-brain-needs-fat/#:~:text=Fats%2C%20Mood%2C%20and%20Mental%20Health,%2C%20anxiety%2C%20and%20brain%20fog.", context),
								_span("; and going above 30% would create unnecessarily high-fat diets that cut into your protein and carbohydrate intakes."),
							], 
							textCol
						),
						_formulaBox("Saturated Fat Ceiling: 10% of Total Calories", "Example: (2,465 * 0.1) / 9 = 27g", formulaCol),
						_richText
						(
							[
								const TextSpan(text: '''For Saturated Fats, '''),
								HyperLinker.hyperlinkText("you shouldn't consume any more than 10%", "https://www.healthline.com/nutrition/how-much-fat-to-eat#how-much-is-healthy", context),
								const TextSpan(text: ''' of your Total Calories. However, that also doesn't mean that you should try eat 0%.\n\nSaturated Fat is a precursor to cholesterol, which is a '''),
								HyperLinker.hyperlinkText("building block of vitamin D, hormones, and fat-dissolving bile acids.", "https://www.health.harvard.edu/heart-health/how-its-made-cholesterol-production-in-your-body", context),
								const TextSpan(text: ''' Unsaturated Fats should make up the majority of your total fat (the other 41g of fat).'''),
								const TextSpan(text: ''' And Trans Fats should be kept as low as possible.\n\n'''),
								HyperLinker.hyperlinkText("To meet your fat goals", "https://www.myjuniper.com/blog/how-much-fat-per-day", context),
								const TextSpan(text: ''', foods with higher '''),
								HyperLinker.hyperlinkText("Monounsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Avocados, almonds, cashews, etc) and '''),
								HyperLinker.hyperlinkText("Polyunsaturated Fats", "https://blog.nasm.org/healthy-fats-foods", context),
								const TextSpan(text: ''' (Oily fish (salmon, sardines, mackerel), walnuts, flaxseeds, etc) should be eaten.'''),
								const TextSpan(text: '''\n\nIf Polyunsaturated Fats are hard to come by, Triple-Strength Fish Oil tablets are a great substitute.'''),
							], 
							textCol
						),
					]
				),
			),
			
			_nutrition
			(
				context,
				"Carbohydrates",
				_sectionCard
				(
					context, 
					"3. Carbohydrates", 
					"Primary Energy & Fibre", 
					formulaCol, 
					[
						_bodyText("Carbohydrates are the primary source of fuel for the body. They provide energy for cells, tissues, and organs like the brain. Simple carbs (fruit, white-bread, sugary food) are great for pre-workout meals as they allow for immediate energy; and complex carbs (whole grains, beans, starchy food) are great for providing steady energy throughout the day.", textCol),
						_bodyText("\nTo calculate how many grams to eat, simply get take the result thats leftover after calculating your protein and fat.", textCol),
						_formulaBox("Total kcal - (Protein + Fat) = Carb kcal", "Example: (2,465 - (504 + 612)) / 4 = 337g", formulaCol),
						_richText
						(
							[
								const TextSpan(text: '''Additionally, your carbs should also contain a mix of '''),
								HyperLinker.hyperlinkText("soluble and insoluble fibre", "https://www.healthline.com/health/soluble-vs-insoluble-fiber", context),
								const TextSpan(text: ''', and you should aim to get '''),
								HyperLinker.hyperlinkText("25 to 30 grams of fibre per day.", "https://my.clevelandclinic.org/health/articles/15416-carbohydrates", context),
							],
							textCol
						),
						_bodyText('''\nSoluble fibre dissolves in water to form a gel-like substance in the digestive tract, which slows digestion, aids in stabilizing blood sugar levels, and helps lower LDL ("bad") cholesterol. It acts as a pre-biotic, feeds beneficial gut bacteria, and increases satiety to assist with weight management.''', textCol),
						_bodyText('''Good sources include: fruit and vegetables, oats, beans and soy products.\n''', textCol),
						_bodyText('''Insoluble fibre, which does not dissolve in water, acts as a bulking agent that speeds up the passage of food and waste through the digestive system. It adds bulk to stool, makes it softer and easier to pass, and prevents constipation, promoting regular bowel movements.''', textCol),
						_bodyText('''Good sources include: beans, whole grain products, nuts and green vegetables.\n''', textCol),

						_richText
						(
							[
								const TextSpan(text: '''And in regards to Sugar, it's the only nutrient where the optimal intake can be 0g. Your body has no biological requirement for added sugar (unless you suffer from a medical condition). This is because your liver can do a process called '''),
								HyperLinker.hyperlinkText("Gluconeogenesis", "https://teachmephysiology.com/biochemistry/atp-production/gluconeogenesis/", context),
								const TextSpan(text: ''', where it converts non-carbohydrate sources into glucose to maintain your sugar levels.\n\n'''),
								const TextSpan(text: '''So if there's no floor for how much a person should consume, then what's the ceiling? According to the WHO, you should cut off your sugar intake around '''),
								HyperLinker.hyperlinkText("the 10% mark of your Total Calories.", "https://www.healthdirect.gov.au/sugar", context),
							], 
							textCol
						),

						_formulaBox("Sugar Ceiling: 10% of Total Calories", "Example: (2,465 * 0.1) / 9 = 27g", formulaCol),

						_bodyText('''To clarify, eating natural sugars from fruits and vegetables are perfectly fine (within reason) as they come within the whole-food matrix of fibre and other nutrients, which allows for slow absorption and a steady release of insulin.''', textCol),
						_bodyText('''Added Sugars, like those found in syrups are just empty calories as they don't provide any micronutrient benefit.''', textCol),
					],
				),
			),

			_nutrition
			(
				context,
				"Micronutrients",
				_sectionCard
				(
					context, 
					"4. Micronutrients", 
					"Vitamins & Minerals", 
					formulaCol, 
					[
						_richText
						(
							[
								_span("This term refers to the vitamins and minerals found in food. These can then be divided into macrominerals, trace minerals and water soluble vitamins and fat soluble vitamins.\n\n"),
								_span("In order to get every micro needed for your body, it's important to eat a balanced diet with foods from different sources. However if you can't eat from a wide range of foods, Multivitamin Tablets provide many micros needed.\n\nAn issue with them though is that they don't contain the full matrix of complimentary structures that vegetables contain when you digest them. Nutrients in a whole-food matrix are released slower and absorbed more completely than the flash flood of nutrients from a pill, which often just results in it being flushed away in your urine.\n\nAdditionally, some vitamins like A, D, E, and K need fat in order to be absorbed, so its always good to eat them with a fatty food. But if vegetables are unaccessible, it's still a good option. For more information, "),
								_link("refer to this guide.", "https://www.healthline.com/nutrition/micronutrients", context),
							], 
							textCol
						),
					]
				),

			),

			_nutrition
			(
				context,
				"Electrolytes",
				_sectionCard
				(
					context, 
					"5. Electrolytes", 
					"Nerve Function",
					formulaCol, 
					[
						_richText
						(
							[
									const TextSpan(text: '''While your main macros and micros help build your body, electrolytes actually operate it and allow you to move properly. They are crucial in contracting your muscles and sending nerve impulses.\n\n'''),
									const TextSpan(text: '''The primary electrolyte that gets the most attention is sodium. It regulates blood volume and muscle contractions, and depletes quickly through sweat. It's important not to consume too much, but it's also important to consume enough to not lose strength and develop headaches.\n\n'''),
									const TextSpan(text: '''Furthermore, if you are drinking large amounts of water (3L+) and training hard, don't be afraid to salt your food or use an electrolyte powder. If you only hydrate yourself without also replacing your electrolytes, you can easily dilute your blood and decrease your performance.\n\n'''),
									const TextSpan(text: '''For more information, '''),
									HyperLinker.hyperlinkText("refer to this website.", "https://www.healthline.com/nutrition/electrolytes", context),
							], 
							textCol
						),
					]
				),
			),

			_nutrition
			(
				context,
				"Water",
				_sectionCard
				(
					context, 
					"6. Water", 
					"Hydration & Lubrication",
					formulaCol, 
					[
						_formulaBox("Base: 30ml – 35ml per kg of body weight", "Example (70kg): 70 * 35 = 2.45L", formulaCol),
						_richText
						(
							[
								_link("Water intake", "https://www.nuffieldhealth.com/article/how-much-water-should-you-drink-per-day", context),
								_span(" depends on 2 factors: body weight and activity level."),
							], 
							textCol
						),
						_bodyText("For every hour of exercise, add on 500ml to 1000ml of additional water.", textCol),
						_bodyText("\nTo tell how hydrated you truly are, check the color of your urine. Aim for a pale straw color. If it is dark yellow, you are dehydrated; if it is completely clear, you may be over-hydrated and flushing out electrolytes.", textCol),
						_bodyText("\nWater doesn't just help with quenching your thirst, it's also fundamental to your body operating properly.", textCol),
						_richText
						(
							[
								const TextSpan(text: '''\nFor every 1g of glycogen in your muscles, '''),
								HyperLinker.hyperlinkText("your body needs around 3g of water", "https://pubmed.ncbi.nlm.nih.gov/25911631/", context),
								const TextSpan(text: '''. If you are dehydrated your muscles won't be saturated properly and will be flat and weaker than normal.'''),
								const TextSpan(text: '''\n\nAdditionally, the '''),
								HyperLinker.hyperlinkText("synovial fluid", "https://blog.rheosense.com/news/synovial-fluids-and-the-importance-of-viscosity-a-comprehensive-guide", context),
								const TextSpan(text: ''' that lubricates your joints is made primarily of water. So by dehydrating yourself and exercising, you can easily cause connective tissue injuries.'''),
							], 
							textCol
						),
					]
				),
			),

            const SizedBox(height: 100),
        ];
    }

	Widget _nutrition(BuildContext context, String header, Widget content)
	{
		return Padding
		(
			padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
			child: ExpansionTile
			(
				shape: RoundedRectangleBorder
				(
					borderRadius: BorderRadius.circular(20)
				),
				collapsedShape: RoundedRectangleBorder
				(
					borderRadius: BorderRadius.circular(20)
				),
				title: Text
				(
					header,
					style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Theme.of(context).extension<AppColours>()!.bmr!)
				),
				children:
				[
					content
				],
			),
		);
	}

    Widget _sectionCard(BuildContext context, String title, String subtitle, Color accent, List<Widget> content)
    {
        return Container
        (
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration
            (
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.1)),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accent)),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: accent.withOpacity(0.6), fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                    ...content,
                ],
            ),
        );
    }

    Widget _formulaBox(String title, String formula, Color color)
    {
        return Container
        (
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration
            (
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
            ),
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Text(formula, style: TextStyle(fontFamily: 'monospace', fontSize: 14, color: color.withOpacity(0.9))),
                ],
            ),
        );
    }

    Widget _bodyText(String text, Color col)
    {
        return Padding
        (
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(text, style: TextStyle(color: col, fontSize: 15, height: 1.5)),
        );
    }

    Widget _richText(List<InlineSpan> spans, Color col)
    {
        return Padding
        (
            padding: const EdgeInsets.only(bottom: 8),
            child: Text.rich(TextSpan(children: spans, style: TextStyle(color: col, fontSize: 15, height: 1.5))),
        );
    }

    TextSpan _span(String text) => TextSpan(text: text);
    
    InlineSpan _link(String text, String url, BuildContext context) => HyperLinker.hyperlinkText(text, url, context);
}