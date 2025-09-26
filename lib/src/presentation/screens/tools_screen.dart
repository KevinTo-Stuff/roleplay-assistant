// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/theme/dimens.dart';

@RoutePage()
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: Center(
          child: Text(
            'Tools will be listed here. This is an example screen wired to AutoRoute.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
