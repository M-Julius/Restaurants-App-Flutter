import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFFE64A0D);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
