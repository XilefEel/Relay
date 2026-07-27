import 'package:flutter/material.dart';

class ActionButtonData {
  final String id;
  final String label;
  final String icon;

  ActionButtonData({required this.id, required this.label, required this.icon});

  factory ActionButtonData.fromJson(Map<String, dynamic> json) {
    return ActionButtonData(
      id: json['id'],
      label: json['label'],
      icon: json['icon'],
    );
  }
}

const Map<String, IconData> _iconMap = {
  'browser': Icons.public,
  'search': Icons.search,
  'music': Icons.music_note,
  'video': Icons.play_circle,
  'camera': Icons.photo_camera,
  'image': Icons.image,
  'edit': Icons.edit_note,
  'code': Icons.code,
  'terminal': Icons.terminal,
  'folder': Icons.folder,
  'notes': Icons.sticky_note_2,
  'calendar': Icons.calendar_today,
  'mail': Icons.mail,
  'chat': Icons.chat_bubble,
  'settings': Icons.settings,
  'lock': Icons.lock,
  'power': Icons.power_settings_new,
  'refresh': Icons.refresh,
  'volume': Icons.volume_up,
  'game': Icons.sports_esports,
  'download': Icons.download,
  'design': Icons.brush,
  'shapes': Icons.category,
};

class ActionButton extends StatelessWidget {
  final ActionButtonData action;
  final VoidCallback onTap;
  final bool isLoading;
  final Color color;
  final Color onColor;
  final BorderRadius radius;

  const ActionButton({
    super.key,
    required this.action,
    required this.onTap,
    required this.color,
    required this.onColor,
    this.radius = const BorderRadius.all(Radius.circular(24)),
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(onColor),
                      ),
                    )
                  : Icon(
                      _iconMap[action.icon] ?? Icons.apps,
                      size: 26,
                      color: onColor,
                    ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
