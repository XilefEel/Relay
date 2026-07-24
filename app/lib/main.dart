import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Relay', home: const StatsScreen());
  }
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const String serverIp = '192.168.1.103';

  double? cpuUsage;
  int? ramUsageMb;
  int? ramTotalMb;
  String? errorMessage;

  Future<void> fetchStats() async {
    try {
      final response = await http.get(
        Uri.parse('http://$serverIp:3000/api/stats'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cpuUsage = data['cpu_usage'];
          ramUsageMb = data['ram_usage_mb'];
          ramTotalMb = data['total_ram_mb'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Could not connect: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relay')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (cpuUsage != null) ...[
              Text(
                'CPU: ${cpuUsage!.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'RAM: $ramUsageMb / $ramTotalMb MB',
                style: const TextStyle(fontSize: 24),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(onPressed: fetchStats, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
