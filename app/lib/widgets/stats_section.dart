import 'package:app/controllers/stats_controller.dart';
import 'package:app/theme/app_theme.dart';
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
                color: StatColors.cpu,
                onColor: StatColors.cpuOn,
                radius: BlobRadius.topLeft,
                icon: Icons.memory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'RAM',
                value: ramPercent,
                color: StatColors.ram,
                onColor: StatColors.ramOn,
                radius: BlobRadius.topRight,
                icon: Icons.sd_storage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HistoryChart(
          label: 'CPU history',
          values: controller.cpuHistory,
          currentValue: controller.cpuUsage,
          color: StatColors.cpu,
          onColor: StatColors.cpuOn,
          radius: BlobRadius.bottomLeft,
        ),
        const SizedBox(height: 12),
        HistoryChart(
          label: 'RAM history',
          values: controller.ramHistory,
          currentValue: ramPercent,
          color: StatColors.ram,
          onColor: StatColors.ramOn,
          radius: BlobRadius.bottomRight,
        ),
      ],
    );
  }
}
