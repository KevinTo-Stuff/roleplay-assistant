// Package imports:
import 'package:equatable/equatable.dart';

/// Gender for a character.
enum Gender { male, female, nonBinary, other }

extension GenderX on Gender {
  String toShortString() {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.nonBinary:
        return 'non-binary';
      case Gender.other:
        return 'other';
    }
  }

  static Gender fromString(String? value) {
    if (value == null) return Gender.other;
    switch (value.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'non-binary':
      case 'nonbinary':
      case 'non_binary':
        return Gender.nonBinary;
      default:
        return Gender.other;
    }
  }
}

/// Resistance level used in the `resistances` map.
enum ResistanceLevel { weak, neutral, resistant, immune, reflect, drain }

extension ResistanceLevelX on ResistanceLevel {
  String toShortString() {
    switch (this) {
      case ResistanceLevel.weak:
        return 'weak';
      case ResistanceLevel.neutral:
        return 'neutral';
      case ResistanceLevel.resistant:
        return 'resistant';
      case ResistanceLevel.immune:
        return 'immune';
      case ResistanceLevel.reflect:
        return 'reflect';
      case ResistanceLevel.drain:
        return 'drain';
    }
  }

  static ResistanceLevel fromString(String? value) {
    if (value == null) return ResistanceLevel.neutral;
    switch (value.toLowerCase()) {
      case 'weak':
        return ResistanceLevel.weak;
      case 'neutral':
        return ResistanceLevel.neutral;
      case 'resistant':
        return ResistanceLevel.resistant;
      case 'immune':
        return ResistanceLevel.immune;
      case 'reflect':
        return ResistanceLevel.reflect;
      case 'drain':
        return ResistanceLevel.drain;
      default:
        return ResistanceLevel.neutral;
    }
  }
}

/// Model representing a roleplay character.
///
/// Required fields:
/// - `id` (unique identifier)
/// - `firstName`, `lastName` (strings)
/// - `gender` (one of male/female/non-binary/other)
/// - `age` (int)
///
/// Optional fields:
/// - `middleName`, `description`
/// - `resistances`: `Map<String, ResistanceLevel>`
/// - `stats`: `Map<String, int>`
/// - `positiveTraits`, `negativeTraits`: `List<String>`
class Character extends Equatable {
  const Character({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.age,
    this.middleName,
    this.description,
    Map<String, ResistanceLevel>? resistances,
    Map<String, int>? stats,
    List<String>? positiveTraits,
    List<String>? negativeTraits,
  })  : resistances = resistances ?? const <String, ResistanceLevel>{},
        stats = stats ?? const <String, int>{},
        positiveTraits = positiveTraits ?? const <String>[],
        negativeTraits = negativeTraits ?? const <String>[];

  /// Create a Character from JSON map.
  factory Character.fromJson(Map<String, dynamic> json) {
    final Map<String, ResistanceLevel> rawRes = <String, ResistanceLevel>{};
    if (json['resistances'] is Map) {
      // ignore: always_specify_types
      (json['resistances'] as Map).forEach((k, v) {
        if (k is String) rawRes[k] = ResistanceLevelX.fromString(v?.toString());
      });
    }

    final Map<String, int> rawStats = <String, int>{};
    if (json['stats'] is Map) {
      // ignore: always_specify_types
      (json['stats'] as Map).forEach((k, v) {
        if (k is String) {
          final int intVal =
              v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;
          rawStats[k] = intVal;
        }
      });
    }

    List<String> posTraits = <String>[];
    if (json['positive_traits'] is List) {
      // ignore: always_specify_types
      posTraits =
          // ignore: always_specify_types
          (json['positive_traits'] as List).whereType<String>().toList();
    }

    List<String> negTraits = <String>[];
    if (json['negative_traits'] is List) {
      // ignore: always_specify_types
      negTraits =
          // ignore: always_specify_types
          (json['negative_traits'] as List).whereType<String>().toList();
    }

    return Character(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      middleName: json['middle_name']?.toString(),
      lastName: json['last_name']?.toString() ?? '',
      gender: GenderX.fromString(json['gender']?.toString()),
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      resistances: rawRes,
      stats: rawStats,
      positiveTraits: posTraits,
      negativeTraits: negTraits,
    );
  }
  final String id;
  final String firstName;
  final String lastName;
  final Gender gender;
  final int age;

  // Optional
  final String? middleName;
  final String? description;
  final Map<String, ResistanceLevel> resistances;
  final Map<String, int> stats;
  final List<String> positiveTraits;
  final List<String> negativeTraits;

  Character copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Gender? gender,
    int? age,
    String? middleName,
    String? description,
    Map<String, ResistanceLevel>? resistances,
    Map<String, int>? stats,
    List<String>? positiveTraits,
    List<String>? negativeTraits,
  }) {
    return Character(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      middleName: middleName ?? this.middleName,
      description: description ?? this.description,
      resistances:
          resistances ?? Map<String, ResistanceLevel>.from(this.resistances),
      stats: stats ?? Map<String, int>.from(this.stats),
      positiveTraits: positiveTraits ?? List<String>.from(this.positiveTraits),
      negativeTraits: negativeTraits ?? List<String>.from(this.negativeTraits),
    );
  }

  /// Convert to a JSON-compatible map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'gender': gender.toShortString(),
        'age': age,
        'description': description,
        // ignore: always_specify_types
        'resistances': resistances.map(
          // ignore: always_specify_types
          (String k, ResistanceLevel v) => MapEntry(k, v.toShortString()),
        ),
        'stats': stats,
        'positive_traits': positiveTraits,
        'negative_traits': negativeTraits,
      };

  @override
  List<Object?> get props => <Object?>[
        id,
        firstName,
        middleName,
        lastName,
        gender,
        age,
        description,
        resistances,
        stats,
        positiveTraits,
        negativeTraits,
      ];
}

// Example JSON representation:
// {
//   "id": "uuid-123",
//   "first_name": "Alyx",
//   "middle_name": "M.",
//   "last_name": "Vance",
//   "gender": "female",
//   "age": 29,
//   "description": "A scientist from City 17.",
//   "resistances": {"fire": "weak", "ice": "resistant"},
//   "stats": {"strength": 5, "intelligence": 9},
//   "positive_traits": ["brave", "resourceful"],
//   "negative_traits": ["impatient"]
// }
