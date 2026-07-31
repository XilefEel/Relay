import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnState { connecting, connected, error }

class StatsController extends ChangeNotifier {
  final String serverIp;
  static const int maxHistory = 30;
  static const Duration connectionTimeout = Duration(seconds: 5);

  StatsController({required this.serverIp}) {
    _connect();
  }

  late WebSocketChannel _channel;
  Timer? _connectionTimer;

  ConnState state = ConnState.connecting;
  String? errorMessage;

  double cpuUsage = 0;
  int ramUsageMb = 0;
  int ramTotalMb = 0;
  int diskUsageGb = 0;
  int diskTotalGb = 0;
  int networkDownloadKbps = 0;
  int networkUploadKbps = 0;

  final List<double> cpuHistory = [];
  final List<double> ramHistory = [];

  void _handleMessage(dynamic message) {
    _connectionTimer?.cancel();
    final data = jsonDecode(message);

    cpuUsage = (data['cpu_usage'] as num).toDouble();

    ramUsageMb = data['ram_usage_mb'] as int;
    ramTotalMb = data['total_ram_mb'] as int;
    final ramPercent = ramTotalMb == 0 ? 0.0 : (ramUsageMb / ramTotalMb) * 100;

    diskUsageGb = data['disk_usage_gb'] as int;
    diskTotalGb = data['disk_total_gb'] as int;

    networkDownloadKbps = (data['network_download_kbps'] as num).toInt();
    networkUploadKbps = (data['network_upload_kbps'] as num).toInt();

    state = ConnState.connected;

    cpuHistory.add(cpuUsage);
    if (cpuHistory.length > maxHistory) cpuHistory.removeAt(0);

    ramHistory.add(ramPercent);
    if (ramHistory.length > maxHistory) ramHistory.removeAt(0);

    notifyListeners();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://$serverIp:3000/ws/stats'),
    );

    _connectionTimer = Timer(connectionTimeout, () {
      if (state == ConnState.connecting) {
        state = ConnState.error;
        errorMessage = 'Could not reach server';
        notifyListeners();
      }
    });

    _channel.stream.listen(
      _handleMessage,
      onError: (error) {
        _connectionTimer?.cancel();
        state = ConnState.error;
        errorMessage = 'Could not reach server';
        notifyListeners();
      },
      onDone: () {
        _connectionTimer?.cancel();
        state = ConnState.error;
        errorMessage = 'Disconnected from server';
        notifyListeners();
      },
    );
  }

  void retry() {
    _connectionTimer?.cancel();
    state = ConnState.connecting;
    errorMessage = null;
    cpuHistory.clear();
    ramHistory.clear();
    notifyListeners();
    _connect();
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    _channel.sink.close();
    super.dispose();
  }
}
