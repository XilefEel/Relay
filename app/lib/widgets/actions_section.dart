import 'package:flutter/material.dart';
import '../controllers/actions_controller.dart';
import 'action_button.dart';

class ActionsSection extends StatelessWidget {
  final ActionsController controller;

  const ActionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.actions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: controller.actions.map((action) {
            return ActionButton(
              action: action,
              isLoading: controller.runningActionId == action.id,
              onTap: () => controller.runAction(action.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
