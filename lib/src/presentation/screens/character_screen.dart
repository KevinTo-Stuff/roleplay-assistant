// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import '../../shared/models/character.dart';

@RoutePage()
class CharacterScreen extends StatelessWidget {
  /// Provide a list of characters to display. If null or empty, shows a
  /// placeholder message.
  const CharacterScreen({
    super.key,
    this.characters = const <Character>[],
  });

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: characters.isEmpty
          ? const Center(child: Text('No characters'))
          : ListView.builder(
              itemCount: characters.length,
              itemBuilder: (BuildContext context, int index) {
                final Character c = characters[index];
                final String fullName = <String?>[
                  c.firstName,
                  c.middleName,
                  c.lastName,
                ]
                    .where((String? s) => s != null && s.trim().isNotEmpty)
                    .map((String? s) => s!.trim())
                    .join(' ');
                return ListTile(
                  title: Text(fullName),
                  subtitle: Text(
                    'Age: ${c.age} • Gender: ${c.gender.toShortString()}',
                  ),
                );
              },
            ),
    );
  }
}
