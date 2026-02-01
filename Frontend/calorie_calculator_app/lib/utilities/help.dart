import 'package:flutter/material.dart';

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