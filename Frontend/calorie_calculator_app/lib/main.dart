// import "package:english_words/english_words.dart"; // Imports a utility package containing thousands of common English words and functions to manipulate them. Used here to generate random WordPair objects.
import "package:calorie_calculator_app/pages/nutrition/nutrition.dart";
import "package:calorie_calculator_app/utilities/colours.dart";
import "package:flutter/material.dart"; // The core Flutter framework. It provides "Material Design" widgets (buttons, cards, scaffolds) and the engine for rendering the UI.
import "package:calorie_calculator_app/pages/calculator/bmr.dart";
import "package:calorie_calculator_app/pages/calculator/calculations.dart";
import "package:calorie_calculator_app/pages/history/history.dart";
import "package:calorie_calculator_app/pages/information/information.dart";
import "package:calorie_calculator_app/utilities/utilities.dart";
import "package:provider/provider.dart"; // A state management package. It allows data (like the list of favorites) to be shared across different screens without manually passing it through every constructor.
// import 'package:google_fonts/google_fonts.dart';

// TODO: Add try catches, better error handling, comments explaining everything, test cases / test units
void main()
{
	runApp
	(
		MultiProvider // Allows me to have multiple ChangeNotifiers
		(
			providers:
			[
				ChangeNotifierProvider(create: (context) => NutritionFields()),
				ChangeNotifierProvider(create: (context) => NavigationNotifier()),
				ChangeNotifierProvider(create: (context) => CalculationFields()),
				ChangeNotifierProvider(create: (context) => AllCalculations()..init()), // The ..init() triggers the load
				ChangeNotifierProvider(create: (context) => UsersTdeeNotifier()..init()) // The ..init() triggers the load
			],

			child: const MyApp(), // The entire app now has access to a list of providers, rather than just creating and listening to 1
		)
	);
}

class MyApp extends StatelessWidget
{
	const MyApp({super.key});

	@override
	Widget build(BuildContext context)
	{
		const Color lightSeed = Color.fromARGB(255, 255, 240, 230);
		const Color darkSeed = Color.fromARGB(255, 53, 35, 35);
		
		return MaterialApp
		(
			title: 'Calorie Calculator',
			// Light Theme
			theme: ThemeData
			(
				useMaterial3: true,
				scaffoldBackgroundColor: lightSeed,
				colorScheme: ColorScheme.fromSeed
				(
					brightness: Brightness.light,
					seedColor: lightSeed,
				),
				extensions: 
				[
					const AppColours
					(
						backgroundColour: lightSeed,
						secondaryColour: Color.fromARGB(255, 255, 205, 205),
						tertiaryColour: Color.fromARGB(255, 255, 241, 241),
						maleUnColour: Color.fromRGBO(227, 242, 253, 1),
						maleSeColour: Color.fromRGBO(144, 202, 249, 1),
						femaleUnColour: Color.fromRGBO(252, 228, 236, 1),
						femaleSeColour: Color.fromRGBO(244, 143, 177, 1),
						runUnColour: Color.fromRGBO(232, 245, 233, 1),
						runSeColour: Color.fromRGBO(165, 214, 167, 1),
						cycleUnColour: Color.fromRGBO(255, 253, 231, 1),
						cycleSeColour: Color.fromRGBO(255, 245, 157, 1),
    					aerobicOutlineColour: Color.fromRGBO(232, 245, 233, 1),
    					aerobicBackgroundColour: Color.fromRGBO(165, 214, 167, 1),
    					anaerobicOutlineColour: Color.fromRGBO(255, 243, 224, 1),
    					anaerobicBackgroundColour: Color.fromRGBO(255, 204, 128, 1),
    					maximalOutlineColour: Color.fromRGBO(255, 235, 238, 1),
    					maximalBackgroundColour: Color.fromRGBO(239, 154, 154, 1),
					)
				]
			),
			// // Dark Theme
			// darkTheme: ThemeData
			// (
			// 	useMaterial3: true,
			// 	scaffoldBackgroundColor: darkSeed,
			// 	colorScheme: ColorScheme.fromSeed
			// 	(
			// 		brightness: Brightness.dark,
			// 		seedColor: darkSeed,
			// 	),
			// 	extensions: 
			// 	[
			// 		const AppColours
			// 		(
			// 			backgroundColour: darkSeed,
			// 			secondaryColour: Color.fromARGB(255, 255, 205, 205),
			// 			tertiaryColour: Color.fromARGB(255, 140, 110, 110)
			// 		)
			// 	]
			// ),
			builder: (context, child)
			{
				// Makes the app look the same everywhere, and it won't adapt to people's phones settings
				return MediaQuery
				(
					data: MediaQuery.of(context).copyWith
					(
						textScaler: TextScaler.noScaling,
						boldText: false
					),
					child: child!
				);
			},
			themeMode: ThemeMode.light, // Auto sets to the device's setting
			home: const MyHomePage(), // The home page is immediately set to the feed because the index is set to 0 immediately
		);
	}
}

class MyHomePage extends StatefulWidget
{
	const MyHomePage({super.key});

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
	@override
	Widget build(BuildContext context)
	{
		final NavigationNotifier navNotifier = context.watch<NavigationNotifier>();
		int selectedIndex = navNotifier.selectedIndex;

		final ColoredBox mainArea = Utils.switchPage(context, getCurrentPage(selectedIndex));

		return LayoutBuilder
		(
			builder: (context, constraints)
			{
				return Scaffold // Use scaffold instead of column so that any space i missed out on isn't pure black. Scaffold works better on phones and has a dedicated nav bar parameter
				(
					body: mainArea, // put the main area above the mobile nav bar
					bottomNavigationBar: mobileNavigationBar()
				);
			}
		);
	}

	Widget getCurrentPage(int selectedIndex)
	{
		return switch(selectedIndex)
		{
			0 => const InformationPage(),
			1 => const CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: true),
			2 => const CalculatorPage(title: "Daily Calorie Calculator", isDedicatedBMRPage: false),
			3 => const HistoryPage(),
			4 => const NutritionPage(),
			_ => const CalculatorPage(title: "TDEE Calculator", isDedicatedBMRPage: true),
		};
	}

	Widget mobileNavigationBar()
	{
		return BottomNavigationBar
		(
			type: BottomNavigationBarType.fixed,
			items:
			[
				navItem(Icons.book),
				navItem(Icons.cached_outlined),
				navItem(Icons.calculate_outlined),
				navItem(Icons.history_rounded),
				navItem(Icons.food_bank),
			],

			currentIndex: context.read<NavigationNotifier>().selectedIndex, // Sets the page to the feed page on start up

			onTap: (value) // When a tab is tapped, setState tells Flutter the selectedIndex changed, triggering a rebuild to show the new page.
			{
				context.read<NavigationNotifier>().changeIndex(value);
			},
		);
	}

	BottomNavigationBarItem navItem(IconData icon)
	{
		return BottomNavigationBarItem
		(
			icon: Transform.translate
			(
				offset: const Offset(0, 10), // Pushes the icon down 10 pixels
				child: Icon(icon, size: 30),
			),
			label: ""
		);
	}
}

class NavigationNotifier extends ChangeNotifier
{
	int selectedIndex = 1;

	void changeIndex(int newIndex)
	{
		selectedIndex = newIndex;
		notifyListeners();
	}
}