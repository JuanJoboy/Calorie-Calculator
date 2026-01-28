import 'package:flutter/material.dart';

class AppColours extends ThemeExtension<AppColours>
{
	final Color? backgroundColour;
	final Color? secondaryColour;
	final Color? tertiaryColour;

	const AppColours({required this.backgroundColour, required this.secondaryColour, required this.tertiaryColour});

	@override
	ThemeExtension<AppColours> copyWith({Color? background, Color? secondary, Color? tertiary})
	{
    	return AppColours
		(
			backgroundColour: background ?? backgroundColour,
      		secondaryColour: secondary ?? secondaryColour,
      		tertiaryColour: tertiary ?? tertiaryColour,
    	);
  	}
	
	@override
	ThemeExtension<AppColours> lerp(covariant ThemeExtension<AppColours>? other, double t)
	{
		if (other is! AppColours)
		{
			return this;
		}

		return AppColours
		(
			backgroundColour: Color.lerp(backgroundColour, other.backgroundColour, t),
			secondaryColour: Color.lerp(secondaryColour, other.secondaryColour, t),
			tertiaryColour: Color.lerp(tertiaryColour, other.tertiaryColour, t),
		);
	}
}