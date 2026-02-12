import 'package:calorie_calculator_app/utilities/colours.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
				ScaffoldMessenger.of(context).showSnackBar
				(
					SnackBar
					(
						content: const Center
						(
							child: Text
							(
								'''Couldn't open website''',
								style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
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
	}
}