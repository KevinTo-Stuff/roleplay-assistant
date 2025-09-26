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
      settings: RoleplaySettings.empty(),
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
