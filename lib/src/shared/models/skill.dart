// Package imports:
import 'package:equatable/equatable.dart';

/// Model representing a Skill.
///
/// Required fields:
/// - `id`: unique identifier
/// - `name`: display name
///
/// Optional fields:
/// - `costType` (`cost_type` in JSON)
/// - `cost` (`int`)
/// - `type`
/// - `damageType` (`damage_type` in JSON)
/// - `description`
/// - `flavor`
class Skill extends Equatable {
  const Skill({
    required this.id,
    required this.name,
    this.costType,
    this.cost,
    this.type,
    this.damageType,
    this.description,
    this.flavor,
  });

  /// Create a Skill from a JSON map.
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      costType: json['cost_type']?.toString(),
      cost: json['cost'] is int
          ? json['cost'] as int
          : int.tryParse(json['cost']?.toString() ?? ''),
      type: json['type']?.toString(),
      damageType: json['damage_type']?.toString(),
      description: json['description']?.toString(),
      flavor: json['flavor']?.toString(),
    );
  }

  final String id;
  final String name;

  // Optional
  final String? costType;
  final int? cost;
  final String? type;
  final String? damageType;
  final String? description;
  final String? flavor;

  Skill copyWith({
    String? id,
    String? name,
    String? costType,
    int? cost,
    String? type,
    String? damageType,
    String? description,
    String? flavor,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      costType: costType ?? this.costType,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      damageType: damageType ?? this.damageType,
      description: description ?? this.description,
      flavor: flavor ?? this.flavor,
    );
  }

  /// Convert to a JSON-compatible map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'cost_type': costType,
        'cost': cost,
        'type': type,
        'damage_type': damageType,
        'description': description,
        'flavor': flavor,
      };

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        costType,
        cost,
        type,
        damageType,
        description,
        flavor,
      ];
}

// Example JSON:
// {
//   "id": "skill-1",
//   "name": "Fireball",
//   "cost_type": "mana",
//   "cost": 10,
//   "type": "spell",
//   "damage_type": "fire",
//   "description": "A ball of fire.",
//   "flavor": "A classic.",
// }
