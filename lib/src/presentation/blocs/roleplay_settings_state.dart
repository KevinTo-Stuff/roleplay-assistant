part of 'roleplay_settings_cubit.dart';

class RoleplaySettingsState {
  RoleplaySettingsState({required this.settings, this.isDirty = false});

  final RoleplaySettings settings;
  final bool isDirty;

  RoleplaySettingsState copyWith({RoleplaySettings? settings, bool? isDirty}) {
    return RoleplaySettingsState(
      settings: settings ?? this.settings,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}
