// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/item.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';

/// State for the ItemCreatorCubit.
@immutable
class ItemCreatorState {
  const ItemCreatorState({required this.roleplay, this.editing});

  final Roleplay roleplay;
  final Item? editing;

  ItemCreatorState copyWith({Roleplay? roleplay, Item? editing}) {
    return ItemCreatorState(
      roleplay: roleplay ?? this.roleplay,
      editing: editing ?? this.editing,
    );
  }
}
