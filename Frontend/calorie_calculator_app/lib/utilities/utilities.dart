import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';

class Utils
{
	static Widget header(String text, double fontSize, FontWeight fontWeight)
	{
		return Padding
		(
			padding: const EdgeInsets.only(top: 40),
			child: Center
			(
				child: Text
				(
					text,
					style: TextStyle
					(
						fontSize: fontSize,
						fontWeight: fontWeight,
					),
				),
			),
		);
	}

	static Widget widgetPlusHelper(Widget mainWidget, HelpIcon helpIcon, {double? top, double? right, double? left, double? bottom})
	{
		return Stack
		(
			clipBehavior: Clip.none,
			children:
			[
				mainWidget,
				Positioned // Adjusts position relative to the mainWidget edge
				(
					right: right,
					top: top,
					left: left,
					bottom: bottom,
					child: helpIcon,
				),
			],
		);
	}
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
		return theme.scaffoldBackgroundColor;
	}

	static bool backgroundColorIsLightMode(ThemeData theme)
	{
		return theme.brightness == Brightness.light ? true : false;
	}

	static ColoredBox switchPage(BuildContext context, Widget nextPage)
	{
		return ColoredBox
		(
			color: getBackgroundColor(Theme.of(context)), // Sets the background colour
			child: AnimatedSwitcher // Automatically cross-fades between pages when the page changes.
			(
				duration: const Duration(milliseconds: 200), // Cross fade duration
				child: nextPage, // Goes to the next page
			)
		);
	}
}