import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NetworkCard extends StatelessWidget {
  final int downloadKbps;
  final int uploadKbps;
  final Color color;
  final Color onColor;
  final BorderRadius radius;

  const NetworkCard({
    super.key,
    required this.downloadKbps,
    required this.uploadKbps,
    required this.color,
    required this.onColor,
    this.radius = BlobRadius.bottomLeft,
  });

  String _format(int kbps) {
    if (kbps >= 1000) {
      final mbps = kbps / 1000;
      return '${mbps.toStringAsFixed(mbps >= 10 ? 0 : 1)} MB/s';
    }
    return '$kbps KB/s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: radius),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Network',
                style: TextStyle(
                  color: onColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: onColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.wifi, color: onColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SpeedRow(
            icon: Icons.arrow_downward_rounded,
            value: _format(downloadKbps),
            onColor: onColor,
          ),
          const SizedBox(height: 8),
          _SpeedRow(
            icon: Icons.arrow_upward_rounded,
            value: _format(uploadKbps),
            onColor: onColor,
          ),
        ],
      ),
    );
  }
}

class _SpeedRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color onColor;

  const _SpeedRow({
    required this.icon,
    required this.value,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: onColor),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: onColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
