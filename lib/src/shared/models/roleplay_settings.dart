// Dart imports:
import 'dart:convert';

class RoleplaySettings {
  // Named constructor for empty/default values
  factory RoleplaySettings.empty() => RoleplaySettings(
        resistences: <String>[],
        resistanceLevels: <String>[],
        stats: <String>[],
      );

  RoleplaySettings({
    required this.resistences,
    required this.resistanceLevels,
    required this.stats,
  });

  factory RoleplaySettings.fromJson(Map<String, dynamic> json) {
    return RoleplaySettings(
      resistences: List<String>.from(json['resistences'] ?? <dynamic>[]),
      resistanceLevels:
          List<String>.from(json['resistance_levels'] ?? <dynamic>[]),
      stats: List<String>.from(json['stats'] ?? <dynamic>[]),
    );
  }
  final List<String> resistences;
  final List<String> resistanceLevels;
  final List<String> stats;

  // CopyWith method
  RoleplaySettings copyWith({
    List<String>? resistences,
    List<String>? resistanceLevels,
    List<String>? stats,
  }) {
    return RoleplaySettings(
      resistences: resistences ?? this.resistences,
      resistanceLevels: resistanceLevels ?? this.resistanceLevels,
      stats: stats ?? this.stats,
    );
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleplaySettings &&
          runtimeType == other.runtimeType &&
          resistences == other.resistences &&
          resistanceLevels == other.resistanceLevels &&
          stats == other.stats;

  @override
  int get hashCode =>
      resistences.hashCode ^ resistanceLevels.hashCode ^ stats.hashCode;

  // Serialization
  Map<String, dynamic> toJson() => <String, dynamic>{
        'resistences': resistences,
        'resistance_levels': resistanceLevels,
        'stats': stats,
      };

  // String representation
  @override
  String toString() => jsonEncode(toJson());
}
