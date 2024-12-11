//S.Hariprasath
//IM/2021/077

import 'package:flutter/material.dart';
import 'ui/calculator_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = true;

  /// Toggle between dark and light themes
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF22252D),
              appBarTheme:
                  const AppBarTheme(backgroundColor: Color(0xFF22252D)),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            ),
      home: CalculatorHome(
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
