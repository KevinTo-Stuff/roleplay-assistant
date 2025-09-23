// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(roleplay.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              roleplay.description.isNotEmpty
                  ? roleplay.description
                  : 'No description provided.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 20),
            // Placeholder for further roleplay details and editing UI
            const Text('Roleplay details and editor will go here.'),
          ],
        ),
      ),
    );
  }
}
