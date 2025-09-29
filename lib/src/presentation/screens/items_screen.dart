// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/models/item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roleplay_assistant/src/presentation/blocs/item_creator_cubit.dart';
import 'package:roleplay_assistant/src/presentation/widgets/item_creator.dart';

/// Displays and edits items for a provided Roleplay instance.

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
    this.roleplay,
  });

  final Roleplay? roleplay;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late Roleplay _roleplay;
  late ItemCreatorCubit _cubit;

  @override
  void initState() {
    super.initState();
    _roleplay = widget.roleplay ?? Roleplay.example();
    _cubit = ItemCreatorCubit(initialRoleplay: _roleplay);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _openCreator({Item? editing}) async {
    _cubit.startEditing(editing);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // ignore: always_specify_types
        child: BlocProvider.value(
          value: _cubit,
          child: const ItemCreator(),
        ),
      ),
    );
    // after sheet closed, update local roleplay from cubit state
    setState(() {
      _roleplay = _cubit.state.roleplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, bool? result) {
        if (!didPop) {
          Navigator.of(context).pop(_roleplay);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Items')),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.spacing),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: _roleplay.items.length,
                  separatorBuilder: (BuildContext _, int __) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    final Item it = _roleplay.items[index];
                    return ListTile(
                      title: Text(it.name),
                      subtitle: Text(it.description ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openCreator(editing: it),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _cubit.deleteItem(it.id);
                              setState(() {
                                _roleplay = _cubit.state.roleplay;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openCreator(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
