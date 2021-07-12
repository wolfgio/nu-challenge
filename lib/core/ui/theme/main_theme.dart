import 'package:flutter/material.dart';

import '../../utils/color_generator.dart';
import '../styles/colors.dart';

final mainTheme = ThemeData(
  primarySwatch: materialColorFromHex(0xFF2aa2bd),
  primaryColor: ColorsPallete.primary,
  accentColor: ColorsPallete.accent,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
);
