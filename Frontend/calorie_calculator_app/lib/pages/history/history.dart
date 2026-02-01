import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/database/database.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget
{
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
{
	late AllCalculations _list;

	@override
	Widget build(BuildContext context)
	{
		AllCalculations list = context.watch<AllCalculations>();
		_list = list;

		return Column
		(
			children:
			[
				Expanded
				(
					child: list.calcList.isNotEmpty ? ListView.builder
					(
						physics: const BouncingScrollPhysics(),
						itemCount: list.calcList.length,
						itemBuilder: (context, index)
						{
							return calcWidget(list.calcList, index); // Displays all the calculations
						},
					) : const Center(child: Text("No calcs have been lated :(")) // If the list isn't empty then only print this text
				),

				// ElevatedButton
				// (
				// 	onPressed: () async
				// 	{
				// 		final db = await DatabaseHelper.instance.database;
				// 		db.delete("calcs");
				// 		await db.delete("sqlite_sequence", where: "name = ?", whereArgs: ["calcs"]);
				// 	},
				// 	child: const Padding
				// 	(
				// 		padding: EdgeInsets.all(16.0),
				// 		child: Icon(Icons.bedroom_baby)
				// 	),
				// )
			],
		);
	}

	Widget calcWidget(List<Calculation> list, int index)
	{
		final date = DateTime.parse(list[index].date);
		final day = date.day;
		final month = date.month;
		final year = date.year;
		final bmr = list[index].bmr.toInt();
		final tdee = list[index].tdee.toInt();
		final weight = list[index].weightLiftingBurn.toInt();
		final cardio = list[index].cardioBurn.toInt();
		final epoc = list[index].epoc.toInt();
		final total = list[index].totalBurn.toInt();
		final diff = total - tdee;

		return  Card
		(
			child: Column
			(
				mainAxisSize: MainAxisSize.min,
				children:
				[
					button(index),
					info("$day/$month/$year"),
					info("BMR: $bmr"),
					info("TDEE: $tdee"),
					info("Weight Lifting Burn: $weight"),
					info("Cardio Burn: $cardio"),
					info("EPOC: $epoc"),
					info("Calories Burned: $diff"),
					info("Total Calories Available: $total"),
				]
			),
		);
	}

	Widget info(String text)
	{
		return Text(text);
	}

	Widget button(int? index)
	{
		return Card
		(
			child: ElevatedButton
			(
				onPressed: index == null ? null : ()
				{
					_list.deleteCalc(index);
				},
				child: const Padding
				(
					padding: EdgeInsets.all(16.0),
					child: Icon(Icons.minimize_outlined)
				),
			)
		);
	}
}