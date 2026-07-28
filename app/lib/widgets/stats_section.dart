import 'package:app/controllers/stats_controller.dart';
import 'package:app/theme/app_theme.dart';
import 'package:app/widgets/network_card.dart';
import 'package:flutter/material.dart';

import 'stat_trend_card.dart';
import 'stat_card.dart';

class StatsSection extends StatelessWidget {
  final StatsController controller;

  const StatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final statColors = StatColors.of(context);

    final ramPercent = controller.ramTotalMb == 0
        ? 0.0
        : (controller.ramUsageMb / controller.ramTotalMb) * 100;

    final diskPercent = controller.diskTotalGb == 0
        ? 0.0
        : (controller.diskUsageGb / controller.diskTotalGb) * 100;

    return Column(
      children: [
        StatTrendCard(
          label: 'CPU',
          value: controller.cpuUsage,
          history: controller.cpuHistory,
          color: statColors.cpu,
          onColor: statColors.cpuOn,
          radius: BlobRadius.topLeft,
          icon: Icons.memory,
        ),
        const SizedBox(height: 12),
        StatTrendCard(
          label: 'RAM',
          value: ramPercent,
          history: controller.ramHistory,
          color: statColors.ram,
          onColor: statColors.ramOn,
          radius: BlobRadius.topRight,
          icon: Icons.sd_storage,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Disk',
                value: diskPercent,
                color: statColors.disk,
                onColor: statColors.diskOn,
                radius: BlobRadius.topLeft,
                icon: Icons.memory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NetworkCard(
                downloadKbps: controller.networkDownloadKbps,
                uploadKbps: controller.networkUploadKbps,
                color: statColors.network,
                onColor: statColors.networkOn,
                radius: BlobRadius.bottomRight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
