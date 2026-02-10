// import "package:english_words/english_words.dart"; // Imports a utility package containing thousands of common English words and functions to manipulate them. Used here to generate random WordPair objects.
import "package:calorie_calculator_app/pages/nutrition/nutrition.dart";
import "package:calorie_calculator_app/pages/planner/folder_data.dart";
import "package:calorie_calculator_app/pages/planner/planner.dart";
import "package:calorie_calculator_app/utilities/colours.dart";
import "package:flutter/material.dart"; // The core Flutter framework. It provides "Material Design" widgets (buttons, cards, scaffolds) and the engine for rendering the UI.
import "package:calorie_calculator_app/pages/calculator/bmr.dart";
import "package:calorie_calculator_app/pages/calculator/calculations.dart";
import "package:calorie_calculator_app/pages/history/history.dart";
import "package:calorie_calculator_app/pages/information/information.dart";
import "package:calorie_calculator_app/utilities/utilities.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart"; // A state management package. It allows data (like the list of favorites) to be shared across different screens without manually passing it through every constructor.
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
				ChangeNotifierProvider(create: (context) => WeeklyTdeeNotifier()),
				ChangeNotifierProvider(create: (context) => DailyEntryNotifier()),
				ChangeNotifierProvider(create: (context) => WeeklyPlanNotifier()..init()),
				ChangeNotifierProvider(create: (context) => FolderNotifier()),
				ChangeNotifierProvider(create: (context) => ThemeNotifier()..init()),
				ChangeNotifierProvider(create: (context) => NutritionFields()),
				ChangeNotifierProvider(create: (context) => NavigationNotifier()),
				ChangeNotifierProvider(create: (context) => CalculationFields()),
				ChangeNotifierProvider(create: (context) => AllCalculations()..init()),
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
						maleUnColour: Color.fromARGB(255, 227, 242, 253),
						maleSeColour: Color.fromARGB(255, 144, 202, 249),
						femaleUnColour: Color.fromARGB(255, 252, 228, 236),
						femaleSeColour: Color.fromARGB(255, 244, 143, 177),
						runUnColour: Color.fromARGB(255, 232, 245, 233),
						runSeColour: Color.fromARGB(255, 165, 214, 167),
						cycleUnColour: Color.fromARGB(255, 255, 253, 231),
						cycleSeColour: Color.fromARGB(255, 255, 245, 157),
						aerobicOutlineColour: Color.fromARGB(255, 232, 245, 233),
						aerobicBackgroundColour: Color.fromARGB(255, 165, 214, 167),
						anaerobicOutlineColour: Color.fromARGB(255, 255, 243, 224),
						anaerobicBackgroundColour: Color.fromARGB(255, 255, 204, 128),
						maximalOutlineColour: Color.fromARGB(255, 255, 235, 238),
						maximalBackgroundColour: Color.fromARGB(255, 239, 154, 154),
					)
				]
			),
			// Dark Theme
			darkTheme: ThemeData
			(
				useMaterial3: true,
				scaffoldBackgroundColor: darkSeed,
				colorScheme: ColorScheme.fromSeed
				(
					brightness: Brightness.dark,
					seedColor: darkSeed,
				),
				extensions: 
				[
					const AppColours
					(
						backgroundColour: darkSeed,
						secondaryColour: Color.fromARGB(255, 255, 205, 205),
						tertiaryColour: Color.fromARGB(255, 140, 110, 110),
						maleUnColour: Color.fromARGB(255, 45, 55, 65),
						maleSeColour: Color.fromARGB(255, 100, 140, 180),
						femaleUnColour: Color.fromARGB(255, 65, 45, 55),
						femaleSeColour: Color.fromARGB(255, 180, 110, 135),
						runUnColour: Color.fromARGB(255, 45, 60, 48),
						runSeColour: Color.fromARGB(255, 110, 150, 115),
						aerobicOutlineColour: Color.fromARGB(255, 45, 60, 48),
						aerobicBackgroundColour: Color.fromARGB(255, 110, 150, 115),
						cycleUnColour: Color.fromARGB(255, 65, 60, 40),
						cycleSeColour: Color.fromARGB(255, 190, 170, 90),
						anaerobicOutlineColour: Color.fromARGB(255, 75, 55, 40),
						anaerobicBackgroundColour: Color.fromARGB(255, 200, 130, 80),
						maximalOutlineColour: Color.fromARGB(255, 80, 40, 45),
						maximalBackgroundColour: Color.fromARGB(255, 180, 90, 100),
					)
				]
			),
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
			themeMode: context.watch<ThemeNotifier>().themeMode,
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
		int selectedIndex = context.watch<NavigationNotifier>().selectedIndex;

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
			1 => const CalculatorPage.notAWeeklyPlanner(title: "TDEE Calculator", isDedicatedBMRPage: true, weeklyPlanner: false),
			2 => const CalculatorPage.notAWeeklyPlanner(title: "Daily Calorie Calculator", isDedicatedBMRPage: false, weeklyPlanner: false),
			3 => const HistoryPage(),
			4 => const NutritionPage(),
			5 => const PlannerPage(),
			_ => const CalculatorPage.notAWeeklyPlanner(title: "TDEE Calculator", isDedicatedBMRPage: true, weeklyPlanner: false),
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
				navItem(Icons.calendar_month_outlined),
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

class ThemeNotifier extends ChangeNotifier
{
	ThemeMode themeMode = ThemeMode.light;
	bool isLightMode = false;
	final String modeName = "isLightMode";

	Future<void> init() async
	{
		await loadTheme();
		notifyListeners();
	}

	void changeTheme()
	{
		if(isLightMode == true)
		{
			themeMode = ThemeMode.dark;
		}
		else
		{
			themeMode = ThemeMode.light;
		}

		saveTheme();

		notifyListeners();
	}

	Future<void> saveTheme() async
	{
		SharedPreferences preferences = await SharedPreferences.getInstance();
		preferences.setBool(modeName, isLightMode);
	}

	Future<void> loadTheme() async
	{
		SharedPreferences preferences = await SharedPreferences.getInstance();
		isLightMode = preferences.getBool(modeName) ?? false;

		isLightMode == false ? themeMode = ThemeMode.light : themeMode = ThemeMode.dark;

		notifyListeners();
	}
}