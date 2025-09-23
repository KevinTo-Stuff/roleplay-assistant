// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/core/theme/dimens.dart';

@RoutePage()
class RoleplayScreen extends StatelessWidget {
  const RoleplayScreen({super.key, required this.roleplay});

  /// The full Roleplay object to display and edit.
  final Roleplay roleplay;

  @override
  Widget build(BuildContext context) {
    final String title = roleplay.name.isNotEmpty ? roleplay.name : 'Roleplay';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              roleplay.description.isNotEmpty
                  ? roleplay.description
                  : 'No description provided.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: Dimens.spacing),
            Row(
              children: <Widget>[
                const Text('Active: '),
                Icon(
                  roleplay.active ? Icons.check_circle : Icons.cancel,
                  color: roleplay.active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacing),
            // Placeholder for further roleplay details and editing UI
            const Text('Roleplay details and editor will go here.'),
          ],
        ),
      ),
    );
  }
}
