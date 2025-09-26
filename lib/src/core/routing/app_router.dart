// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/screens/character_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/home_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/roleplay_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/roleplay_settings_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/settings_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/skills_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/tools_screen.dart';
import 'package:roleplay_assistant/src/shared/models/character.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay_settings.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> routes = <AutoRoute>[
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: RoleplayRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: CharacterRoute.page),
    AutoRoute(page: RoleplaySettingsRoute.page),
    AutoRoute(page: ToolsRoute.page),
    AutoRoute(page: SkillsRoute.page),
  ];
}
