import 'dart:convert';
import 'package:app/widgets/error_view.dart';
import 'package:app/widgets/loading_view.dart';
import 'package:app/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widgets/history_chart.dart';

enum ConnState { connecting, connected, error }

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const String serverIp = '192.168.1.103';
  static const int maxHistory = 30;

  late final WebSocketChannel channel;

  ConnState state = ConnState.connecting;
  String? errorMessage;

  double cpuUsage = 0;
  int ramUsageMb = 0;
  int ramTotalMb = 0;

  final List<double> cpuHistory = [];
  final List<double> ramHistory = [];

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://$serverIp:3000/ws/stats'),
    );

    channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        final cpu = (data['cpu_usage'] as num).toDouble();
        final ramUsed = data['ram_usage_mb'] as int;
        final ramTotal = data['total_ram_mb'] as int;
        final ramPercent = ramTotal == 0 ? 0.0 : (ramUsed / ramTotal) * 100;

        setState(() {
          cpuUsage = cpu;
          ramUsageMb = ramUsed;
          ramTotalMb = ramTotal;
          state = ConnState.connected;

          cpuHistory.add(cpu);
          if (cpuHistory.length > maxHistory) cpuHistory.removeAt(0);

          ramHistory.add(ramPercent);
          if (ramHistory.length > maxHistory) ramHistory.removeAt(0);
        });
      },
      onError: (error) {
        setState(() {
          state = ConnState.error;
          errorMessage = 'Could not reach server';
        });
      },
      onDone: () {
        setState(() {
          state = ConnState.error;
          errorMessage = 'Disconnected from server';
        });
      },
    );
  }

  void retry() {
    setState(() {
      state = ConnState.connecting;
      errorMessage = null;
      cpuHistory.clear();
      ramHistory.clear();
    });
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
      body: SafeArea(
        child: switch (state) {
          ConnState.connecting => LoadingView(),
          ConnState.error => ErrorView(message: errorMessage!, onRetry: retry),
          ConnState.connected => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'CPU',
                      value: cpuUsage,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'RAM',
                      value: ramTotalMb == 0
                          ? 0
                          : (ramUsageMb / ramTotalMb) * 100,
                      color: Colors.tealAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              HistoryChart(
                label: 'CPU history',
                values: cpuHistory,
                currentValue: cpuUsage,
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 12),
              HistoryChart(
                label: 'RAM history',
                values: ramHistory,
                currentValue: ramTotalMb == 0
                    ? 0
                    : (ramUsageMb / ramTotalMb) * 100,
                color: Colors.tealAccent,
              ),
            ],
          ),
        },
      ),
    );
  }
}
