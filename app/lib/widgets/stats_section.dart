import 'package:app/controllers/stats_controller.dart';
import 'package:flutter/material.dart';

import 'history_chart.dart';
import 'stat_card.dart';

class StatsSection extends StatelessWidget {
  final StatsController controller;

  const StatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ramPercent = controller.ramTotalMb == 0
        ? 0.0
        : (controller.ramUsageMb / controller.ramTotalMb) * 100;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'CPU',
                value: controller.cpuUsage,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'RAM',
                value: ramPercent,
                color: Colors.tealAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HistoryChart(
          label: 'CPU history',
          values: controller.cpuHistory,
          currentValue: controller.cpuUsage,
          color: Colors.deepPurpleAccent,
        ),
        const SizedBox(height: 12),
        HistoryChart(
          label: 'RAM history',
          values: controller.ramHistory,
          currentValue: ramPercent,
          color: Colors.tealAccent,
        ),
      ],
    );
  }
}
