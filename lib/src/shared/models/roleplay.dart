// Flutter imports:
import 'package:flutter/foundation.dart';

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
  const Roleplay({
    this.id,
    required this.name,
    required this.active,
    required this.description,
    this.settings,
  });

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
      );
  final String name;
  final bool active;
  final String description;
  final String? id;
  final Map<String, dynamic>? settings;

  Roleplay copyWith({
    String? id,
    String? name,
    bool? active,
    String? description,
    Map<String, dynamic>? settings,
  }) {
    return Roleplay(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      description: description ?? this.description,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'active': active,
      'description': description,
      if (settings != null) 'settings': settings,
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
      );

  @override
  String toString() {
    return 'Roleplay(id: $id, name: $name, active: $active, description: $description, settings: $settings)';
  }
}
