import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.blue.shade200,
    primary: Colors.blue.shade400,
    onPrimary: Colors.black,
    secondary: Colors.white60,
    onSecondary: Colors.black,
    onSurface: Colors.black, // Text color on surfaces
    onBackground: Colors.black, // Text color on backgrounds
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueAccent,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white30,
    onSecondary: Colors.white,
    onSurface: Colors.white, // Text color on surfaces
    onBackground: Colors.white, // Text color on backgrounds
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
  ),
);
