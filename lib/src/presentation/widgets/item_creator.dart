// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/item.dart';
import 'package:roleplay_assistant/src/presentation/blocs/item_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/blocs/item_creator_state.dart';

/// Small inline creator/editor for Items. Uses an existing ItemCreatorCubit
/// provided by the caller.
class ItemCreator extends StatefulWidget {
  const ItemCreator({super.key});

  @override
  State<ItemCreator> createState() => _ItemCreatorState();
}

class _ItemCreatorState extends State<ItemCreator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtl;
  late TextEditingController _descCtl;
  ItemType _type = ItemType.other;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController();
    _descCtl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  void _populate(Item? editing) {
    _nameCtl.text = editing?.name ?? '';
    _descCtl.text = editing?.description ?? '';
    _type = editing?.type ?? ItemType.other;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCreatorCubit, ItemCreatorState>(
      builder: (BuildContext context, ItemCreatorState state) {
        _populate(state.editing);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameCtl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (String? v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _descCtl,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  DropdownButtonFormField<ItemType>(
                    initialValue: _type,
                    items: ItemType.values
                        .map<DropdownMenuItem<ItemType>>(
                            (ItemType e) => DropdownMenuItem<ItemType>(
                                  value: e,
                                  child: Text(e.toShortString()),
                                ),)
                        .toList(),
                    onChanged: (ItemType? v) {
                      if (v != null) setState(() => _type = v);
                    },
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () =>
                            context.read<ItemCreatorCubit>().startEditing(null),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final Item? editing =
                              context.read<ItemCreatorCubit>().state.editing;
                          final String id = editing?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString();
                          final Item item = Item(
                            id: id,
                            name: _nameCtl.text.trim(),
                            type: _type,
                            description: _descCtl.text.trim().isEmpty
                                ? null
                                : _descCtl.text.trim(),
                          );
                          await context
                              .read<ItemCreatorCubit>()
                              .addOrUpdateItem(item);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
