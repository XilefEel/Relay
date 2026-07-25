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

  const ActionButton({
    super.key,
    required this.action,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_iconMap[action.icon] ?? Icons.apps, size: 28),
              const SizedBox(height: 6),
              Text(action.label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
