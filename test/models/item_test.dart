// Dart imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/item.dart';

void main() {
  test('Item JSON roundtrip and parsing', () {
    final Map<String, dynamic> json = <String, dynamic>{
      'id': 'item-1',
      'name': 'Potion',
      'type': 'consumable',
      'description': 'Restores HP',
      'flavor_text': 'Tastes like cherries',
      'cost': 50,
      'sell': 25,
      'rarity': 'common',
      'soulbound': false,
      'sold_at': <String>['village_shop']
      // ignore: require_trailing_commas
    };

    final Item item = Item.fromJson(json);

    expect(item.id, 'item-1');
    expect(item.name, 'Potion');
    expect(item.type, ItemType.consumable);
    expect(item.description, 'Restores HP');
    expect(item.flavorText, 'Tastes like cherries');
    expect(item.cost, 50);
    expect(item.sell, 25);
    expect(item.rarity, Rarity.common);
    expect(item.soulbound, false);
    expect(item.soldAt, <String>['village_shop']);

    final Map<String, dynamic> out = item.toJson();
    expect(out['id'], 'item-1');
    expect(out['type'], 'consumable');
    expect(out['sold_at'], <String>['village_shop']);
  });
}
