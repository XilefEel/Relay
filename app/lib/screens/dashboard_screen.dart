import 'package:app/widgets/error_view.dart';
import 'package:app/widgets/loading_view.dart';
import 'package:app/widgets/stats_section.dart';
import 'package:flutter/material.dart';
import '../controllers/actions_controller.dart';
import '../controllers/stats_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/actions_section.dart';

class DashboardScreen extends StatefulWidget {
  final ThemeController themeController;
  const DashboardScreen({super.key, required this.themeController});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const String serverIp = '192.168.1.103';

  late final StatsController statsController;
  late final ActionsController actionsController;

  @override
  void initState() {
    super.initState();
    statsController = StatsController(serverIp: serverIp);
    actionsController = ActionsController(serverIp: serverIp);
  }

  @override
  void dispose() {
    statsController.dispose();
    actionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6),
            onSelected: widget.themeController.setMode,
            itemBuilder: (context) => const [
              PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              PopupMenuItem(value: ThemeMode.system, child: Text('System')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: statsController,
          builder: (context, _) {
            return switch (statsController.state) {
              ConnState.connecting => const LoadingView(),
              ConnState.error => ErrorView(
                message: statsController.errorMessage!,
                onRetry: statsController.retry,
              ),
              ConnState.connected => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListenableBuilder(
                    listenable: statsController,
                    builder: (context, _) =>
                        StatsSection(controller: statsController),
                  ),
                  const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: actionsController,
                    builder: (context, _) =>
                        ActionsSection(controller: actionsController),
                  ),
                ],
              ),
            };
          },
        ),
      ),
    );
  }
}
