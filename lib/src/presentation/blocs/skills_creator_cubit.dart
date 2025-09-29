// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/skill.dart';
import 'skills_creator_state.dart';

// avoid adding new dependency for uuid; use timestamp-based id

class SkillsCreatorCubit extends Cubit<SkillsCreatorState> {
  /// Provide an optional [initial] Skill to prefill the creator for editing.
  SkillsCreatorCubit({Skill? initial})
      : super(
          initial != null
              ? SkillsCreatorState(
                  name: initial.name,
                  description: initial.description ?? '',
                  costType: initial.costType,
                  cost: initial.cost,
                  type: initial.type,
                  damageType: initial.damageType,
                  flavor: initial.flavor,
                  isValid: initial.name.trim().isNotEmpty,
                )
              : const SkillsCreatorState(),
        );

  void nameChanged(String value) {
    emit(state.copyWith(name: value, isValid: _validate(value)));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void costTypeChanged(String? value) {
    emit(state.copyWith(costType: value));
  }

  void costChanged(String? value) {
    final int? parsed =
        (value == null || value.trim().isEmpty) ? null : int.tryParse(value);
    emit(state.copyWith(cost: parsed));
  }

  void typeChanged(String? value) {
    emit(state.copyWith(type: value));
  }

  void damageTypeChanged(String? value) {
    emit(state.copyWith(damageType: value));
  }

  void flavorChanged(String? value) {
    emit(state.copyWith(flavor: value));
  }

  bool _validate(String name) => name.trim().isNotEmpty;

  /// Emulate saving and return the created Skill via the state -> caller should
  /// call state.toSkill with the generated id when they receive success.
  /// Save and return an id for the created/updated skill. If [existingId]
  /// is provided it will be returned (preserving the skill id for edits),
  /// otherwise a new timestamp-based id is generated.
  Future<String> save({String? existingId}) async {
    if (!state.isValid) throw StateError('Invalid state');
    emit(state.copyWith(isSaving: true));
    // Simulate some async work.
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final String id =
        existingId ?? DateTime.now().toUtc().microsecondsSinceEpoch.toString();
    emit(state.copyWith(isSaving: false));
    return id;
  }
}
