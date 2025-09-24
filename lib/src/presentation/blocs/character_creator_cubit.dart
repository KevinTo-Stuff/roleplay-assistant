// Imports
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports
import 'package:roleplay_assistant/src/shared/models/character.dart';
import 'package:roleplay_assistant/src/presentation/blocs/character_creator_state.dart';

/// Cubit to manage the `CharacterCreator` form state.
class CharacterCreatorCubit extends Cubit<CharacterCreatorState> {
  /// If [originalId] is provided the cubit will reuse that id when building
  /// the `Character` on save. This allows the creator to act as an editor.
  final String? originalId;

  CharacterCreatorCubit({this.originalId, Character? initialCharacter})
      : super(
          initialCharacter != null
              ? CharacterCreatorState.initial().copyWith(
                  firstName: initialCharacter.firstName,
                  middleName: initialCharacter.middleName,
                  lastName: initialCharacter.lastName,
                  gender: initialCharacter.gender,
                  age: initialCharacter.age,
                  description: initialCharacter.description,
                  positiveTraits:
                      List<String>.from(initialCharacter.positiveTraits),
                  negativeTraits:
                      List<String>.from(initialCharacter.negativeTraits),
                )
              : CharacterCreatorState.initial(),
        );

  void updateFirstName(String value) => emit(
        state.copyWith(firstName: value, isSuccess: false, errorMessage: null),
      );

  void updateMiddleName(String? value) => emit(
        state.copyWith(middleName: value, isSuccess: false, errorMessage: null),
      );

  void updateLastName(String value) => emit(
        state.copyWith(lastName: value, isSuccess: false, errorMessage: null),
      );

  void updateGender(Gender value) =>
      emit(state.copyWith(gender: value, isSuccess: false, errorMessage: null));

  void updateAge(int value) =>
      emit(state.copyWith(age: value, isSuccess: false, errorMessage: null));

  void updateDescription(String? value) => emit(
        state.copyWith(
          description: value,
          isSuccess: false,
          errorMessage: null,
        ),
      );

  // Traits management
  void addPositiveTrait(String trait) {
    final List<String> updated = List<String>.from(state.positiveTraits)
      ..add(trait);
    emit(
      state.copyWith(
        positiveTraits: updated,
        isSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void removePositiveTrait(String trait) {
    final List<String> updated = List<String>.from(state.positiveTraits)
      ..remove(trait);
    emit(
      state.copyWith(
        positiveTraits: updated,
        isSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void addNegativeTrait(String trait) {
    final List<String> updated = List<String>.from(state.negativeTraits)
      ..add(trait);
    emit(
      state.copyWith(
        negativeTraits: updated,
        isSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void removeNegativeTrait(String trait) {
    final List<String> updated = List<String>.from(state.negativeTraits)
      ..remove(trait);
    emit(
      state.copyWith(
        negativeTraits: updated,
        isSuccess: false,
        errorMessage: null,
      ),
    );
  }

  /// Build a Character object from the current state. Does not emit state.
  Character buildCharacter() {
    final String id = originalId ??
        '${DateTime.now().toIso8601String()}-${Random().nextInt(1 << 32)}';
    return Character(
      id: id,
      firstName: state.firstName.trim(),
      middleName: state.middleName?.trim(),
      lastName: state.lastName.trim(),
      gender: state.gender,
      age: state.age,
      description: state.description?.trim(),
      positiveTraits: List<String>.from(state.positiveTraits),
      negativeTraits: List<String>.from(state.negativeTraits),
    );
  }

  /// Validate and submit. Returns created Character on success.
  Future<Character?> submit() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          errorMessage:
              'Please fill required fields (first/last name, non-negative age).',
        ),
      );
      return null;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Simulate potential async work (persistence) if needed later.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final Character created = buildCharacter();
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
      return created;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
          isSuccess: false,
        ),
      );
      return null;
    }
  }
}
