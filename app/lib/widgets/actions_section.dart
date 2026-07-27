import 'package:flutter/material.dart';
import '../controllers/actions_controller.dart';
import '../theme/app_theme.dart';
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
          'Quick Launch',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(controller.actions.length, (i) {
            final action = controller.actions[i];
            final fillIdx = i % StatColors.actionFills.length;
            final shapeIdx = i % BlobRadius.cycle.length;

            return ActionButton(
              action: action,
              isLoading: controller.runningActionId == action.id,
              onTap: () => controller.runAction(action.id),
              color: StatColors.actionFills[fillIdx],
              onColor: StatColors.actionOnFills[fillIdx],
              radius: BlobRadius.cycle[shapeIdx],
            );
          }),
        ),
      ],
    );
  }
}
