// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CharacterScreen]
class CharacterRoute extends PageRouteInfo<CharacterRouteArgs> {
  CharacterRoute({
    Key? key,
    List<Character> characters = const [],
    ValueChanged<List<Character>>? onChanged,
    RoleplaySettings? settings,
    List<PageRouteInfo>? children,
  }) : super(
          CharacterRoute.name,
          args: CharacterRouteArgs(
            key: key,
            characters: characters,
            onChanged: onChanged,
            settings: settings,
          ),
          initialChildren: children,
        );

  static const String name = 'CharacterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CharacterRouteArgs>(
        orElse: () => const CharacterRouteArgs(),
      );
      return CharacterScreen(
        key: args.key,
        characters: args.characters,
        onChanged: args.onChanged,
        settings: args.settings,
      );
    },
  );
}

class CharacterRouteArgs {
  const CharacterRouteArgs({
    this.key,
    this.characters = const [],
    this.onChanged,
    this.settings,
  });

  final Key? key;

  final List<Character> characters;

  final ValueChanged<List<Character>>? onChanged;

  final RoleplaySettings? settings;

  @override
  String toString() {
    return 'CharacterRouteArgs{key: $key, characters: $characters, onChanged: $onChanged, settings: $settings}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CharacterRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(characters, other.characters) &&
        onChanged == other.onChanged &&
        settings == other.settings;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const ListEquality().hash(characters) ^
      onChanged.hashCode ^
      settings.hashCode;
}

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
/// [ItemsScreen]
class ItemsRoute extends PageRouteInfo<void> {
  const ItemsRoute({List<PageRouteInfo>? children})
      : super(ItemsRoute.name, initialChildren: children);

  static const String name = 'ItemsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ItemsScreen();
    },
  );
}

/// generated route for
/// [MapsScreen]
class MapsRoute extends PageRouteInfo<void> {
  const MapsRoute({List<PageRouteInfo>? children})
      : super(MapsRoute.name, initialChildren: children);

  static const String name = 'MapsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MapsScreen();
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
/// [RoleplaySettingsScreen]
class RoleplaySettingsRoute extends PageRouteInfo<RoleplaySettingsRouteArgs> {
  RoleplaySettingsRoute({
    Key? key,
    required RoleplaySettings initial,
    List<PageRouteInfo>? children,
  }) : super(
          RoleplaySettingsRoute.name,
          args: RoleplaySettingsRouteArgs(key: key, initial: initial),
          initialChildren: children,
        );

  static const String name = 'RoleplaySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RoleplaySettingsRouteArgs>();
      return RoleplaySettingsScreen(key: args.key, initial: args.initial);
    },
  );
}

class RoleplaySettingsRouteArgs {
  const RoleplaySettingsRouteArgs({this.key, required this.initial});

  final Key? key;

  final RoleplaySettings initial;

  @override
  String toString() {
    return 'RoleplaySettingsRouteArgs{key: $key, initial: $initial}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoleplaySettingsRouteArgs) return false;
    return key == other.key && initial == other.initial;
  }

  @override
  int get hashCode => key.hashCode ^ initial.hashCode;
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

/// generated route for
/// [SkillsScreen]
class SkillsRoute extends PageRouteInfo<SkillsRouteArgs> {
  SkillsRoute({
    Key? key,
    List<Skill> skills = const [],
    void Function(Skill)? onAdd,
    void Function(Skill)? onUpdate,
    void Function(String)? onDelete,
    List<PageRouteInfo>? children,
  }) : super(
          SkillsRoute.name,
          args: SkillsRouteArgs(
            key: key,
            skills: skills,
            onAdd: onAdd,
            onUpdate: onUpdate,
            onDelete: onDelete,
          ),
          initialChildren: children,
        );

  static const String name = 'SkillsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SkillsRouteArgs>(
        orElse: () => const SkillsRouteArgs(),
      );
      return SkillsScreen(
        key: args.key,
        skills: args.skills,
        onAdd: args.onAdd,
        onUpdate: args.onUpdate,
        onDelete: args.onDelete,
      );
    },
  );
}

class SkillsRouteArgs {
  const SkillsRouteArgs({
    this.key,
    this.skills = const [],
    this.onAdd,
    this.onUpdate,
    this.onDelete,
  });

  final Key? key;

  final List<Skill> skills;

  final void Function(Skill)? onAdd;

  final void Function(Skill)? onUpdate;

  final void Function(String)? onDelete;

  @override
  String toString() {
    return 'SkillsRouteArgs{key: $key, skills: $skills, onAdd: $onAdd, onUpdate: $onUpdate, onDelete: $onDelete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkillsRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(skills, other.skills);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(skills);
}

/// generated route for
/// [ToolsScreen]
class ToolsRoute extends PageRouteInfo<void> {
  const ToolsRoute({List<PageRouteInfo>? children})
      : super(ToolsRoute.name, initialChildren: children);

  static const String name = 'ToolsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ToolsScreen();
    },
  );
}
