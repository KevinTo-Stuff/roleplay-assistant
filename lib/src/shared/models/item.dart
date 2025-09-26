// Package imports:
import 'package:equatable/equatable.dart';

/// Types of items supported by the application.
enum ItemType { consumable, weapon, armor, accessory, keyItem, other }

extension ItemTypeX on ItemType {
  String toShortString() {
    switch (this) {
      case ItemType.consumable:
        return 'consumable';
      case ItemType.weapon:
        return 'weapon';
      case ItemType.armor:
        return 'armor';
      case ItemType.accessory:
        return 'accessory';
      case ItemType.keyItem:
        return 'key_item';
      case ItemType.other:
        return 'other';
    }
  }

  static ItemType fromString(String? value) {
    if (value == null) return ItemType.other;
    switch (value.toLowerCase()) {
      case 'consumable':
        return ItemType.consumable;
      case 'weapon':
        return ItemType.weapon;
      case 'armor':
        return ItemType.armor;
      case 'accessory':
        return ItemType.accessory;
      case 'key_item':
      case 'key-item':
      case 'keyitem':
        return ItemType.keyItem;
      default:
        return ItemType.other;
    }
  }
}

/// Rarity tiers for items.
enum Rarity { common, uncommon, rare, epic, legendary, unique }

extension RarityX on Rarity {
  String toShortString() {
    switch (this) {
      case Rarity.common:
        return 'common';
      case Rarity.uncommon:
        return 'uncommon';
      case Rarity.rare:
        return 'rare';
      case Rarity.epic:
        return 'epic';
      case Rarity.legendary:
        return 'legendary';
      case Rarity.unique:
        return 'unique';
    }
  }

  static Rarity fromString(String? value) {
    if (value == null) return Rarity.common;
    switch (value.toLowerCase()) {
      case 'common':
        return Rarity.common;
      case 'uncommon':
        return Rarity.uncommon;
      case 'rare':
        return Rarity.rare;
      case 'epic':
        return Rarity.epic;
      case 'legendary':
        return Rarity.legendary;
      case 'unique':
        return Rarity.unique;
      default:
        return Rarity.common;
    }
  }
}

/// Model representing an Item.
///
/// Required fields:
/// - `id` (unique identifier)
/// - `name` (display name)
/// - `type` (one of the `ItemType` values)
///
/// Optional fields:
/// - `description`, `flavorText` (strings)
/// - `cost`, `sell` (ints)
/// - `rarity` (Rarity)
/// - `soulbound` (bool)
/// - `sold_at` (list of vendor ids / names)
class Item extends Equatable {
  const Item({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.flavorText,
    this.cost,
    this.sell,
    this.rarity,
    this.soulbound,
    List<String>? soldAt,
  }) : soldAt = soldAt ?? const <String>[];

  factory Item.fromJson(Map<String, dynamic> json) {
    List<String> vendors = <String>[];
    if (json['sold_at'] is List) {
      // ignore: always_specify_types
      vendors = (json['sold_at'] as List).whereType<String>().toList();
    }

    return Item(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: ItemTypeX.fromString(json['type']?.toString()),
      description: json['description']?.toString(),
      flavorText: json['flavor_text']?.toString(),
      cost: json['cost'] is int
          ? json['cost'] as int
          : int.tryParse(json['cost']?.toString() ?? ''),
      sell: json['sell'] is int
          ? json['sell'] as int
          : int.tryParse(json['sell']?.toString() ?? ''),
      rarity: json['rarity'] is String
          ? RarityX.fromString(json['rarity']?.toString())
          : null,
      soulbound: json['soulbound'] is bool
          ? json['soulbound'] as bool
          : (json['soulbound'] != null
              ? (json['soulbound'].toString().toLowerCase() == 'true')
              : null),
      soldAt: vendors,
    );
  }

  final String id;
  final String name;
  final ItemType type;

  // Optional
  final String? description;
  final String? flavorText;
  final int? cost;
  final int? sell;
  final Rarity? rarity;
  final bool? soulbound;
  final List<String> soldAt;

  Item copyWith({
    String? id,
    String? name,
    ItemType? type,
    String? description,
    String? flavorText,
    int? cost,
    int? sell,
    Rarity? rarity,
    bool? soulbound,
    List<String>? soldAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      flavorText: flavorText ?? this.flavorText,
      cost: cost ?? this.cost,
      sell: sell ?? this.sell,
      rarity: rarity ?? this.rarity,
      soulbound: soulbound ?? this.soulbound,
      soldAt: soldAt ?? List<String>.from(this.soldAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'type': type.toShortString(),
        'description': description,
        'flavor_text': flavorText,
        'cost': cost,
        'sell': sell,
        'rarity': rarity?.toShortString(),
        'soulbound': soulbound,
        'sold_at': soldAt,
      };

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        type,
        description,
        flavorText,
        cost,
        sell,
        rarity,
        soulbound,
        soldAt,
      ];
}

// Example JSON:
// {
//  "id": "item-1",
//  "name": "Potion",
//  "type": "consumable",
//  "description": "Restores a small amount of HP.",
//  "flavor_text": "A worn vial of red liquid.",
//  "cost": 50,
//  "sell": 25,
//  "rarity": "common",
//  "soulbound": false,
//  "sold_at": ["shop-1", "market"]
// }
