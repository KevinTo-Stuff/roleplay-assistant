// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/blocs/skills_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/blocs/skills_creator_state.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';

/// A full-screen skill creator. Use `SkillsCreatorScreen.fullscreen()` to
/// present it as a dialog-like route. When saved this screen will `Navigator.pop`
/// with the created [Skill].
class SkillsCreatorScreen extends StatelessWidget {
  const SkillsCreatorScreen._({super.key});

  const SkillsCreatorScreen.fullscreen({Key? key}) : this._(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SkillsCreatorCubit>(
      create: (_) => SkillsCreatorCubit(),
      child: const _SkillsCreatorView(),
    );
  }
}

class _SkillsCreatorView extends StatelessWidget {
  const _SkillsCreatorView({Key? key}) : super(key: key);

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
                  onChanged: (v) =>
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
                  onChanged: (v) =>
                      context.read<SkillsCreatorCubit>().descriptionChanged(v),
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
                                Navigator.of(context).pop();
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
                                final String id = await context
                                    .read<SkillsCreatorCubit>()
                                    .save();
                                final Skill skill = state.toSkill(id);
                                Navigator.of(context).pop(skill);
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
