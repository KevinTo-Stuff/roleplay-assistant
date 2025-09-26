// Flutter imports:
// ignore_for_file: require_trailing_commas

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/blocs/skills_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/blocs/skills_creator_state.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';

/// A full-screen skill creator. Use `SkillsCreatorScreen.fullscreen()` to
/// present it as a dialog-like route. When saved this screen will `Navigator.pop`
/// with the created [Skill].
class SkillsCreatorScreen extends StatelessWidget {
  const SkillsCreatorScreen.fullscreen({super.key, this.initial});

  /// Optional Skill to edit. If provided, the creator will be prefilled and
  /// saving will preserve the existing id.
  final Skill? initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SkillsCreatorCubit>(
      create: (_) => SkillsCreatorCubit(initial: initial),
      child: _SkillsCreatorView(initial: initial),
    );
  }
}

class _SkillsCreatorView extends StatelessWidget {
  const _SkillsCreatorView({this.initial});

  final Skill? initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Skill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_name'),
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.name)),
                  onChanged: (String v) =>
                      context.read<SkillsCreatorCubit>().nameChanged(v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_description'),
                  decoration: const InputDecoration(labelText: 'Description'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.description)),
                  onChanged: (String v) =>
                      context.read<SkillsCreatorCubit>().descriptionChanged(v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_cost_type'),
                  decoration: const InputDecoration(labelText: 'Cost type'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.costType ?? '')),
                  onChanged: (String v) => context
                      .read<SkillsCreatorCubit>()
                      .costTypeChanged(v.isEmpty ? null : v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_cost'),
                  decoration:
                      const InputDecoration(labelText: 'Cost (integer)'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.cost?.toString() ?? '')),
                  onChanged: (String v) => context
                      .read<SkillsCreatorCubit>()
                      .costChanged(v.isEmpty ? null : v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_type'),
                  decoration: const InputDecoration(labelText: 'Type'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.type ?? '')),
                  onChanged: (String v) => context
                      .read<SkillsCreatorCubit>()
                      .typeChanged(v.isEmpty ? null : v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_damage_type'),
                  decoration: const InputDecoration(labelText: 'Damage type'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.damageType ?? '')),
                  onChanged: (String v) => context
                      .read<SkillsCreatorCubit>()
                      .damageTypeChanged(v.isEmpty ? null : v),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return TextField(
                  key: const Key('skill_flavor'),
                  decoration: const InputDecoration(labelText: 'Flavor'),
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: state.flavor ?? '')),
                  onChanged: (String v) => context
                      .read<SkillsCreatorCubit>()
                      .flavorChanged(v.isEmpty ? null : v),
                );
              },
            ),
            const Spacer(),
            BlocBuilder<SkillsCreatorCubit, SkillsCreatorState>(
              builder: (BuildContext ctx, SkillsCreatorState state) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.isSaving
                            ? null
                            : () {
                                // Use the builder context (ctx) here which is
                                // local to the BlocBuilder and synchronous.
                                Navigator.of(ctx).pop();
                              },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: !state.isValid || state.isSaving
                            ? null
                            : () async {
                                // Capture cubit, current state and navigator
                                // from the builder's ctx synchronously so we do
                                // not use BuildContext after an await.
                                final SkillsCreatorCubit cubit =
                                    ctx.read<SkillsCreatorCubit>();
                                final SkillsCreatorState currentState = state;
                                final NavigatorState nav = Navigator.of(ctx);

                                final String id =
                                    await cubit.save(existingId: initial?.id);
                                final Skill skill = currentState.toSkill(id);
                                nav.pop(skill);
                              },
                        child: state.isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator.adaptive())
                            : const Text('Save'),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
