import 'package:flutter/material.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relay',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        fontFamily: 'GeistMono',
      ),
      home: const StatsScreen(),
    );
  }
}
