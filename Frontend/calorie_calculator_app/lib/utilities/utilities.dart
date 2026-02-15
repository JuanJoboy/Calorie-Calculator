import 'package:calorie_calculator_app/utilities/help.dart';
import 'package:flutter/material.dart';

class Utils
{
	static Widget header(String text, double fontSize, FontWeight fontWeight, {double? padding, Color? color})
	{
		return Padding
		(
			padding: EdgeInsets.only(top: padding ?? 40),
			child: Center
			(
				child: Text
				(
					text,
					style: TextStyle
					(
						fontSize: fontSize,
						fontWeight: fontWeight,
						color: color
					),
					overflow: TextOverflow.fade,
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

	// If the condition is true, the first option is chosen, otherwise the second is chosen. T allows for any datatype to be returned
	static T whatModeIsIt<T>(bool condition, T option1, T option2)
	{
		return condition ? option1 : option2;
	}

	static Color getBackgroundColor(ThemeData theme)
	{
		return theme.scaffoldBackgroundColor;
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