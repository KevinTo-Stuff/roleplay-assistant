// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RoleplayScreen extends StatelessWidget {
  const RoleplayScreen({super.key, this.name});

  /// Optional display name of the roleplay. If null, a generic message is shown.
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name != null && name!.isNotEmpty ? name! : 'Roleplay'),
      ),
      body: Center(
        child: Text(
          name != null && name!.isNotEmpty
              ? 'Roleplay: ${name!}'
              : 'Welcome to the Roleplay Screen!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
