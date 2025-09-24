// Flutter imports
import 'package:flutter/material.dart';

// Project imports
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
  final TextEditingController _first = TextEditingController();
  final TextEditingController _middle = TextEditingController();
  final TextEditingController _last = TextEditingController();
  final TextEditingController _age = TextEditingController();
  Gender _gender = Gender.other;
  final TextEditingController _desc = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _middle.dispose();
    _last.dispose();
    _age.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final String id = '${DateTime.now().toIso8601String()}-${UniqueKey()}';
    final Character created = Character(
      id: id,
      firstName: _first.text.trim(),
      middleName: _middle.text.trim().isEmpty ? null : _middle.text.trim(),
      lastName: _last.text.trim(),
      gender: _gender,
      age: int.tryParse(_age.text.trim()) ?? 0,
      description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
    );
    Navigator.of(context).pop(created);
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('New Character',
                  style: Theme.of(context).textTheme.titleLarge,),
              const SizedBox(height: 8),
              TextFormField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'First name'),
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _middle,
                decoration:
                    const InputDecoration(labelText: 'Middle name (optional)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Last name'),
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Gender>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: Gender.values
                    .map((Gender g) => DropdownMenuItem<Gender>(
                        value: g, child: Text(g.toShortString()),),)
                    .toList(),
                onChanged: (Gender? g) {
                  if (g == null) return;
                  setState(() => _gender = g);
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (String? v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final int? parsed = int.tryParse(v.trim());
                  if (parsed == null || parsed < 0) return 'Invalid age';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _desc,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _onSave, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
