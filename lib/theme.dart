import 'package:flutter/material.dart';

const primaryOrange = Color(0xFFFF7A18);

final appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: primaryOrange,
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),
);
