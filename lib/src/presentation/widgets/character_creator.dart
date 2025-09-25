// Flutter imports

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/blocs/character_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/blocs/character_creator_state.dart';
import 'package:roleplay_assistant/src/presentation/widgets/traits_creator.dart';
import 'package:roleplay_assistant/src/shared/models/character.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay_settings.dart';

// Project imports

// Project imports

/// A minimal inline character creator form used by the characters screen.
/// On successful save this widget will call `Navigator.of(context).pop(created)`
/// returning the created `Character` to the caller.
class CharacterCreator extends StatefulWidget {
  /// When [initial] is provided the creator will prefill fields for editing
  /// and return an updated Character preserving the original id.
  const CharacterCreator({super.key, this.initial, this.settings});

  final Character? initial;
  final RoleplaySettings? settings;

  @override
  State<CharacterCreator> createState() => _CharacterCreatorState();
}

class _CharacterCreatorState extends State<CharacterCreator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CharacterCreatorCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Construct cubit with original id and initial character if editing
    _cubit = CharacterCreatorCubit(
      originalId: widget.initial?.id,
      initialCharacter: widget.initial,
    );
    // If settings provided, ensure any missing stats/resistances keys are present in cubit state
    if (widget.settings != null) {
      // set defaults for stats and resistances if initialCharacter didn't provide
      final RoleplaySettings s = widget.settings!;
      final Map<String, int> currentStats =
          Map<String, int>.from(_cubit.state.stats);
      for (final String stat in s.stats) {
        currentStats.putIfAbsent(stat, () => 0);
      }
      final Map<String, String> currentRes =
          Map<String, String>.from(_cubit.state.resistances);
      for (final String res in s.resistences) {
        currentRes.putIfAbsent(
          res,
          () => s.resistanceLevels.isNotEmpty ? s.resistanceLevels.first : '',
        );
      }
      _cubit.initializeStatsAndResistances(currentStats, currentRes);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The overall padding accounts for keyboard insets
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: BlocProvider<CharacterCreatorCubit>.value(
        value: _cubit,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // Limit height so the dialog doesn't grow beyond the viewport
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Scrollable form area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: 88 + MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Basic information section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Basic information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                BlocBuilder<CharacterCreatorCubit,
                                    CharacterCreatorState>(
                                  builder: (
                                    BuildContext context,
                                    CharacterCreatorState state,
                                  ) {
                                    return TextFormField(
                                      initialValue: state.firstName,
                                      decoration: const InputDecoration(
                                        labelText: 'First name',
                                      ),
                                      validator: (String? v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
                                      onChanged: (String v) =>
                                          _cubit.updateFirstName(v),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<CharacterCreatorCubit,
                                    CharacterCreatorState>(
                                  builder: (
                                    BuildContext context,
                                    CharacterCreatorState state,
                                  ) {
                                    return TextFormField(
                                      initialValue: state.middleName,
                                      decoration: const InputDecoration(
                                        labelText: 'Middle name (optional)',
                                      ),
                                      onChanged: (String v) =>
                                          _cubit.updateMiddleName(
                                              // ignore: require_trailing_commas
                                              v.isEmpty ? null : v),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<CharacterCreatorCubit,
                                    CharacterCreatorState>(
                                  builder: (
                                    BuildContext context,
                                    CharacterCreatorState state,
                                  ) {
                                    return TextFormField(
                                      initialValue: state.lastName,
                                      decoration: const InputDecoration(
                                        labelText: 'Last name',
                                      ),
                                      validator: (String? v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
                                      onChanged: (String v) =>
                                          _cubit.updateLastName(v),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<CharacterCreatorCubit,
                                    CharacterCreatorState>(
                                  builder: (
                                    BuildContext context,
                                    CharacterCreatorState state,
                                  ) {
                                    final Gender current = state.gender;
                                    return DropdownButtonFormField<Gender>(
                                      initialValue: current,
                                      decoration: const InputDecoration(
                                        labelText: 'Gender',
                                      ),
                                      items: Gender.values
                                          .map(
                                            (Gender g) =>
                                                DropdownMenuItem<Gender>(
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
                                  },
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<CharacterCreatorCubit,
                                    CharacterCreatorState>(
                                  builder: (
                                    BuildContext context,
                                    CharacterCreatorState state,
                                  ) {
                                    return TextFormField(
                                      initialValue: state.age.toString(),
                                      decoration: const InputDecoration(
                                        labelText: 'Age',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (String? v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Required';
                                        }
                                        final int? parsed =
                                            int.tryParse(v.trim());
                                        if (parsed == null || parsed < 0) {
                                          return 'Invalid age';
                                        }
                                        return null;
                                      },
                                      onChanged: (String v) => _cubit
                                          .updateAge(int.tryParse(v) ?? 0),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const Divider(
                              thickness: 2,
                              height: 20,
                            ),
                            const SizedBox(height: 8),

                            // Detailed information section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.details,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Detailed information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<CharacterCreatorCubit,
                                CharacterCreatorState>(
                              builder: (
                                BuildContext context,
                                CharacterCreatorState state,
                              ) {
                                return TextFormField(
                                  initialValue: state.description,
                                  decoration: const InputDecoration(
                                    labelText: 'Description (optional)',
                                  ),
                                  maxLines: 3,
                                  onChanged: (String v) => _cubit
                                      .updateDescription(v.isEmpty ? null : v),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            // Traits creators
                            BlocBuilder<CharacterCreatorCubit,
                                CharacterCreatorState>(
                              builder: (
                                BuildContext context,
                                CharacterCreatorState state,
                              ) {
                                return TraitsCreator(
                                  title: 'Positive traits',
                                  traits: state.positiveTraits,
                                  onAdd: (String t) =>
                                      _cubit.addPositiveTrait(t),
                                  onRemove: (String t) =>
                                      _cubit.removePositiveTrait(t),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<CharacterCreatorCubit,
                                CharacterCreatorState>(
                              builder: (
                                BuildContext context,
                                CharacterCreatorState state,
                              ) {
                                return TraitsCreator(
                                  title: 'Negative traits',
                                  traits: state.negativeTraits,
                                  onAdd: (String t) =>
                                      _cubit.addNegativeTrait(t),
                                  onRemove: (String t) =>
                                      _cubit.removeNegativeTrait(t),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            // Stats and resistances section (from RoleplaySettings)
                            if (widget.settings != null) ...<Widget>[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.bar_chart,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Stats and resistances',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Stats inputs
                              for (final String stat in widget.settings!.stats)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: BlocBuilder<CharacterCreatorCubit,
                                      CharacterCreatorState>(
                                    builder: (
                                      BuildContext context,
                                      CharacterCreatorState state,
                                    ) {
                                      final String current =
                                          state.stats[stat]?.toString() ?? '0';
                                      return TextFormField(
                                        initialValue: current,
                                        decoration:
                                            InputDecoration(labelText: stat),
                                        keyboardType: TextInputType.number,
                                        validator: (String? v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          final int? parsed =
                                              int.tryParse(v.trim());
                                          if (parsed == null) {
                                            return 'Invalid number';
                                          }
                                          return null;
                                        },
                                        onChanged: (String v) {
                                          final int val = int.tryParse(v) ?? 0;
                                          _cubit.updateStat(stat, val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 8),
                              // Resistances dropdowns
                              for (final String res
                                  in widget.settings!.resistences)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: BlocBuilder<CharacterCreatorCubit,
                                      CharacterCreatorState>(
                                    builder: (
                                      BuildContext context,
                                      CharacterCreatorState state,
                                    ) {
                                      final String current =
                                          state.resistances[res] ??
                                              (widget.settings!.resistanceLevels
                                                      .isNotEmpty
                                                  ? widget.settings!
                                                      .resistanceLevels.first
                                                  : '');
                                      return DropdownButtonFormField<String>(
                                        initialValue:
                                            current.isNotEmpty ? current : null,
                                        decoration:
                                            InputDecoration(labelText: res),
                                        items: widget.settings!.resistanceLevels
                                            .map(
                                              (String lvl) =>
                                                  DropdownMenuItem<String>(
                                                value: lvl,
                                                child: Text(lvl),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (String? lvl) {
                                          if (lvl == null) return;
                                          _cubit.updateResistance(res, lvl);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Save FAB (matches style in CharacterScreen)
              Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final NavigatorState navigator = Navigator.of(context);
                    final Character? created = await _cubit.submit();
                    if (!mounted) return;
                    if (created != null) {
                      navigator.pop(created);
                    }
                  },
                  tooltip: 'Save',
                  child: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
