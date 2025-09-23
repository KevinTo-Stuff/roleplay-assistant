// Flutter imports:
import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.onSuccess,
  });
  final Color success;
  final Color onSuccess;

  @override
  CustomColors copyWith({
    Color? success,
    Color? onSuccess,
  }) {
    return CustomColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
    );
  }

  static const CustomColors light = CustomColors(
    success: Color(0xFF616161),
    onSuccess: Color(0xFFFFFFFF),
  );

  static const CustomColors dark = CustomColors(
    success: Color(0xFFBDBDBD),
    onSuccess: Color(0xFF000000),
  );
}
