// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [RoleplayScreen]
class RoleplayRoute extends PageRouteInfo<RoleplayRouteArgs> {
  RoleplayRoute({
    Key? key,
    required Roleplay roleplay,
    List<PageRouteInfo>? children,
  }) : super(
          RoleplayRoute.name,
          args: RoleplayRouteArgs(key: key, roleplay: roleplay),
          initialChildren: children,
        );

  static const String name = 'RoleplayRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RoleplayRouteArgs>();
      return RoleplayScreen(key: args.key, roleplay: args.roleplay);
    },
  );
}

class RoleplayRouteArgs {
  const RoleplayRouteArgs({this.key, required this.roleplay});

  final Key? key;

  final Roleplay roleplay;

  @override
  String toString() {
    return 'RoleplayRouteArgs{key: $key, roleplay: $roleplay}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoleplayRouteArgs) return false;
    return key == other.key && roleplay == other.roleplay;
  }

  @override
  int get hashCode => key.hashCode ^ roleplay.hashCode;
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
