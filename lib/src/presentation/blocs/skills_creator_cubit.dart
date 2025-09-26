// Flutter imports:
import 'package:bloc/bloc.dart';
// avoid adding new dependency for uuid; use timestamp-based id

// Project imports:
import 'skills_creator_state.dart';

class SkillsCreatorCubit extends Cubit<SkillsCreatorState> {
  SkillsCreatorCubit() : super(const SkillsCreatorState());

  void nameChanged(String value) {
    emit(state.copyWith(name: value, isValid: _validate(value)));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  bool _validate(String name) => name.trim().isNotEmpty;

  /// Emulate saving and return the created Skill via the state -> caller should
  /// call state.toSkill with the generated id when they receive success.
  Future<String> save() async {
    if (!state.isValid) throw StateError('Invalid state');
    emit(state.copyWith(isSaving: true));
    // Simulate some async work; keep it fast.
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final String id = DateTime.now().toUtc().microsecondsSinceEpoch.toString();
    emit(state.copyWith(isSaving: false));
    return id;
  }
}
