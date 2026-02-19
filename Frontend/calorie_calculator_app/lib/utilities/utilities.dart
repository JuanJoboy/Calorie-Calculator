import 'package:calorie_calculator/utilities/colours.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils
{
	// If the condition is true, the first option is chosen, otherwise the second is chosen. T allows for any datatype to be returned
	static T whatModeIsIt<T>(bool condition, T option1, T option2)
	{
		return condition ? option1 : option2;
	}

	static Color getBackgroundColor(ThemeData theme)
	{
		return theme.scaffoldBackgroundColor;
	}
}

class Header extends StatelessWidget
{
	final String text;
	final double fontSize;
	final FontWeight fontWeight;
	final Color? color;
	final double topPadding;
	final double rightPadding;
	final double bottomPadding;
	final double leftPadding;

  	const Header({super.key, required this.text, required this.fontSize, required this.fontWeight, this.color, this.topPadding = 32, this.rightPadding = 0, this.bottomPadding = 0, this.leftPadding = 0});

	@override
	Widget build(BuildContext context)
	{
		return Padding
		(
			padding: EdgeInsets.only(top: topPadding, right: rightPadding, left: leftPadding, bottom: bottomPadding),
			child: Center
			(
				child: Text
				(
					text,
					style: TextStyle
					(
						fontSize: fontSize,
						fontWeight: fontWeight,
						color: color ?? Theme.of(context).extension<AppColours>()?.text
					),
				),
			),
		);
	}
}

class WidgetPlusHelper extends StatelessWidget
{
	final Widget mainWidget;
	final HelpIcon helpIcon;
	final double top;
	final double right;
	final double bottom;
	final double left;

  	const WidgetPlusHelper({super.key, required this.mainWidget, required this.helpIcon, this.top = 0, this.right = 0, this.left = 0, this.bottom = 0});

	@override
	Widget build(BuildContext context)
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
}

class HelpIcon extends StatelessWidget
{
	final String msg;

	// The key is created as part of the widget's instance
  	final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>(); // Every helper icon needs their own individual key and this widget makes it for them

	HelpIcon({super.key, required this.msg});

	@override
	Widget build(BuildContext context)
	{
		return GestureDetector
		(
			onTap: () => tooltipKey.currentState?.ensureTooltipVisible(),
			child: Tooltip
			(
				key: tooltipKey,
				triggerMode: TooltipTriggerMode.tap,
				message: msg,
				showDuration: const Duration(seconds: 4),
				child: const Icon(Icons.help, color: Colors.blue),
			),
		);
	}
}

class PageSwitcher extends StatelessWidget
{
	final Widget nextPage;

  	const PageSwitcher({super.key, required this.nextPage});

	@override
	Widget build(BuildContext context)
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

class HyperLinker
{
	static TextSpan hyperlinkText(String hyperText, String websiteUri, BuildContext context)
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

	static Future<void> _launchURL(Uri url, BuildContext context) async
	{
		try
		{
			await launchUrl(url, mode: LaunchMode.inAppBrowserView);
		}
		catch(e)
		{
			if(context.mounted)
			{
				ErrorHandler.showSnackBar(context, '''Couldn't open website''');
			}
		}
	}
}

class ErrorHandler
{
	static void showSnackBar(BuildContext context, String message)
	{
  		ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Clears existing snack bars so they don't queue up

		ScaffoldMessenger.of(context).showSnackBar
		(
			SnackBar
			(
				content: Center
				(
					child: Text
					(
						message,
						style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
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