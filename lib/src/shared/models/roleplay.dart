// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'character.dart';

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
            ? Map<String, dynamic>.from(
                json['settings'] as Map<String, dynamic>,
              )
            : null,
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
      );

  const Roleplay({
    this.id,
    required this.name,
    required this.active,
    required this.description,
    this.settings,
    this.characters = const <Character>[],
  });

  /// Convenience factory that returns an empty/default Roleplay instance.
  ///
  /// Useful for initializing forms or creating placeholders.
  static Roleplay empty() {
    return const Roleplay(
      id: null,
      name: '',
      active: false,
      description: '',
      settings: null,
    );
  }

  final String name;
  final bool active;
  final String description;
  final String? id;
  final Map<String, dynamic>? settings;
  final List<Character> characters;

  Roleplay copyWith({
    String? id,
    String? name,
    bool? active,
    String? description,
    Map<String, dynamic>? settings,
    List<Character>? characters,
  }) {
    return Roleplay(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      characters: characters ?? List<Character>.from(this.characters),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'active': active,
      'description': description,
      if (settings != null) 'settings': settings,
      'characters': characters.map((Character c) => c.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Roleplay &&
        other.id == id &&
        other.name == name &&
        other.active == active &&
        other.description == description &&
        mapEquals(other.settings, settings);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        active,
        description,
        settings == null ? null : Object.hashAll(settings!.entries),
        Object.hashAll(characters),
      );

  @override
  String toString() {
    return 'Roleplay(id: $id, name: $name, active: $active, description: $description, settings: $settings, characters: $characters)';
  }
}
