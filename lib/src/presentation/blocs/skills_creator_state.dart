// Flutter imports:
// ignore_for_file: require_trailing_commas

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
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
    this.costType,
    this.cost,
    this.type,
    this.damageType,
    this.flavor,
    this.isValid = false,
    this.isSaving = false,
  });

  final String name;
  final String description;
  final String? costType;
  final int? cost;
  final String? type;
  final String? damageType;
  final String? flavor;
  final bool isValid;
  final bool isSaving;

  SkillsCreatorState copyWith({
    String? name,
    String? description,
    String? costType,
    int? cost,
    String? type,
    String? damageType,
    String? flavor,
    bool? isValid,
    bool? isSaving,
  }) {
    return SkillsCreatorState(
      name: name ?? this.name,
      description: description ?? this.description,
      costType: costType ?? this.costType,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      damageType: damageType ?? this.damageType,
      flavor: flavor ?? this.flavor,
      isValid: isValid ?? this.isValid,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        description,
        costType,
        cost,
        type,
        damageType,
        flavor,
        isValid,
        isSaving
      ];

  /// Convenience method to create a Skill from this state.
  Skill toSkill(String id) {
    return Skill(
      id: id,
      name: name,
      costType: costType,
      cost: cost,
      type: type,
      damageType: damageType,
      description: description.isEmpty ? null : description,
      flavor: flavor,
    );
  }
}
