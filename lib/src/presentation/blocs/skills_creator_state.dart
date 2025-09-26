// Flutter imports:
// ignore_for_file: require_trailing_commas

import 'package:equatable/equatable.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';

/// State for the SkillsCreatorCubit.
///
/// - [name] current value for the name input
/// - [description] current value for the description input
/// - [isValid] whether the current inputs are valid for saving
class SkillsCreatorState extends Equatable {
  const SkillsCreatorState({
    this.name = '',
    this.description = '',
    this.isValid = false,
    this.isSaving = false,
  });

  final String name;
  final String description;
  final bool isValid;
  final bool isSaving;

  SkillsCreatorState copyWith({
    String? name,
    String? description,
    bool? isValid,
    bool? isSaving,
  }) {
    return SkillsCreatorState(
      name: name ?? this.name,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => <Object?>[name, description, isValid, isSaving];

  /// Convenience method to create a Skill from this state.
  Skill toSkill(String id) {
    return Skill(
        id: id,
        name: name,
        description: description.isEmpty ? null : description);
  }
}
