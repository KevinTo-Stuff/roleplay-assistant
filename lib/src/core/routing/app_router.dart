// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/screens/home_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/roleplay_screen.dart';
import 'package:roleplay_assistant/src/presentation/screens/settings_screen.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> routes = <AutoRoute>[
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: RoleplayRoute.page),
    AutoRoute(page: SettingsRoute.page),
  ];
}
