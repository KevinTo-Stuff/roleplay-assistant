// Flutter imports:
// ignore_for_file: require_trailing_commas

// Flutter imports:
import 'package:flutter/foundation.dart';

// Dart imports:

// Project imports:
import 'character.dart';
import 'roleplay_settings.dart';
import 'skill.dart';
import 'item.dart';

// Local models:

// Local models:

/// Model representing a Roleplay configuration.
///
/// Fields:
/// - `name`: display name for the roleplay (non-nullable `String`).
/// - `active`: whether the roleplay is active (`bool`).
/// - `description`: a short description (`String`).
/// - `settings`: free-form settings for the roleplay. The exact shape will
///   be determined later; for now it's stored as `Map<String, dynamic>?`.
///
/// Note: `settings` is intentionally left flexible. Replace with a
/// strongly-typed settings class when the schema is decided.
class Roleplay {
  factory Roleplay.fromJson(Map<String, dynamic> json) => Roleplay(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        active: json['active'] as bool? ?? false,
        description: json['description'] as String? ?? '',
        settings: json['settings'] != null
            ? RoleplaySettings.fromJson(
                Map<String, dynamic>.from(
                    json['settings'] as Map<String, dynamic>),
              )
            : RoleplaySettings.empty(),
        characters: json['characters'] is List
            // ignore: always_specify_types
            ? (json['characters'] as List)
                // ignore: always_specify_types
                .where((e) => e != null)
                // ignore: always_specify_types
                .map<Character>(
                  // ignore: always_specify_types
                  (e) => e is Character
                      ? e
                      : Character.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : const <Character>[],
        items: json['items'] is List
            // ignore: always_specify_types
            ? (json['items'] as List)
                // ignore: always_specify_types
                .where((e) => e != null)
                // ignore: always_specify_types
                .map<Item>(
                  // ignore: always_specify_types
                  (e) =>
                      e is Item ? e : Item.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : const <Item>[],
        skills: json['skills'] is List
            // ignore: always_specify_types
            ? (json['skills'] as List)
                // ignore: always_specify_types
                .where((e) => e != null)
                // ignore: always_specify_types
                .map<Skill>(
                  // ignore: always_specify_types
                  (e) => e is Skill
                      ? e
                      : Skill.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : const <Skill>[],
      );

  const Roleplay({
    this.id,
    required this.name,
    required this.active,
    required this.description,
    required this.settings,
    this.characters = const <Character>[],
    this.skills = const <Skill>[],
    this.items = const <Item>[],
  });

  /// Convenience factory that returns an empty/default Roleplay instance.
  ///
  /// Useful for initializing forms or creating placeholders.
  static Roleplay empty() {
    return Roleplay(
      id: null,
      name: '',
      active: false,
      description: '',
      settings: RoleplaySettings(
        resistences: <String>['fire', 'ice'],
        resistanceLevels: <String>['weak', 'normal', 'resistant'],
        stats: <String>['strength', 'intelligence'],
        socialStats: <String>['reputation'],
      ),
    );
  }

  /// Convenience factory that returns a small example Roleplay used when the
  /// user has not created any roleplays yet. This contains one example
  /// character and a couple of simple skills so the UI has data to display.
  static Roleplay example() {
    return Roleplay(
      id: null,
      name: 'Example Roleplay',
      active: true,
      description:
          'A short example roleplay to demonstrate the app. Create your own to replace it.',
      settings: RoleplaySettings(
        resistences: <String>['fire', 'ice', 'poison', 'lightning'],
        resistanceLevels: <String>[
          'vulnerable',
          'weak',
          'normal',
          'resistant',
          'immune'
        ],
        stats: <String>['strength', 'intelligence', 'agility', 'charisma'],
        socialStats: <String>['reputation', 'influence'],
      ),
      characters: <Character>[
        const Character(
          id: 'example_char_1',
          firstName: 'Ari',
          lastName: 'Stone',
          gender: Gender.other,
          age: 28,
          description: 'An adventurous scout and the party face.',
          resistances: <String, String>{
            'fire': 'normal',
            'ice': 'weak',
            'poison': 'resistant'
          },
          stats: <String, int>{
            'strength': 6,
            'intelligence': 7,
            'agility': 8,
            'charisma': 5
          },
          socialStats: <String, int>{'reputation': 3, 'influence': 2},
          positiveTraits: <String>['brave', 'curious'],
          negativeTraits: <String>['reckless'],
        ),
        const Character(
          id: 'example_char_2',
          firstName: 'Bram',
          lastName: 'Hollow',
          gender: Gender.male,
          age: 35,
          description: 'A grizzled veteran with tactical sense.',
          resistances: <String, String>{
            'fire': 'resistant',
            'ice': 'normal',
            'lightning': 'weak'
          },
          stats: <String, int>{
            'strength': 8,
            'intelligence': 6,
            'agility': 4,
            'charisma': 4
          },
          socialStats: <String, int>{'reputation': 4, 'influence': 1},
          positiveTraits: <String>['steady', 'tactical'],
          negativeTraits: <String>['gruff'],
        ),
        const Character(
          id: 'example_char_3',
          firstName: 'Lyra',
          lastName: 'Vale',
          gender: Gender.female,
          age: 22,
          description: 'A young spellcaster learning her craft.',
          resistances: <String, String>{
            'fire': 'vulnerable',
            'ice': 'normal',
            'poison': 'weak',
            'lightning': 'normal'
          },
          stats: <String, int>{
            'strength': 3,
            'intelligence': 9,
            'agility': 6,
            'charisma': 7
          },
          socialStats: <String, int>{'reputation': 1, 'influence': 5},
          positiveTraits: <String>['studious', 'clever'],
          negativeTraits: <String>['timid'],
        ),
      ],
      skills: <Skill>[
        const Skill(
          id: 'example_skill_1',
          name: 'Quick Shot',
          costType: 'stamina',
          cost: 2,
          type: 'attack',
          damageType: 'piercing',
          description: 'A fast ranged attack that deals light damage.',
          flavor: 'A precise, rapid shot.',
        ),
        const Skill(
          id: 'example_skill_2',
          name: 'Inspire',
          costType: 'will',
          cost: 1,
          type: 'support',
          damageType: '',
          description: 'Boosts an ally\'s next roll by a small amount.',
          flavor: 'A rousing word or gesture.',
        ),
        const Skill(
          id: 'example_skill_3',
          name: 'Firebolt',
          costType: 'mana',
          cost: 3,
          type: 'attack',
          damageType: 'fire',
          description: 'A small bolt of fire that scorches a single target.',
          flavor: 'A bright flare of orange flame.',
        ),
        const Skill(
          id: 'example_skill_4',
          name: 'Heal',
          costType: 'mana',
          cost: 2,
          type: 'support',
          damageType: '',
          description: 'Restores a small amount of health to an ally.',
          flavor: 'A warm, mending light.',
        ),
      ],
      items: <Item>[
        const Item(
          id: 'example_item_1',
          name: 'Traveler\'s Rations',
          type: ItemType.consumable,
          description:
              'Simple preserved food to stave off hunger on long journeys.',
          flavorText: 'Hard tack and dried fruit in a leather wrap.',
          cost: 5,
          sell: 2,
          rarity: Rarity.common,
        ),
        const Item(
          id: 'example_item_2',
          name: 'Scout\'s Compass',
          type: ItemType.accessory,
          description: 'A compact compass used by scouts to navigate wilds.',
          flavorText: 'Its needle seems to point toward adventure.',
          cost: 25,
          sell: 10,
          rarity: Rarity.uncommon,
        ),
        const Item(
          id: 'example_item_3',
          name: 'Emberblade',
          type: ItemType.weapon,
          description: 'A short sword warmed with a faint, persistent heat.',
          flavorText: 'Once wielded by a soldier of the ashlands.',
          cost: 150,
          sell: 75,
          rarity: Rarity.rare,
        ),
        const Item(
          id: 'example_item_4',
          name: 'Sage\'s Grimoire',
          type: ItemType.keyItem,
          description: 'A worn book of beginner fire spells and notes.',
          flavorText: 'Pages stained with soot and careful annotations.',
          cost: 0,
          sell: 0,
          rarity: Rarity.uncommon,
          soulbound: true,
        ),
        const Item(
          id: 'example_item_5',
          name: 'Veteran\'s Band',
          type: ItemType.accessory,
          description: 'A battered iron band worn by veterans as a token.',
          flavorText: 'Keeps steady hands and steadier hearts.',
          cost: 45,
          sell: 20,
          rarity: Rarity.uncommon,
        ),
        const Item(
          id: 'example_item_6',
          name: 'Flame-Touched Vial',
          type: ItemType.consumable,
          description:
              'A vial containing a single volatile ember for casting small firebolts.',
          flavorText: 'Warms the palm with a tiny, controllable spark.',
          cost: 60,
          sell: 30,
          rarity: Rarity.rare,
        ),
      ],
    );
  }

  final String name;
  final bool active;
  final String description;
  final String? id;
  final RoleplaySettings settings;
  final List<Character> characters;
  final List<Skill> skills;
  final List<Item> items;

  Roleplay copyWith({
    String? id,
    String? name,
    bool? active,
    String? description,
    RoleplaySettings? settings,
    List<Character>? characters,
    List<Skill>? skills,
    List<Item>? items,
  }) {
    return Roleplay(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      characters: characters ?? List<Character>.from(this.characters),
      skills: skills ?? List<Skill>.from(this.skills),
      items: items ?? List<Item>.from(this.items),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'active': active,
      'description': description,
      'settings': settings.toJson(),
      'items': items.map((Item i) => i.toJson()).toList(),
      'characters': characters.map((Character c) => c.toJson()).toList(),
      'skills': skills.map((Skill s) => s.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Roleplay) return false;
    return other.id == id &&
        other.name == name &&
        other.active == active &&
        other.description == description &&
        other.settings == settings &&
        listEquals(other.characters, characters) &&
        listEquals(other.skills, skills) &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        active,
        description,
        settings.hashCode,
        Object.hashAll(characters),
        Object.hashAll(skills),
        Object.hashAll(items),
      );

  @override
  String toString() {
    return 'Roleplay(id: $id, name: $name, active: $active, description: $description, settings: $settings, characters: $characters, skills: $skills, items: $items)';
  }
}
