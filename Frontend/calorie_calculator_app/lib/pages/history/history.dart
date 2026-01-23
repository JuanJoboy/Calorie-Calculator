import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget
{
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
{
	@override
	Widget build(BuildContext context)
	{
		// final HistorysList list = context.watch<HistorysList>();

		return Column
		(
			// children:
			// [
			// 	Expanded
			// 	(
			// 		child: list.restList.isNotEmpty ? ListView.builder
			// 		(
			// 			itemCount: list.restList.length,
			// 			itemBuilder: (context, index)
			// 			{
			// 				return HistoryWidget(list.restList, index); // Displays all the restaurant folders
			// 			},
			// 		) : const Center(child: Text("No meals have been filed :(")) // If the list isn't empty then only print this text
			// 	)
			// ],
		);
	}
}

// date uploaded:          bmr         additional calories from workout           total calories needed for the day (bmr + additional)