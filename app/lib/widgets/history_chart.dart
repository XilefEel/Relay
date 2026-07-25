import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryChart extends StatelessWidget {
  final String label;
  final List<double> values;
  final double currentValue;
  final Color color;

  const HistoryChart({
    super.key,
    required this.label,
    required this.values,
    required this.currentValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '${currentValue.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 64,
            child: values.length < 2
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
                            for (int i = 0; i < values.length; i++)
                              FlSpot(i.toDouble(), values[i]),
                          ],
                          isCurved: true,
                          color: color,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                    duration: Duration.zero,
                  ),
          ),
        ],
      ),
    );
  }
}
