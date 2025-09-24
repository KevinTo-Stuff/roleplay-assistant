// Flutter imports
import 'package:flutter/material.dart';

/// Widget to add/remove traits one-by-one.
///
/// Usage:
/// ```dart
/// TraitsCreator(
///   title: 'Positive Traits',
///   traits: state.positiveTraits,
///   onAdd: (t) => cubit.addPositiveTrait(t),
///   onRemove: (t) => cubit.removePositiveTrait(t),
/// )
/// ```
class TraitsCreator extends StatefulWidget {
  const TraitsCreator({
    super.key,
    required this.title,
    required this.traits,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final List<String> traits;
  final void Function(String trait) onAdd;
  final void Function(String trait) onRemove;

  @override
  State<TraitsCreator> createState() => _TraitsCreatorState();
}

class _TraitsCreatorState extends State<TraitsCreator> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final String raw = _controller.text.trim();
    if (raw.isEmpty) return;
    // Enforce single-word traits (no whitespace inside)
    if (raw.contains(RegExp(r"\s"))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Traits must be a single word (no spaces)'),),
      );
      return;
    }

    // Case-insensitive duplicate check
    final String rawLower = raw.toLowerCase();
    final bool exists =
        widget.traits.map((String t) => t.toLowerCase()).contains(rawLower);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trait "$raw" already added')),
      );
      return;
    }
    widget.onAdd(raw);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Add trait',
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _add,
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.traits
              .map((String t) => InputChip(
                    label: Text(t),
                    onDeleted: () => widget.onRemove(t),
                  ),)
              .toList(),
        ),
      ],
    );
  }
}
