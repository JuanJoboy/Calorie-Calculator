import 'package:flutter/material.dart';

class AppColours extends ThemeExtension<AppColours>
{
	final Color? text;
    final Color? backgroundColour;
    final Color? secondaryColour;
    final Color? tertiaryColour;
    final Color? maleUnColour;
    final Color? maleSeColour;
    final Color? femaleUnColour;
    final Color? femaleSeColour;
    final Color? runUnColour;
    final Color? runSeColour;
    final Color? cycleUnColour;
    final Color? cycleSeColour;
    final Color? aerobicOutlineColour;
    final Color? aerobicBackgroundColour;
    final Color? anaerobicOutlineColour;
    final Color? anaerobicBackgroundColour;
    final Color? maximalOutlineColour;
    final Color? maximalBackgroundColour;
    final Color? bmr;
	final Color? caloricBurn;
	final Color? caloricBurn2;
	final Color? disclaimer;
	final Color? fairyPink;
	final Color? innerYellow;
	final Color? outerYellow;

    const AppColours
    (
        {
			required this.text,
            required this.backgroundColour,
            required this.secondaryColour,
            required this.tertiaryColour,
            required this.maleUnColour,
            required this.maleSeColour,
            required this.femaleUnColour,
            required this.femaleSeColour,
            required this.runUnColour,
            required this.runSeColour,
            required this.cycleUnColour,
            required this.cycleSeColour,
            required this.aerobicOutlineColour,
            required this.aerobicBackgroundColour,
            required this.anaerobicOutlineColour,
            required this.anaerobicBackgroundColour,
            required this.maximalOutlineColour,
            required this.maximalBackgroundColour,
			required this.bmr,
			required this.caloricBurn,
			required this.caloricBurn2,
			required this.disclaimer,
			required this.fairyPink,
			required this.innerYellow,
			required this.outerYellow,
        }
    );

    @override
    AppColours copyWith
    (
        {
			Color? text,
            Color? backgroundColour,
            Color? secondaryColour,
            Color? tertiaryColour,
            Color? maleUnColour,
            Color? maleSeColour,
            Color? femaleUnColour,
            Color? femaleSeColour,
            Color? runUnColour,
            Color? runSeColour,
            Color? cycleUnColour,
            Color? cycleSeColour,
            Color? aerobicOutlineColour,
            Color? aerobicBackgroundColour,
            Color? anaerobicOutlineColour,
            Color? anaerobicBackgroundColour,
            Color? maximalOutlineColour,
            Color? maximalBackgroundColour,
			Color? bmr,
			Color? caloricBurn,
			Color? caloricBurn2,
			Color? disclaimer,
			Color? fairyPink,
			Color? innerYellow,
			Color? outerYellow,
        }
    )
    {
        return AppColours
        (
			text: text ?? this.text,
            backgroundColour: backgroundColour ?? this.backgroundColour,
            secondaryColour: secondaryColour ?? this.secondaryColour,
            tertiaryColour: tertiaryColour ?? this.tertiaryColour,
            maleUnColour: maleUnColour ?? this.maleUnColour,
            maleSeColour: maleSeColour ?? this.maleSeColour,
            femaleUnColour: femaleUnColour ?? this.femaleUnColour,
            femaleSeColour: femaleSeColour ?? this.femaleSeColour,
            runUnColour: runUnColour ?? this.runUnColour,
            runSeColour: runSeColour ?? this.runSeColour,
            cycleUnColour: cycleUnColour ?? this.cycleUnColour,
            cycleSeColour: cycleSeColour ?? this.cycleSeColour,
            aerobicOutlineColour: aerobicOutlineColour ?? this.aerobicOutlineColour,
            aerobicBackgroundColour: aerobicBackgroundColour ?? this.aerobicBackgroundColour,
            anaerobicOutlineColour: anaerobicOutlineColour ?? this.anaerobicOutlineColour,
            anaerobicBackgroundColour: anaerobicBackgroundColour ?? this.anaerobicBackgroundColour,
            maximalOutlineColour: maximalOutlineColour ?? this.maximalOutlineColour,
            maximalBackgroundColour: maximalBackgroundColour ?? this.maximalBackgroundColour,
			bmr: bmr ?? this.bmr,
			caloricBurn: caloricBurn ?? this.caloricBurn,
			caloricBurn2: caloricBurn2 ?? this.caloricBurn2,
			disclaimer: disclaimer ?? this.disclaimer,
			fairyPink: fairyPink ?? this.fairyPink,
			innerYellow: innerYellow ?? this.innerYellow,
			outerYellow: outerYellow ?? this.outerYellow,
        );
    }

    @override
    AppColours lerp(ThemeExtension<AppColours>? other, double t)
    {
        if (other is! AppColours)
        {
            return this;
        }

        return AppColours
        (
			text: Color.lerp(text, other.text, t),
            backgroundColour: Color.lerp(backgroundColour, other.backgroundColour, t),
            secondaryColour: Color.lerp(secondaryColour, other.secondaryColour, t),
            tertiaryColour: Color.lerp(tertiaryColour, other.tertiaryColour, t),
            maleUnColour: Color.lerp(maleUnColour, other.maleUnColour, t),
            maleSeColour: Color.lerp(maleSeColour, other.maleSeColour, t),
            femaleUnColour: Color.lerp(femaleUnColour, other.femaleUnColour, t),
            femaleSeColour: Color.lerp(femaleSeColour, other.femaleSeColour, t),
            runUnColour: Color.lerp(runUnColour, other.runUnColour, t),
            runSeColour: Color.lerp(runSeColour, other.runSeColour, t),
            cycleUnColour: Color.lerp(cycleUnColour, other.cycleUnColour, t),
            cycleSeColour: Color.lerp(cycleSeColour, other.cycleSeColour, t),
            aerobicOutlineColour: Color.lerp(aerobicOutlineColour, other.aerobicOutlineColour, t),
            aerobicBackgroundColour: Color.lerp(aerobicBackgroundColour, other.aerobicBackgroundColour, t),
            anaerobicOutlineColour: Color.lerp(anaerobicOutlineColour, other.anaerobicOutlineColour, t),
            anaerobicBackgroundColour: Color.lerp(anaerobicBackgroundColour, other.anaerobicBackgroundColour, t),
            maximalOutlineColour: Color.lerp(maximalOutlineColour, other.maximalOutlineColour, t),
            maximalBackgroundColour: Color.lerp(maximalBackgroundColour, other.maximalBackgroundColour, t),
			bmr: Color.lerp(bmr, other.bmr, t),
			caloricBurn: Color.lerp(caloricBurn, other.caloricBurn, t),
			caloricBurn2: Color.lerp(caloricBurn2, other.caloricBurn2, t),
			disclaimer: Color.lerp(disclaimer, other.disclaimer, t),
			fairyPink: Color.lerp(fairyPink, other.fairyPink, t),
			innerYellow: Color.lerp(innerYellow, other.innerYellow, t),
			outerYellow: Color.lerp(outerYellow, other.outerYellow, t),
        );
    }
}