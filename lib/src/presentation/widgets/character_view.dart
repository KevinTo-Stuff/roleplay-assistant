// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../shared/models/character.dart';

/// A simple, reusable view that shows full information about a [Character].
///
/// This widget is intentionally self-contained so it can be used as the body
/// of a page, dialog, or inline in layouts.
class CharacterView extends StatelessWidget {
  const CharacterView({super.key, required this.character, this.onEdit});

  final Character character;

  /// Optional callback invoked when the edit button is pressed.
  final VoidCallback? onEdit;

  Widget _buildName(BuildContext context) {
    final String fullName = <String?>[
      character.firstName,
      character.middleName,
      character.lastName,
    ]
        .where((String? s) => s != null && s.trim().isNotEmpty)
        .map((String? s) => s!.trim())
        .join(' ');

    // Show the name with an optional edit button to the right.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            fullName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        // Edit button: enabled only when onEdit is provided.
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: onEdit != null ? 'Edit' : null,
          onPressed: onEdit,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildName(context),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: <Widget>[
              Chip(label: Text('Age: ${character.age}')),
              Chip(label: Text('Gender: ${character.gender.toShortString()}')),
            ],
          ),
          const SizedBox(height: 16.0),
          if (character.description != null &&
              character.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(character.description!),
              ],
            ),
          const SizedBox(height: 16.0),
          Text(
            'Stats',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          _buildStats(),
          const SizedBox(height: 16.0),
          Text(
            'Social Stats',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          _buildSocialStats(),
          const SizedBox(height: 16.0),
          Text(
            'Resistances',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          _buildResistances(),
          const SizedBox(height: 16.0),
          Text(
            'Positive Traits',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          _buildTraitList(character.positiveTraits),
          const SizedBox(height: 12.0),
          Text(
            'Negative Traits',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          _buildTraitList(character.negativeTraits),
        ],
      ),
    );
  }

  Widget _buildSocialStats() {
    if (character.socialStats.isEmpty) return const Text('No social stats');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: character.socialStats.entries
          .map(
            (MapEntry<String, int> e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text('${e.key}: ${e.value}'),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStats() {
    if (character.stats.isEmpty) return const Text('No stats');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: character.stats.entries
          .map(
            (MapEntry<String, int> e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text('${e.key}: ${e.value}'),
            ),
          )
          .toList(),
    );
  }

  Widget _buildResistances() {
    if (character.resistances.isEmpty) return const Text('No resistances');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: character.resistances.entries
          .map(
            (MapEntry<String, String> e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text('${e.key}: ${e.value}'),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTraitList(List<String> traits) {
    if (traits.isEmpty) return const Text('None');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: traits.map((String t) => Text('• $t')).toList(),
    );
  }
}
