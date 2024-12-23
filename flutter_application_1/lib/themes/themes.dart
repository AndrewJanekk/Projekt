import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade400, 
    onPrimary: Colors.grey.shade300, 
    secondary: Colors.grey.shade200, 
    onSecondary: Colors.grey.shade100,)
);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade900,
    onPrimary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    onSecondary: Colors.grey.shade600,
  )
);