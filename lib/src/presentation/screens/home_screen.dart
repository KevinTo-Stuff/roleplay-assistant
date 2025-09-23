// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/routing/app_router.dart';
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import 'package:roleplay_assistant/src/shared/extensions/context_extensions.dart';
import 'package:roleplay_assistant/src/shared/widgets/buttons/button.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.spacing),
        children: [
          const SizedBox(height: Dimens.tripleSpacing),
          Text('Roleplay Assistant', style: context.textTheme.titleLarge),
          const SizedBox(height: Dimens.minSpacing),
          Text(
            'Welcome! This app helps you manage and enhance your roleplaying.',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: Dimens.spacing),
          Button.outline(
            title: 'Settings',
            onPressed: () {
              context.router.push(const SettingsRoute());
            },
          ),
        ],
      ),
    );
  }
}
