// Flutter imports:
// ignore_for_file: require_trailing_commas

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'character.dart';
import 'roleplay_settings.dart';
import 'skill.dart';

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
    );
  }

  final String name;
  final bool active;
  final String description;
  final String? id;
  final RoleplaySettings settings;
  final List<Character> characters;
  final List<Skill> skills;

  Roleplay copyWith({
    String? id,
    String? name,
    bool? active,
    String? description,
    RoleplaySettings? settings,
    List<Character>? characters,
    List<Skill>? skills,
  }) {
    return Roleplay(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      characters: characters ?? List<Character>.from(this.characters),
      skills: skills ?? List<Skill>.from(this.skills),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'active': active,
      'description': description,
      'settings': settings.toJson(),
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
        listEquals(other.skills, skills);
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
      );

  @override
  String toString() {
    return 'Roleplay(id: $id, name: $name, active: $active, description: $description, settings: $settings, characters: $characters, skills: $skills)';
  }
}
