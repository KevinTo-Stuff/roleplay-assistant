// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/environment.dart';
import 'package:roleplay_assistant/src/core/routing/app_router.dart';
import 'package:roleplay_assistant/src/core/settings/settings_cubit.dart';
import 'package:roleplay_assistant/src/core/settings/settings_state.dart';
import 'package:roleplay_assistant/src/core/theme/app_theme.dart';
import 'package:roleplay_assistant/src/shared/locator.dart';

class Application extends StatelessWidget {
  Application({super.key, AppRouter? appRouter})
      : _appRouter = appRouter ?? locator<AppRouter>();
  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          return MaterialApp.router(
            title: Environment.appName,
            routerConfig: _appRouter.config(
              navigatorObservers: () =>
                  <NavigatorObserver>[AutoRouteObserver()],
            ),
            theme: state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
