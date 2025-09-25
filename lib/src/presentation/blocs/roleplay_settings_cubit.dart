// Flutter / Dart

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../shared/models/roleplay_settings.dart';

// Project

part 'roleplay_settings_state.dart';

/// Cubit that manages `RoleplaySettings` edits.
class RoleplaySettingsCubit extends Cubit<RoleplaySettingsState> {
  RoleplaySettingsCubit(RoleplaySettings initial)
      : super(RoleplaySettingsState(settings: initial));

  void addResistance(String value) {
    final RoleplaySettings next = state.settings.copyWith(
      resistences: List<String>.from(state.settings.resistences)..add(value),
    );
    emit(state.copyWith(settings: next, isDirty: true));
  }

  void removeResistanceAt(int index) {
    final List<String> list = List<String>.from(state.settings.resistences)
      ..removeAt(index);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(resistences: list),
        isDirty: true,
      ),
    );
  }

  void addResistanceLevel(String value) {
    final RoleplaySettings next = state.settings.copyWith(
      resistanceLevels: List<String>.from(state.settings.resistanceLevels)
        ..add(value),
    );
    emit(state.copyWith(settings: next, isDirty: true));
  }

  void removeResistanceLevelAt(int index) {
    final List<String> list = List<String>.from(state.settings.resistanceLevels)
      ..removeAt(index);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(resistanceLevels: list),
        isDirty: true,
      ),
    );
  }

  void addStat(String value) {
    final RoleplaySettings next = state.settings.copyWith(
      stats: List<String>.from(state.settings.stats)..add(value),
    );
    emit(state.copyWith(settings: next, isDirty: true));
  }

  void removeStatAt(int index) {
    final List<String> list = List<String>.from(state.settings.stats)
      ..removeAt(index);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(stats: list),
        isDirty: true,
      ),
    );
  }

  void reset(RoleplaySettings to) {
    emit(RoleplaySettingsState(settings: to));
  }

  RoleplaySettings get currentSettings => state.settings;
}
