import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class StatTrendCard extends StatelessWidget {
  final String label;
  final double value;
  final List<double> history;
  final Color color;
  final Color onColor;
  final BorderRadius radius;
  final IconData icon;

  const StatTrendCard({
    super.key,
    required this.label,
    required this.value,
    required this.history,
    required this.color,
    required this.onColor,
    required this.icon,
    this.radius = BlobRadius.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: radius),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 84,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: onColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: onColor, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: onColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        color: onColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        color: onColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 56,
              child: history.length < 2
                  ? const SizedBox()
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 100,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (int i = 0; i < history.length; i++)
                                FlSpot(i.toDouble(), history[i]),
                            ],
                            isCurved: true,
                            color: onColor,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: onColor.withValues(alpha: 0.16),
                            ),
                          ),
                        ],
                      ),
                      duration: Duration.zero,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
