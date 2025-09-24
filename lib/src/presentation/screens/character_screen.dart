// Flutter imports:
// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import '../../shared/models/character.dart';
import '../widgets/character_creator.dart';

@RoutePage()
class CharacterScreen extends StatefulWidget {
  /// Provide a list of characters to display. If null or empty, shows a
  /// placeholder message.
  const CharacterScreen({
    super.key,
    this.characters = const <Character>[],
    this.onChanged,
  });

  final List<Character> characters;
  final ValueChanged<List<Character>>? onChanged;

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late List<Character> _characters;

  @override
  void initState() {
    super.initState();
    _characters = List<Character>.from(widget.characters);
  }

  Future<void> _openCreator() async {
    final Character? created = await Navigator.of(context).push<Character?>(
      MaterialPageRoute<Character?>(
        fullscreenDialog: true,
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(title: const Text('Create Character')),
          body: const SafeArea(child: CharacterCreator()),
        ),
      ),
    );

    if (created != null) {
      setState(() => _characters.add(created));
      widget.onChanged?.call(List<Character>.from(_characters));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Character added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: _characters.isEmpty
          ? const Center(child: Text('No characters'))
          : ListView.builder(
              itemCount: _characters.length,
              itemBuilder: (BuildContext context, int index) {
                final Character c = _characters[index];
                final String fullName = <String?>[
                  c.firstName,
                  c.middleName,
                  c.lastName,
                ]
                    .where((String? s) => s != null && s.trim().isNotEmpty)
                    .map((String? s) => s!.trim())
                    .join(' ');

                // Use a stable key when possible (id), otherwise fall back to index
                final Key dismissKey = ValueKey<String>(
                    c.id.isNotEmpty ? c.id : 'character_$index',);

                return Dismissible(
                  key: dismissKey,
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  onDismissed: (DismissDirection direction) {
                    // Capture removed item for undo
                    final Character removed = _characters[index];
                    setState(() => _characters.removeAt(index));
                    widget.onChanged?.call(List<Character>.from(_characters));

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$fullName deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              // Put the item back at the same index if possible
                              final int insertAt = index <= _characters.length
                                  ? index
                                  : _characters.length;
                              _characters.insert(insertAt, removed);
                              widget.onChanged
                                  ?.call(List<Character>.from(_characters));
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(fullName),
                    subtitle: Text(
                      'Age: ${c.age} • Gender: ${c.gender.toShortString()}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Delete Character'),
                              content: Text(
                                  'Are you sure you want to delete "$fullName"?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          final Character removed = _characters[index];
                          setState(() => _characters.removeAt(index));
                          widget.onChanged
                              ?.call(List<Character>.from(_characters));

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$fullName deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    final int insertAt =
                                        index <= _characters.length
                                            ? index
                                            : _characters.length;
                                    _characters.insert(insertAt, removed);
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreator,
        tooltip: 'Add character',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
