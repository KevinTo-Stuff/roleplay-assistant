// Flutter / package imports

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/character.dart';

/// State for the Character Creator form.
///
/// Keeps simple, serializable form fields and submission status.
class CharacterCreatorState extends Equatable {
  const CharacterCreatorState({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.gender,
    required this.age,
    this.description,
    this.resistances = const <String, String>{},
    this.stats = const <String, int>{},
    this.positiveTraits = const <String>[],
    this.negativeTraits = const <String>[],
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  factory CharacterCreatorState.initial() => const CharacterCreatorState(
        firstName: '',
        middleName: null,
        lastName: '',
        gender: Gender.other,
        age: 0,
      );

  final String firstName;
  final String? middleName;
  final String lastName;
  final Gender gender;
  final int age;
  final String? description;
  final Map<String, String> resistances;
  final Map<String, int> stats;
  final List<String> positiveTraits;
  final List<String> negativeTraits;

  // submission status
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  CharacterCreatorState copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    Gender? gender,
    int? age,
    String? description,
    Map<String, String>? resistances,
    Map<String, int>? stats,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    List<String>? positiveTraits,
    List<String>? negativeTraits,
  }) {
    return CharacterCreatorState(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      description: description ?? this.description,
      resistances: resistances ?? Map<String, String>.from(this.resistances),
      stats: stats ?? Map<String, int>.from(this.stats),
      positiveTraits: positiveTraits ?? List<String>.from(this.positiveTraits),
      negativeTraits: negativeTraits ?? List<String>.from(this.negativeTraits),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty && age >= 0;

  @override
  List<Object?> get props => <Object?>[
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
        isSubmitting,
        isSuccess,
        errorMessage,
      ];
}
