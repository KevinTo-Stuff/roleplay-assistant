// Package imports:
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
  });

  final bool isDarkMode;
  final bool notificationsEnabled;

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => <Object?>[isDarkMode, notificationsEnabled];
}
