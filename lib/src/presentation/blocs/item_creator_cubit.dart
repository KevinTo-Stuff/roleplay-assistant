// Flutter imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/item.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/services/roleplay/roleplay_storage.dart';
import 'package:roleplay_assistant/src/shared/locator.dart';
import 'item_creator_state.dart';

/// Cubit for creating/editing items and persisting them to the Roleplay.
class ItemCreatorCubit extends Cubit<ItemCreatorState> {
  ItemCreatorCubit({required Roleplay initialRoleplay})
      : super(ItemCreatorState(roleplay: initialRoleplay));

  RoleplayStorage get _storage => locator<RoleplayStorage>();

  void startEditing(Item? item) {
    emit(state.copyWith(editing: item));
  }

  Future<void> addOrUpdateItem(Item item) async {
    final List<Item> items = List<Item>.from(state.roleplay.items);
    final int idx = items.indexWhere((Item i) => i.id == item.id);
    if (idx >= 0) {
      items[idx] = item;
    } else {
      items.add(item);
    }
    final Roleplay updated = state.roleplay.copyWith(items: items);
    emit(state.copyWith(roleplay: updated, editing: null));
    if (updated.id != null) {
      await _storage.update(updated);
    }
  }

  Future<void> deleteItem(String id) async {
    final List<Item> items = List<Item>.from(state.roleplay.items)
      ..removeWhere((Item i) => i.id == id);
    final Roleplay updated = state.roleplay.copyWith(items: items);
    emit(state.copyWith(roleplay: updated, editing: null));
    if (updated.id != null) {
      await _storage.update(updated);
    }
  }
}
