// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/locator.dart';
import 'package:roleplay_assistant/src/shared/services/storage/storage.dart';
import 'settings_state.dart';

/// Keys used to persist settings
const String _kIsDarkMode = 'settings.isDarkMode';
const String _kNotificationsEnabled = 'settings.notificationsEnabled';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({Storage? storage})
      : _storage = storage ?? locator<Storage>(),
        super(
          const SettingsState(
            isDarkMode: false,
            notificationsEnabled: true,
          ),
        ) {
    _loadFromStorage();
  }

  final Storage _storage;

  Future<void> _loadFromStorage() async {
    try {
      final bool? isDark = await _storage.read<bool>(key: _kIsDarkMode);
      final bool? notifications =
          await _storage.read<bool>(key: _kNotificationsEnabled);

      emit(
        state.copyWith(
          isDarkMode: isDark ?? state.isDarkMode,
          notificationsEnabled: notifications ?? state.notificationsEnabled,
        ),
      );
    } catch (_) {
      // If storage fails for any reason, keep defaults.
    }
  }

  void toggleDarkMode() {
    final bool newValue = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newValue));
    _persistBool(_kIsDarkMode, newValue);
  }

  void setDarkMode(bool enabled) {
    emit(state.copyWith(isDarkMode: enabled));
    _persistBool(_kIsDarkMode, enabled);
  }

  // language support removed from settings

  void setNotificationsEnabled(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
    _persistBool(_kNotificationsEnabled, enabled);
  }

  void reset() {
    const SettingsState defaults = SettingsState(
      isDarkMode: false,
      notificationsEnabled: true,
    );

    emit(defaults);

    // Persist defaults
    _persistBool(_kIsDarkMode, defaults.isDarkMode);
    _persistBool(_kNotificationsEnabled, defaults.notificationsEnabled);
  }

  Future<void> _persistBool(String key, bool value) async {
    try {
      await _storage.writeBool(key: key, value: value);
    } catch (_) {
      // ignore write errors
    }
  }
}
