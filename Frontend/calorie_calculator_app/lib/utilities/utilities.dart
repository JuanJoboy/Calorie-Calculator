import 'package:flutter/material.dart';

class Utils
{
	static Color? getColor(double? rating, ThemeData theme)
	{
		final bool lightMode = theme.brightness == Brightness.light;

		if(rating != null)
		{
			if(lightMode)
			{
				return Color.lerp(const Color.fromARGB(225, 255, 0, 0), const Color.fromARGB(255, 50, 255, 0), (rating / 10));
			}
			else
			{
				return Color.lerp(const Color.fromARGB(255, 152, 27, 27), const Color.fromARGB(255, 27, 152, 5), (rating / 10)); // Slightly duller, so that it doesn't look weirdly neon on dark mode
			}
		}
		else
		{
			if(lightMode)
			{
				return theme.colorScheme.onPrimary;
			}
			else
			{
				return Colors.black;
			}
		}
	}

	static Color getBackgroundColor(ThemeData theme)
	{
		// If the mode is light, then return surfaceContainerLow, else return blueGrey if its dark mode
		return theme.brightness == Brightness.light ? theme.colorScheme.surfaceContainerLow : Colors.blueGrey;
	}

	static bool backgroundColorIsLightMode(ThemeData theme)
	{
		return theme.brightness == Brightness.light ? true : false;
	}

	static ColoredBox switchPage(BuildContext context, Widget nextPage)
	{
		return ColoredBox
		(
			color: Utils.getBackgroundColor(Theme.of(context)), // Sets the background colour
			child: AnimatedSwitcher // Automatically cross-fades between pages when the page changes.
			(
				duration: const Duration(milliseconds: 200), // Cross fade duration
				child: nextPage, // Goes to the next page
			)
		);
	}
}