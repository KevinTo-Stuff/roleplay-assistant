// Package imports:
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isDarkMode,
    required this.language,
    required this.notificationsEnabled,
  });

  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[isDarkMode, language, notificationsEnabled];
}
