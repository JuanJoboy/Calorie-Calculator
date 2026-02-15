import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // A state management package. It allows data (like the list of favorites) to be shared across different screens without manually passing it through every constructor.

// Mixins are different to abstract classes or enums, as I can implement those below methods without forcing the subclasses to also implement concrete implementations. Cause for some reason even though there is an implementation here, the children also need one.
// mixin: Defines behavior that can be shared.
// with Settings: This tells Dart to "copy-paste" the toBase and fromBase logic into the Weight enum.
mixin Settings<T>
{
	T get value;
	String get name;
	String get symbol;
	bool get isBase;

	// These methods are named like this to make them reusable for future measurements
	double toBase(double input) => input / (value as num); // If i put 100 pounds, then that means my setting is on pounds, which makes it 100 pounds / 2.2

	double fromBase(double baseValue) => baseValue * (value as num); // This would be for displaying info back to non metric users. Everything needs to be in kg, but for displaying it in pounds, this would make the 50 pounds become multiplied by 2.2 again
}

enum ThemeSetting with Settings
{
	lightMode(value: ThemeMode.light, name: 'Light Mode', symbol: 'lightMode', isBase: true),
	darkMode(value: ThemeMode.dark, name: 'Dark Mode', symbol: 'darkMode', isBase: false);

	@override
	final ThemeMode value;
	@override
	final String name;
	@override
	final String symbol;
	@override
	final bool isBase;

	const ThemeSetting({required this.value, required this.name, required this.symbol, required this.isBase});
}

enum Weight with Settings
{
	kilogram(value: 1, name: 'Kilograms', symbol: 'kg', isBase: true),
	pound(value: 2.20462, name: 'Pounds', symbol: 'lb', isBase: false);

	@override
	final double value;
	@override
	final String name;
	@override
	final String symbol;
	@override
	final bool isBase;

	const Weight({required this.value, required this.name, required this.symbol, required this.isBase});
}

enum Height with Settings
{
	centimeter(value: 1, name: 'Centimeters', symbol: 'cm', isBase: true),
	inch(value: 0.393701, name: 'Feet & Inches', symbol: 'in', isBase: false);

	@override
	final double value;
	@override
	final String name;
	@override
	final String symbol;
	@override
	final bool isBase;

	const Height({required this.value, required this.name, required this.symbol, required this.isBase});
}

enum Distance with Settings
{
	kilometer(value: 1, name: 'Kilometers', symbol: 'km', isBase: true),
	mile(value: 0.621371, name: 'Miles', symbol: 'mi', isBase: false);

	@override
	final double value;
	@override
	final String name;
	@override
	final String symbol;
	@override
	final bool isBase;

	const Distance({required this.value, required this.name, required this.symbol, required this.isBase});
}

enum Water with Settings
{
	liter(value: 1, name: 'Liters', symbol: 'L', isBase: true),
	gallon(value: 0.264172, name: 'Gallons', symbol: 'gal', isBase: false);

	@override
	final double value;
	@override
	final String name;
	@override
	final String symbol;
	@override
	final bool isBase;

	const Water({required this.value, required this.name, required this.symbol, required this.isBase});
}

// BaseSettingsNotifier has to specify what Settings object it has, since it has a T
abstract class BaseSettingsNotifier<T extends Settings> extends ChangeNotifier
{
	bool isBaseMode = false;
	String get modeName; // Is a getter so that the subclasses don't overwrite each other's data on the users phone. Every class gets their own key for their own preference

	// The subclasses will provide the two options
	T get baseOption;
	T get secondaryOption;

	// This computed property handles the toggle for the whole app
	T get currentUnit => isBaseMode ? secondaryOption : baseOption;

	Future<void> init() async
	{
		await loadMode();
		notifyListeners();
	}

	void updateMode(bool newValue)
	{
		isBaseMode = newValue;
		changeMode();

		notifyListeners();
	}

	void changeMode()
	{
		saveMode();

		notifyListeners();
	}

	Future<void> saveMode() async
	{
		SharedPreferences preferences = await SharedPreferences.getInstance();
		preferences.setBool(modeName, isBaseMode);
	}

	Future<void> loadMode() async
	{
		SharedPreferences preferences = await SharedPreferences.getInstance();
		isBaseMode = preferences.getBool(modeName) ?? false;

		notifyListeners();
	}
}

class ThemeNotifier extends BaseSettingsNotifier<ThemeSetting>
{
	@override
	String get modeName => "theme_preference";
	
	@override
	ThemeSetting get baseOption => ThemeSetting.lightMode;

	@override
	ThemeSetting get secondaryOption => ThemeSetting.darkMode;
}

class WeightNotifier extends BaseSettingsNotifier<Weight>
{
	@override
	String get modeName => "weight_preference";

	@override
	Weight get baseOption => Weight.kilogram;
	
	@override
	Weight get secondaryOption => Weight.pound;
}

class HeightNotifier extends BaseSettingsNotifier<Height>
{
	@override
	String get modeName => "height_preference";

	@override
	Height get baseOption => Height.centimeter;
	
	@override
	Height get secondaryOption => Height.inch;
}

class DistanceNotifier extends BaseSettingsNotifier<Distance>
{
	@override
	String get modeName => "distance_preference";

	@override
	Distance get baseOption => Distance.kilometer;
	
	@override
	Distance get secondaryOption => Distance.mile;
}

class WaterNotifier extends BaseSettingsNotifier<Water>
{
	@override
	String get modeName => "water_preference";

	@override
	Water get baseOption => Water.liter;
	
	@override
	Water get secondaryOption => Water.gallon;
}

abstract class SettingsSwitch<T extends BaseSettingsNotifier> extends StatelessWidget
{
	IconData get initialIcon;
	IconData get secondIcon;
	Color? get initialActiveColor;
	Color? get secondActiveColor;

  	const SettingsSwitch({super.key});

	@override
	Widget build(BuildContext context)
	{
		// Generics allow context.watch<T>() to work dynamically for the subclass
    	final notifier = context.watch<T>(); // This is essentially the same as calling something like watchNotifier(BuildContext context) where that method returned context.watch<notifier>(); and every subclass was forced to implement it with the type of BaseSettingsNotifier that they are

		final bool isBaseMode = context.watch<T>().isBaseMode;
		final bool isDarkMode = context.watch<ThemeNotifier>().isBaseMode;

		return Switch
		(
			value: isBaseMode,
			onChanged: (newValue)
			{
				notifier.updateMode(newValue);
			},
			thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states)
			{
				if(states.contains(WidgetState.selected))
				{
					return Icon(initialIcon, size: 20);
				}

				return Icon(secondIcon, size: 20);
			}),
			thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states)
			{
				if(states.contains(WidgetState.selected))
				{
					if(isDarkMode)
					{
						return isBaseMode ? Colors.black : Colors.white;
					}
					else
					{
						return isBaseMode ? Colors.white : Colors.black;
					}
				}
				if(isDarkMode)
				{
					return isBaseMode ? Colors.black : Colors.white;
				}
				else
				{
					return isBaseMode ? Colors.white : Colors.black;
				}
			}),
			inactiveTrackColor: initialActiveColor,
			activeTrackColor: secondActiveColor,
		);
	}
}

class DarkModeSwitch extends SettingsSwitch<ThemeNotifier>
{
	@override
	IconData get initialIcon => Icons.nights_stay_rounded;
	@override
	IconData get secondIcon => Icons.sunny;
	@override
	Color? get initialActiveColor => Colors.amber[300];
	@override
	Color? get secondActiveColor => Colors.blue[200];

  	const DarkModeSwitch({super.key});
}

class WeightSwitch extends SettingsSwitch<WeightNotifier>
{
	@override
	IconData get initialIcon => Icons.fitness_center_rounded;
	@override
	IconData get secondIcon => Icons.monitor_weight_rounded;
	@override
	Color? get initialActiveColor => Colors.amber[300];
	@override
	Color? get secondActiveColor => Colors.blue[200];

  	const WeightSwitch({super.key});
}

class HeightSwitch extends SettingsSwitch<HeightNotifier>
{
	@override
	IconData get initialIcon => Icons.height_rounded;
	@override
	IconData get secondIcon => Icons.straighten_rounded;
	@override
	Color? get initialActiveColor => Colors.amber[300];
	@override
	Color? get secondActiveColor => Colors.blue[200];

  	const HeightSwitch({super.key});
}

class DistanceSwitch extends SettingsSwitch<DistanceNotifier>
{
	@override
	IconData get initialIcon => Icons.map_rounded;
	@override
	IconData get secondIcon => Icons.route_rounded;
	@override
	Color? get initialActiveColor => Colors.amber[300];
	@override
	Color? get secondActiveColor => Colors.blue[200];

  	const DistanceSwitch({super.key});
}

class WaterSwitch extends SettingsSwitch<WaterNotifier>
{
	@override
	IconData get initialIcon => Icons.water_drop_outlined;
	@override
	IconData get secondIcon => Icons.opacity_rounded;
	@override
	Color? get initialActiveColor => Colors.amber[300];
	@override
	Color? get secondActiveColor => Colors.blue[200];

  	const WaterSwitch({super.key});
}