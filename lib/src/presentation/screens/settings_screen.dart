// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roleplay_assistant/src/core/settings/settings_cubit.dart';
import 'package:roleplay_assistant/src/core/settings/settings_state.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
      await prefs.clear();
      // Reset the settings cubit to default values
      final SettingsCubit settingsCubit = context.read<SettingsCubit>();
      settingsCubit.reset();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('All data cleared')));
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
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
            initiallyExpanded: true,
            title: const Text('Personalisation'),
            children: <Widget>[
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (BuildContext context, SettingsState state) {
                  return SwitchListTile(
                    value: state.isDarkMode,
                    onChanged: (bool v) async {
                      context.read<SettingsCubit>().setDarkMode(v);
                      await _persistDarkMode(v);
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
                    onChanged: (bool v) async {
                      // 'muted' represents disabling notifications in this UI
                      final bool muted = v;
                      context
                          .read<SettingsCubit>()
                          .setNotificationsEnabled(!muted);
                      await _persistMuted(muted, !muted);
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
            initiallyExpanded: true,
            title: const Text('Data'),
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
            initiallyExpanded: true,
            title: const Text('About'),
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
