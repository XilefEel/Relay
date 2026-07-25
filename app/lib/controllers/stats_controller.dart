import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnState { connecting, connected, error }

class StatsController extends ChangeNotifier {
  final String serverIp;
  static const int maxHistory = 30;

  StatsController({required this.serverIp}) {
    _connect();
  }

  late final WebSocketChannel _channel;

  ConnState state = ConnState.connecting;
  String? errorMessage;

  double cpuUsage = 0;
  int ramUsageMb = 0;
  int ramTotalMb = 0;

  final List<double> cpuHistory = [];
  final List<double> ramHistory = [];

  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);
    final cpu = (data['cpu_usage'] as num).toDouble();
    final ramUsed = data['ram_usage_mb'] as int;
    final ramTotal = data['total_ram_mb'] as int;
    final ramPercent = ramTotal == 0 ? 0.0 : (ramUsed / ramTotal) * 100;

    cpuUsage = cpu;
    ramUsageMb = ramUsed;
    ramTotalMb = ramTotal;
    state = ConnState.connected;

    cpuHistory.add(cpu);
    if (cpuHistory.length > maxHistory) cpuHistory.removeAt(0);

    ramHistory.add(ramPercent);
    if (ramHistory.length > maxHistory) ramHistory.removeAt(0);

    notifyListeners();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://$serverIp:3000/ws/stats'),
    );

    _channel.stream.listen(
      _handleMessage,
      onError: (error) {
        state = ConnState.error;
        errorMessage = 'Could not reach server';
        notifyListeners();
      },
      onDone: () {
        state = ConnState.error;
        errorMessage = 'Disconnected from server';
        notifyListeners();
      },
    );
  }

  void retry() {
    state = ConnState.connecting;
    errorMessage = null;
    cpuHistory.clear();
    ramHistory.clear();
    notifyListeners();
    _connect();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
