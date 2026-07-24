import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  late final WebSocketChannel channel;

  double? cpuUsage;
  int? ramUsageMb;
  int? ramTotalMb;
  String? errorMessage;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://$serverIp:3000/ws/stats'),
    );

    channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        setState(() {
          cpuUsage = data['cpu_usage'];
          ramUsageMb = data['ram_usage_mb'];
          ramTotalMb = data['total_ram_mb'];
          errorMessage = null;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = 'WebSocket error: $error';
        });
      },
      onDone: () {
        setState(() {
          errorMessage = 'Disconnected from server';
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
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
          ],
        ),
      ),
    );
  }
}
