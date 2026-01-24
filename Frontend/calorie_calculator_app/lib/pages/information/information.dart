import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget
{
	const InformationPage({super.key});
	
	@override
	Widget build(BuildContext context)
	{
		return Column
		(
			children:
			[
				info(". Basal Metabolic Rate (BMR)", "a"),
			],
		);
  	}

	Widget info(String header, String text)
	{
		return Card
		(
			child: Column
			(
				children:
				[
					Text(header),
					Text(text),
				],
			),
		);
	}
}