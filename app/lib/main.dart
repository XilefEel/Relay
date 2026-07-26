import 'package:flutter/material.dart';
import 'controllers/theme_controller.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Relay',
          themeMode: themeController.mode,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            fontFamily: 'GeistMono',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            fontFamily: 'GeistMono',
          ),
          home: DashboardScreen(themeController: themeController),
        );
      },
    );
  }
}
