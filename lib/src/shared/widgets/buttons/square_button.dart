// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import 'package:roleplay_assistant/src/shared/extensions/context_extensions.dart';

enum SquareButtonType { primary, neutral, outline }

class SquareButton extends StatelessWidget {
  const SquareButton._({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    required this.type,
    required this.size,
  });

  factory SquareButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    Widget? icon,
    String? label,
    double size = kMinInteractiveDimension,
  }) {
    return SquareButton._(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      type: SquareButtonType.primary,
      size: size,
    );
  }

  factory SquareButton.neutral({
    Key? key,
    required VoidCallback? onPressed,
    Widget? icon,
    String? label,
    double size = kMinInteractiveDimension,
  }) {
    return SquareButton._(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      type: SquareButtonType.neutral,
      size: size,
    );
  }

  factory SquareButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    Widget? icon,
    String? label,
    double size = kMinInteractiveDimension,
  }) {
    return SquareButton._(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      type: SquareButtonType.outline,
      size: size,
    );
  }

  final VoidCallback? onPressed;
  final Widget? icon;
  final String? label;
  final SquareButtonType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = icon ?? const SizedBox();

    // Derive colors consistent with `Button` implementation
    final bool isPrimaryOrNeutral =
        type == SquareButtonType.primary || type == SquareButtonType.neutral;
    final Color backgroundColor = switch (type) {
      SquareButtonType.primary => context.colorScheme.primary,
      SquareButtonType.neutral => context.colorScheme.onSurface,
      SquareButtonType.outline => Colors.transparent,
    };
    final Color contentColor = isPrimaryOrNeutral
        ? context.colorScheme.surface
        : context.colorScheme.onSurface;

    final TextStyle labelStyle =
        (context.textTheme.labelSmall ?? const TextStyle())
            .copyWith(color: contentColor);

    final Widget childWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          IconTheme.merge(
            data: IconThemeData(color: contentColor, size: Dimens.iconSize),
            child: iconWidget,
          ),
        if (icon != null && label != null) const SizedBox(height: 4),
        if (label != null)
          Text(
            label!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
      ],
    );

    final ButtonStyle commonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius),
        ),
      ),
      minimumSize: MaterialStateProperty.all<Size>(Size(size, size)),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    );

    switch (type) {
      case SquareButtonType.primary:
        return SizedBox(
          width: size,
          // allow height to adapt when showing a label
          child: ElevatedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: contentColor,
                padding: EdgeInsets.zero,
              ),
            ),
            child: childWidget,
          ),
        );
      case SquareButtonType.neutral:
        return SizedBox(
          width: size,
          child: ElevatedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: contentColor,
                padding: EdgeInsets.zero,
              ),
            ),
            child: childWidget,
          ),
        );
      case SquareButtonType.outline:
        return SizedBox(
          width: size,
          child: OutlinedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              OutlinedButton.styleFrom(
                side: BorderSide(
                  color: context.colorScheme.onSurface.withValues(alpha: .3),
                  width: 1.2,
                ),
                foregroundColor: contentColor,
                padding: EdgeInsets.zero,
              ),
            ),
            child: childWidget,
          ),
        );
    }
  }
}
