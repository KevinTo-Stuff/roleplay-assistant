// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/settings/settings_cubit.dart';
import 'package:roleplay_assistant/src/core/settings/settings_state.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _githubUrl =
      'https://github.com/KevinTo-Stuff/roleplay-assistant';
  static const String _issuesUrl =
      'https://github.com/KevinTo-Stuff/roleplay-assistant/issues';

  Future<void> _persistDarkMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> _persistMuted(bool value, bool notificationsEnabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('muted', value);
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
  }

  Future<void> _clearAllData() async {
    // Capture context-dependent objects BEFORE any async gaps to avoid the
    // 'BuildContext across async gaps' warning.
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    // Show confirmation first (uses BuildContext) and only then perform async work.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This will remove all stored preferences and cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset the settings cubit to default values
      settingsCubit.reset();

      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('All data cleared')));
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    // Capture messenger before awaiting to avoid using BuildContext across
    // async gaps.
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      messenger
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            leading: const Icon(Icons.palette),
            title: const Text('Personalisation'),
            initiallyExpanded: true,
            children: <Widget>[
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (BuildContext context, SettingsState state) {
                  return SwitchListTile(
                    value: state.isDarkMode,
                    onChanged: (bool v) {
                      // Update cubit immediately. Persist without awaiting to
                      // avoid using BuildContext across async gaps.
                      context.read<SettingsCubit>().setDarkMode(v);
                      // Ignore unawaited future lint: we intentionally don't await
                      // the persistence call so the UI updates immediately.
                      // ignore: unawaited_futures
                      _persistDarkMode(v);
                    },
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text('Dark mode'),
                  );
                },
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (BuildContext context, SettingsState state) {
                  return SwitchListTile(
                    value: !state.notificationsEnabled,
                    onChanged: (bool v) {
                      // 'muted' represents disabling notifications in this UI
                      final bool muted = v;
                      context
                          .read<SettingsCubit>()
                          .setNotificationsEnabled(!muted);
                      // ignore: unawaited_futures
                      _persistMuted(muted, !muted);
                    },
                    secondary: const Icon(Icons.volume_off),
                    title: const Text('Mute application'),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.storage),
            title: const Text('Data'),
            initiallyExpanded: true,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Clear all data'),
                subtitle: const Text('Remove cached files and preferences'),
                onTap: _clearAllData,
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            initiallyExpanded: true,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('View on GitHub'),
                onTap: () => _launchUrl(_githubUrl),
              ),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Report an issue'),
                onTap: () => _launchUrl(_issuesUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
