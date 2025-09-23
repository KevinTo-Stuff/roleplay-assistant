// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RoleplayScreen extends StatelessWidget {
  const RoleplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roleplay Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Roleplay Screen!'),
      ),
    );
  }
}
