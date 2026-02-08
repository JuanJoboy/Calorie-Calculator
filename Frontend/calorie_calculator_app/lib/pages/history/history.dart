import 'package:calorie_calculator_app/main.dart';
import 'package:calorie_calculator_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator_app/pages/calculator/calculations.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget
{
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}

late UsersTdeeNotifier _tdeeNotifier;
bool get tdeeIsNull => _tdeeNotifier.usersTdee == null;

class _HistoryPageState extends State<HistoryPage>
{
	late AllCalculations _list;

	@override
	Widget build(BuildContext context)
	{
		AllCalculations list = context.watch<AllCalculations>();
		_list = list;
		final UsersTdeeNotifier tdeeNotifier = context.watch<UsersTdeeNotifier>();
		_tdeeNotifier = tdeeNotifier;

		if (_tdeeNotifier.usersTdee == null)
		{
			_tdeeNotifier.loadTdee();
		}

		int? b = 0;
		int? t = 0;

		if(!tdeeIsNull)
		{
			b = _tdeeNotifier.usersTdee?.bmr.round();
			t = _tdeeNotifier.usersTdee?.tdee.round();
		}

		return Column
		(
			children:
			[
				Utils.header("BMR: $b	|	TDEE: $t", 30, FontWeight.bold),

				darkModeButton(),

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

		return Card
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
					info("Caloric Ceiling: $total"),
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

	Widget darkModeButton()
	{
		return Switch
		(
			padding: const EdgeInsets.only(top: 30),
			value: context.read<ThemeNotifier>().isLightMode,
			onChanged: (newValue)
			{
				setState(()
				{
					context.read<ThemeNotifier>().isLightMode = newValue;
					context.read<ThemeNotifier>().changeTheme();
				});
			},
			thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states)
			{
				if(states.contains(WidgetState.selected))
				{
					return const Icon(Icons.nights_stay_rounded, size: 20);
				}

				return const Icon(Icons.sunny, size: 20);
			}),
			thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states)
			{
				if(states.contains(WidgetState.selected))
				{
					return Colors.black;
				}

				return Colors.black;
			}),
			inactiveTrackColor: Colors.amber[300],
			activeTrackColor: Colors.blue[200],
		);
	}
}