// Flutter imports:
// ignore_for_file: always_specify_types, require_trailing_commas

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import '../../shared/models/roleplay_settings.dart';
import '../blocs/roleplay_settings_cubit.dart';

/// A simple screen to edit RoleplaySettings.
///
/// Usage:
/// Navigator.push(context, MaterialPageRoute(builder: (_) => RoleplaySettingsScreen(initial: settings)));
@RoutePage()
class RoleplaySettingsScreen extends StatelessWidget {
  const RoleplaySettingsScreen({super.key, required this.initial});

  final RoleplaySettings initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoleplaySettingsCubit(initial),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Roleplay Settings'),
        ),
        body: const _RoleplaySettingsBody(),
        floatingActionButton: Builder(builder: (ctx) {
          return FloatingActionButton(
            onPressed: () {
              final cubit = ctx.read<RoleplaySettingsCubit>();
              Navigator.of(ctx).pop(cubit.currentSettings);
            },
            tooltip: 'Save',
            child: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class _RoleplaySettingsBody extends StatefulWidget {
  const _RoleplaySettingsBody();

  @override
  State<_RoleplaySettingsBody> createState() => _RoleplaySettingsBodyState();
}

class _RoleplaySettingsBodyState extends State<_RoleplaySettingsBody> {
  final TextEditingController _resController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _statController = TextEditingController();

  @override
  void dispose() {
    _resController.dispose();
    _levelController.dispose();
    _statController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleplaySettingsCubit, RoleplaySettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resistances',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var i = 0; i < state.settings.resistences.length; i++)
                ListTile(
                  title: Text(state.settings.resistences[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => context
                        .read<RoleplaySettingsCubit>()
                        .removeResistanceAt(i),
                  ),
                ),
              Row(children: [
                Expanded(
                  child: TextField(
                      controller: _resController,
                      decoration:
                          const InputDecoration(hintText: 'New resistance')),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final val = _resController.text.trim();
                    if (val.isNotEmpty) {
                      context.read<RoleplaySettingsCubit>().addResistance(val);
                      _resController.clear();
                    }
                  },
                )
              ]),
              const SizedBox(height: 16),
              const Text('Resistance Levels',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var i = 0; i < state.settings.resistanceLevels.length; i++)
                ListTile(
                  title: Text(state.settings.resistanceLevels[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => context
                        .read<RoleplaySettingsCubit>()
                        .removeResistanceLevelAt(i),
                  ),
                ),
              Row(children: [
                Expanded(
                  child: TextField(
                      controller: _levelController,
                      decoration: const InputDecoration(hintText: 'New level')),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final val = _levelController.text.trim();
                    if (val.isNotEmpty) {
                      context
                          .read<RoleplaySettingsCubit>()
                          .addResistanceLevel(val);
                      _levelController.clear();
                    }
                  },
                )
              ]),
              const SizedBox(height: 16),
              const Text('Stats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var i = 0; i < state.settings.stats.length; i++)
                ListTile(
                  title: Text(state.settings.stats[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        context.read<RoleplaySettingsCubit>().removeStatAt(i),
                  ),
                ),
              Row(children: [
                Expanded(
                  child: TextField(
                      controller: _statController,
                      decoration: const InputDecoration(hintText: 'New stat')),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final val = _statController.text.trim();
                    if (val.isNotEmpty) {
                      context.read<RoleplaySettingsCubit>().addStat(val);
                      _statController.clear();
                    }
                  },
                )
              ]),
              const SizedBox(
                height: Dimens.tripleSpacing * 3,
              ),
            ],
          ),
        );
      },
    );
  }
}
