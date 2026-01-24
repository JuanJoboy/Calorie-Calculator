import 'package:flutter/material.dart';
import 'package:food_files_app/database/database.dart';
import 'package:food_files_app/pages/calculator/calculations.dart';
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
						itemCount: list.calcList.length,
						itemBuilder: (context, index)
						{
							return calcWidget(list.calcList, index); // Displays all the calculations
						},
					) : const Center(child: Text("No calcs have been lated :(")) // If the list isn't empty then only print this text
				),

				ElevatedButton
				(
					onPressed: () async
					{
						final db = await DatabaseHelper.instance.database;
						db.delete("calcs");
						await db.delete("sqlite_sequence", where: "name = ?", whereArgs: ["calcs"]);
					},
					child: const Padding
					(
						padding: EdgeInsets.all(16.0),
						child: Icon(Icons.bedroom_baby)
					),
				)
			],
		);
	}

	Widget calcWidget(List<Calculation> list, int index)
	{
		final date = list[index].date;
		final bmr = list[index].bmr;
		final tdee = list[index].tdee;
		final weight = list[index].weightLiftingBurn;
		final cardio = list[index].cardioBurn;
		final epoc = list[index].epoc;
		final total = list[index].totalBurn;

		return Card
		(
			child: Expanded
			(
				child: Column
				(
					children:
					[
						button(index),
						info(date),
						info("$bmr"),
						info("$tdee"),
						info("$weight"),
						info("$cardio"),
						info("$epoc"),
						info("$total"),
					]
				)
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

// date uploaded:          bmr         additional calories from workout           total calories needed for the day (bmr + additional)