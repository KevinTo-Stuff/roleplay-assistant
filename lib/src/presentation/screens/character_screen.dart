// Flutter imports:
// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import '../../shared/models/character.dart';
import '../widgets/character_creator.dart';
import '../widgets/character_view.dart';

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
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _characters = List<Character>.from(widget.characters);
  }

  Future<void> _openCreator() async {
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    final Character? created = await navigator.push<Character?>(
      MaterialPageRoute<Character?>(
        fullscreenDialog: true,
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(title: const Text('New Character')),
          body: const SafeArea(child: CharacterCreator()),
        ),
      ),
    );

    if (!mounted) return;
    if (created != null) {
      setState(() => _characters.add(created));
      widget.onChanged?.call(List<Character>.from(_characters));
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('Character added')));
    }
  }

  Future<void> _openEditor(int index) async {
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    final Character original = _characters[index];
    final Character? updated = await navigator.push<Character?>(
      MaterialPageRoute<Character?>(
        fullscreenDialog: true,
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(title: const Text('Edit Character')),
          body: SafeArea(child: CharacterCreator(initial: original)),
        ),
      ),
    );

    if (!mounted) return;
    if (updated != null) {
      setState(() => _characters[index] = updated);
      widget.onChanged?.call(List<Character>.from(_characters));
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('Character updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If a character is selected, show the CharacterView full-screen in-place.
    if (_selectedIndex != null) {
      final Character selected = _characters[_selectedIndex!];
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          setState(() => _selectedIndex = null);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Character'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _selectedIndex = null),
              tooltip: 'Close',
            ),
          ),
          body: SafeArea(
            child: CharacterView(
              character: selected,
              onEdit: () => _openEditor(_selectedIndex!),
            ),
          ),
        ),
      );
    }

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
                  c.id.isNotEmpty ? c.id : 'character_$index',
                );

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
                    onTap: () => setState(() => _selectedIndex = index),
                    title: Text(fullName),
                    subtitle: Text(
                      'Age: ${c.age} • Gender: ${c.gender.toShortString()}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openEditor(index),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final NavigatorState navigator =
                                Navigator.of(context);
                            final ScaffoldMessengerState scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Delete Character'),
                                  content: Text(
                                      'Are you sure you want to delete "$fullName"?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => navigator.pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => navigator.pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (!mounted) return;
                            if (confirm == true) {
                              final Character removed = _characters[index];
                              setState(() => _characters.removeAt(index));
                              widget.onChanged
                                  ?.call(List<Character>.from(_characters));

                              scaffoldMessenger.hideCurrentSnackBar();
                              scaffoldMessenger.showSnackBar(
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
                      ],
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
