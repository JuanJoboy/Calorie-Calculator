import 'package:calorie_calculator/pages/planner/folder_data.dart';
import 'package:calorie_calculator/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:calorie_calculator/pages/calculator/burn.dart';
import 'package:calorie_calculator/utilities/utilities.dart';
import 'package:provider/provider.dart';

class WeekPage extends StatefulWidget
{
	final int? weeklyPlanId;
	final bool isEditing;
	final double bmr;
	final double age;
	final bool male;
	final double tdee;
	final double personWeight;
	final double additionalCalories;
	
	const WeekPage({super.key, required this.weeklyPlanId, required this.isEditing, required this.bmr, required this.age, required this.male, required this.tdee, required this.personWeight, required this.additionalCalories});

	@override
	State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage>
{
	final TextEditingController _folderName = TextEditingController();

	late FolderNotifier _folder;
	late WeeklyPlanNotifier _plan;

	bool _isSaving = false;

	@override
	void dispose()
	{
		super.dispose();
		_folderName.dispose();
	}

	@override void initState()
	{
    	super.initState();

		_folder = context.read<FolderNotifier>();

		_plan = context.read<WeeklyPlanNotifier>();

		// Ensures that the name of the folder doesn't show the previous folders name (since I save the fields with a ChangeNotifier, the prev folder name stays)
		if(widget.isEditing)
		{
			int realIndex = _plan.weeklyPlans.indexWhere((plan) => plan.id == widget.weeklyPlanId);
			_folderName.text = _plan.weeklyPlans[realIndex].folderName;
		}
		else
		{
			_folderName.text = _folder.name;
		}
  	}

	@override
	Widget build(BuildContext context)
	{
		return PopScope // Theres a popScope in BMR page but its good here cause if the user exits here, then the plan is still deleted. And the deleteWeeklyPlan() method has safeguards to prevent deleting the same plan twice.
		(
			canPop: false, // Prevent immediate pop
			onPopInvokedWithResult: (didPop, result) async
			{
				if (didPop) return;

				// Delete the plan from DB since they are cancelling
				if (widget.weeklyPlanId != null && !_isSaving && widget.isEditing == false)
				{
					final WeeklyPlanNotifier plan = context.read<WeeklyPlanNotifier>();
					await plan.deleteWeeklyPlan(widget.weeklyPlanId!);
				}

				if (context.mounted)
				{
					Navigator.pop(context);
				}
			},
			child: Scaffold
			(
				backgroundColor: Utils.getBackgroundColor(Theme.of(context)),
				appBar: AppBar(title: const Text("Input Weekly Plan")),
				body: SingleChildScrollView
				(
					physics: const BouncingScrollPhysics(),
					child: Center
					(
						child: Column
						(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children:
							[
								const Header(text: "This Week's Plan", fontSize: 30, fontWeight: FontWeight.bold, bottomPadding: 16),
								
								_textBox(),

								_button("Monday", dayId: 0),
								_button("Tuesday", dayId: 1),
								_button("Wednesday", dayId: 2),
								_button("Thursday", dayId: 3),
								_button("Friday", dayId: 4),
								_button("Saturday", dayId: 5),
								_button("Sunday", dayId: 6),

								_button("Save Plan", saveWeek: true),

								const Padding(padding: EdgeInsetsGeometry.only(top: 100))
							]
						)
					)
				)
			)
		);
	}

	Widget _textBox()
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return Padding
		(
			padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
			child: SizedBox
			(
				height: 200,
				width: double.infinity,
				child: Card
				(
					color: colour.tertiaryColour!,
					shape: RoundedRectangleBorder
					(
						side: BorderSide
						(
							color: colour.secondaryColour!,
							width: 6
						),
						borderRadius: BorderRadiusGeometry.circular(20)
					),
					child: Column
					(
						children:
						[
							const Padding
							(
								padding: EdgeInsets.only(top: 15.0),
								child: Text
								(
									"Weekly Plan Name",
									style: TextStyle
									(
										fontSize: 30,
										fontWeight: FontWeight.w500
									)
								),
							),
				
							Row
							(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children:
								[
									Padding
									(
										padding: const EdgeInsets.only(top: 30.0),
										child: SizedBox
										(
											height: 60,
											width: 250,
											child: Card
											(
												shape: RoundedRectangleBorder
												(
													side: BorderSide
													(
														color: colour.secondaryColour!,
														width: 2
													),
													borderRadius: BorderRadiusGeometry.circular(100)
												),
												color: colour.secondaryColour!,
												child: TextField
												(
													textAlign: TextAlign.center,
													decoration: const InputDecoration
													(
														hintText: "...",
														border: InputBorder.none,
													),
													style: const TextStyle
													(
														fontSize: 25,
													),
													controller: _folderName,
													onChanged: (value)
													{
														_folder.updateControllers(folderName: value);
													},
												),
											),
										),
									),
								],
							)
						],
					),
				),
			),
		);
	}
	
	Widget _button(String text, {bool? saveWeek = false, int? dayId})
	{
		final colour = Theme.of(context).extension<AppColours>()!;

		return GestureDetector
		(
			onTap: () async
			{
				if (saveWeek == false)
				{
					_goToNextPage(exit: false, dayId: dayId!);
				}
				else
				{
					_goToNextPage(exit: true);
				}
			},
			child: Padding
			(
				padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
				child: SizedBox
				(
					height: 130,
					width: double.infinity,
					child: Card
					(
						color: colour.femaleUnColour!,
						shape: RoundedRectangleBorder
						(
							side: BorderSide
							(
								color: colour.secondaryColour!,
								width: 4
							),
							borderRadius: BorderRadiusGeometry.circular(20)
						),
						child: Center
						(
							child: Text
							(
								text,
								textAlign: TextAlign.center,
								style: TextStyle
								(
									fontSize: 40,
									fontWeight: FontWeight.w900,
									color: saveWeek != null && saveWeek == true ? colour.runSeColour! : colour.femaleSeColour!,
								)
							),
						),
					),
				),
			),
		);
	}

	void _goToNextPage({bool? exit, int? dayId}) async
	{
		if(exit! == false)
		{
			await Navigator.push
			(
				context,
				MaterialPageRoute(builder: (context) => Scaffold // ChoiceChips in the bmr page need a scaffold at the root, so i need this here
				(
					body: PageSwitcher(nextPage: BurnPage(bmr: widget.bmr, age: widget.age, male: widget.male, tdee: widget.tdee, personWeight: widget.personWeight, additionalCalories: widget.additionalCalories, weeklyPlanner: true, weeklyPlanId: widget.weeklyPlanId, dayId: dayId!))
				))
			);
		}
		else
		{
			try
			{
				_isSaving = true;

				final String name = _folderName.text.trim() == "" ? "New Weekly Plan" : _folderName.text.trim();

				await _plan.uploadOrEditWeeklyPlan(name, widget.weeklyPlanId);

				if(mounted)
				{
					Navigator.popUntil
					(
						context,
						(route) => route.isFirst
					);
				}
			}
			catch(e)
			{
				if(mounted)
				{
					ErrorHandler.showSnackBar(context, "An error occurred in saving your plan");
					debugPrint("Debug Print: ${e.toString()}");
				}
			}
		}
	}
}