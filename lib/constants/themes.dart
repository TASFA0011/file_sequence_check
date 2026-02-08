import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFFF9F9FA),
    focusColor: const Color.fromARGB(0, 0, 0, 0));

final ThemeData darkTheme = ThemeData.dark(useMaterial3: true)
    .copyWith(primaryColor: Colors.orange, focusColor: Colors.transparent);
