// import "package:english_words/english_words.dart"; // Imports a utility package containing thousands of common English words and functions to manipulate them. Used here to generate random WordPair objects.
import "package:calorie_calculator_app/pages/nutrition/nutrition.dart";
import "package:calorie_calculator_app/pages/planner/folder_data.dart";
import "package:calorie_calculator_app/pages/planner/planner.dart";
import "package:calorie_calculator_app/utilities/colours.dart";
import "package:calorie_calculator_app/utilities/settings.dart";
import "package:flutter/material.dart"; // The core Flutter framework. It provides "Material Design" widgets (buttons, cards, scaffolds) and the engine for rendering the UI.
import "package:calorie_calculator_app/pages/calculator/bmr.dart";
import "package:calorie_calculator_app/pages/calculator/calculations.dart";
import "package:calorie_calculator_app/pages/history/history.dart";
import "package:calorie_calculator_app/pages/information/information.dart";
import "package:calorie_calculator_app/utilities/utilities.dart";
import "package:provider/provider.dart";
// import 'package:google_fonts/google_fonts.dart';

// TODO: Add try catches, better error handling, comments explaining everything, test cases / test units
void main()
{
	WidgetsFlutterBinding.ensureInitialized();

	runApp
	(
		MultiProvider // Allows me to have multiple ChangeNotifiers
		(
			providers:
			[
				ChangeNotifierProvider(create: (context) => WaterNotifier()..init()),
				ChangeNotifierProvider(create: (context) => DistanceNotifier()..init()),
				ChangeNotifierProvider(create: (context) => HeightNotifier()..init()),
				ChangeNotifierProvider(create: (context) => WeightNotifier()..init()),
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
		const Color darkSeed = Color.fromARGB(255, 62, 39, 39);
		
		return MaterialApp
		(
			title: 'Calorie Calculator',
			// Light Theme
			theme: ThemeData
			(
				textTheme: const TextTheme
				(
					// Display: Largest, least frequent
					displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.black),
					displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: Colors.black),
					displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.black),

					// Headline: Section headers
					headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.black),
					headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black),
					headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),

					// Title: Component headers (e.g., App Bar, List Tiles)
					titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
					titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
					titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),

					// Body: Main content text
					bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
					bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
					bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black87),

					// Label: Functional text (Buttons, Input hints)
					labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
					labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
					labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
				),
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
						text: Colors.black,
						backgroundColour: lightSeed,
						secondaryColour: Color(0xFFFFCDCD),
						tertiaryColour: Color(0xFFFFF1F1),
						
						maleUnColour: Color(0xFFE3F2FD),
						maleSeColour: Color(0xFF90CAF9),
						femaleUnColour: Color(0xFFFCE4EC),
						femaleSeColour: Color(0xFFF48FB1),
						runUnColour: Color(0xFFE8F5E9),
						runSeColour: Color(0xFFA5D6A7),
						cycleUnColour: Color(0xFFFFFDE7),
						cycleSeColour: Color(0xFFFFF59D),
						
						aerobicOutlineColour: Color(0xFFE8F5E9),
						aerobicBackgroundColour: Color(0xFFA5D6A7),
						anaerobicOutlineColour: Color(0xFFFFF3E0),
						anaerobicBackgroundColour: Color(0xFFFFCC80),
						maximalOutlineColour: Color(0xFFFFEBEE),
						maximalBackgroundColour: Color(0xFFEF9A9A),
						
						bmr: Color(0xFF1478A0),
						caloricBurn: Color(0xFFFF7043),
						caloricBurn2: Color.fromRGBO(255, 224, 178, 1),
						disclaimer: Colors.red,
						fairyPink: Color(0xFFFCE4EC),
						innerYellow: Color.fromRGBO(255, 249, 196, 1),
						outerYellow: Color.fromRGBO(198, 181, 25, 1),
					)
				]
			),
			// Dark Theme
			darkTheme: ThemeData
			(
				textTheme: const TextTheme
				(
					// Display: Largest, least frequent
					displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white),
					displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: Colors.white),
					displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.white),

					// Headline: Section headers
					headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
					headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
					headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),

					// Title: Component headers (e.g., App Bar, List Tiles)
					titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
					titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70),
					titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),

					// Body: Main content text
					bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
					bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white70),
					bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70),

					// Label: Functional text (Buttons, Input hints)
					labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
					labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
					labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70),
				),
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
						text: Colors.white,
						backgroundColour: darkSeed,
						secondaryColour: Color.fromARGB(255, 198, 130, 130),
						tertiaryColour: Color.fromARGB(255, 144, 82, 82),
						
						maleUnColour: Color.fromARGB(255, 63, 92, 114),
						maleSeColour: Color.fromARGB(255, 107, 155, 192),
						femaleUnColour: Color.fromARGB(255, 122, 68, 88),
						femaleSeColour: Color.fromARGB(255, 210, 115, 150),
						runUnColour: Color.fromARGB(255, 60, 108, 64),
						runSeColour: Color.fromARGB(255, 94, 182, 96),
						cycleUnColour: Color.fromARGB(255, 108, 107, 60),
						cycleSeColour: Color.fromARGB(255, 185, 184, 102),
						
						aerobicOutlineColour: Color.fromARGB(255, 86, 164, 93),
						aerobicBackgroundColour: Color.fromARGB(255, 55, 137, 57),
						anaerobicOutlineColour: Color.fromARGB(255, 176, 142, 83),
						anaerobicBackgroundColour: Color.fromARGB(255, 175, 119, 35),
						maximalOutlineColour: Color.fromARGB(255, 160, 91, 103),
						maximalBackgroundColour: Color.fromARGB(255, 142, 26, 26),
						
						bmr: Color.fromARGB(255, 77, 205, 255),
						caloricBurn: Color(0xFFFF7043),
						caloricBurn2: Color.fromRGBO(150, 107, 41, 1),
						disclaimer: Color.fromARGB(255, 66, 4, 4),
						fairyPink: Color(0xFFFCE4EC),
						innerYellow: Color.fromRGBO(161, 152, 56, 1),
						outerYellow: Color.fromRGBO(241, 228, 85, 1),
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
			// themeMode: context.watch<ThemeNotifier>().themeMode,
			themeMode: context.watch<ThemeNotifier>().currentUnit.value,
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

		final ColoredBox truePage = Utils.switchPage(context, getCurrentPage(selectedIndex));

		return LayoutBuilder
		(
			builder: (context, constraints)
			{
				return Scaffold // Use scaffold instead of column so that any space i missed out on isn't pure black. Scaffold works better on phones and has a dedicated nav bar parameter
				(
					body: mainArea(truePage),
					bottomNavigationBar: mobileNavigationBar()
				);
			}
		);
	}

	Widget mainArea(ColoredBox truePage)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 15.0),
			child: Stack
			(
				alignment: AlignmentGeometry.topLeft,
				children:
				[
					truePage,
					settingsButton(),
				],
			),
		);
	}

	Widget settingsButton()
	{
		return IconButton
		(
			icon: const Icon(Icons.settings, size: 30),
			onPressed: () => _showSettings(context),
		);
	}

	void _showSettings(BuildContext context)
	{
		showDialog
		(
			context: context,
			builder: (context)
			{
				return Dialog // Compared to AlertDialogue, this can be customized and made vertical instead of default-horizontal
				(
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
					child: Container
					(
						height: 400,
						width: 300,
						padding: const EdgeInsets.all(16),
						child: Column
						(
							children:
							[
								const Text("Settings", style: TextStyle(fontSize: 20)),

								const Divider(),

								Expanded
								(
									child: ListView
									(
										children:
										[
											ListTile(trailing: const DarkModeSwitch(), title: Text(Utils.whatModeIsIt(context.watch<ThemeNotifier>().isBaseMode, ThemeSetting.darkMode.name, ThemeSetting.lightMode.name))),
											ListTile(trailing: const WeightSwitch(), title: Text(Utils.whatModeIsIt(context.watch<WeightNotifier>().isBaseMode, Weight.pound.name, Weight.kilogram.name))),
											ListTile(trailing: const HeightSwitch(), title: Text(Utils.whatModeIsIt(context.watch<HeightNotifier>().isBaseMode, Height.inch.name, Height.centimeter.name))),
											ListTile(trailing: const DistanceSwitch(), title: Text(Utils.whatModeIsIt(context.watch<DistanceNotifier>().isBaseMode, Distance.mile.name, Distance.kilometer.name))),
											ListTile(trailing: const WaterSwitch(), title: Text(Utils.whatModeIsIt(context.watch<WaterNotifier>().isBaseMode, Water.gallon.name, Water.liter.name))),
										],
									),
								),
								TextButton
								(
									onPressed: () => Navigator.pop(context),
									child: const Text("Save", style: TextStyle(fontSize: 15)),
								),
							],
						),
					),
				);
			},
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