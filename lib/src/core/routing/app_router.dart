// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:roleplay_assistant/src/presentation/screens/home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> routes = <AutoRoute>[
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}
