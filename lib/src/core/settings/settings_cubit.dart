// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          const SettingsState(
            isDarkMode: false,
            notificationsEnabled: true,
          ),
        );

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void setDarkMode(bool enabled) {
    emit(state.copyWith(isDarkMode: enabled));
  }

  // language support removed from settings

  void setNotificationsEnabled(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void reset() {
    emit(
      const SettingsState(
        isDarkMode: false,
        notificationsEnabled: true,
      ),
    );
  }
}
