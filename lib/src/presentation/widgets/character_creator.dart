// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports
import 'package:roleplay_assistant/src/presentation/blocs/character_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/blocs/character_creator_state.dart';
import 'package:roleplay_assistant/src/shared/models/character.dart';

/// A minimal inline character creator form used by the characters screen.
/// On successful save this widget will call `Navigator.of(context).pop(created)`
/// returning the created `Character` to the caller.
class CharacterCreator extends StatefulWidget {
  const CharacterCreator({super.key});

  @override
  State<CharacterCreator> createState() => _CharacterCreatorState();
}

class _CharacterCreatorState extends State<CharacterCreator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CharacterCreatorCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CharacterCreatorCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: BlocProvider<CharacterCreatorCubit>.value(
        value: _cubit,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'New Character',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  return TextFormField(
                    initialValue: state.firstName,
                    decoration: const InputDecoration(labelText: 'First name'),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                    onChanged: (String v) => _cubit.updateFirstName(v),
                  );
                },),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  return TextFormField(
                    initialValue: state.middleName,
                    decoration: const InputDecoration(
                        labelText: 'Middle name (optional)',),
                    onChanged: (String v) =>
                        _cubit.updateMiddleName(v.isEmpty ? null : v),
                  );
                },),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  return TextFormField(
                    initialValue: state.lastName,
                    decoration: const InputDecoration(labelText: 'Last name'),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                    onChanged: (String v) => _cubit.updateLastName(v),
                  );
                },),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  final Gender current = state.gender;
                  return DropdownButtonFormField<Gender>(
                    initialValue: current,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: Gender.values
                        .map(
                          (Gender g) => DropdownMenuItem<Gender>(
                            value: g,
                            child: Text(g.toShortString()),
                          ),
                        )
                        .toList(),
                    onChanged: (Gender? g) {
                      if (g == null) return;
                      _cubit.updateGender(g);
                    },
                  );
                },),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  return TextFormField(
                    initialValue: state.age.toString(),
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (String? v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final int? parsed = int.tryParse(v.trim());
                      if (parsed == null || parsed < 0) return 'Invalid age';
                      return null;
                    },
                    onChanged: (String v) => _cubit.updateAge(int.tryParse(v) ?? 0),
                  );
                },),
                const SizedBox(height: 8),
                BlocBuilder<CharacterCreatorCubit, CharacterCreatorState>(
                    builder:
                        (BuildContext context, CharacterCreatorState state) {
                  return TextFormField(
                    initialValue: state.description,
                    decoration: const InputDecoration(
                        labelText: 'Description (optional)',),
                    maxLines: 3,
                    onChanged: (String v) =>
                        _cubit.updateDescription(v.isEmpty ? null : v),
                  );
                },),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final Character? created = await _cubit.submit();
                          if (!mounted) return;
                          if (created != null) {
                            Navigator.of(context).pop(created);
                          }
                        },
                        child: const Text('Save'),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
