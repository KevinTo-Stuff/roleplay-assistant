// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
// Project imports:
import 'package:roleplay_assistant/src/shared/widgets/buttons/square_button.dart';

@RoutePage()
class RoleplayScreen extends StatelessWidget {
  const RoleplayScreen({super.key, required this.roleplay});

  /// The full Roleplay object to display and edit.
  final Roleplay roleplay;

  @override
  Widget build(BuildContext context) {
    final String title = roleplay.name.isNotEmpty ? roleplay.name : 'Roleplay';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              roleplay.description.isNotEmpty
                  ? roleplay.description
                  : 'No description provided.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: Dimens.spacing),
            Row(
              children: <Widget>[
                const Text('Active: '),
                Icon(
                  roleplay.active ? Icons.check_circle : Icons.cancel,
                  color: roleplay.active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacing),
            // Responsive square buttons for quick actions
            const SizedBox(height: Dimens.spacing),
            LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                // Determine number of columns based on available width
                final double maxWidth = constraints.maxWidth;
                final int columns;
                if (maxWidth >= 900) {
                  columns = 6; // large screens: all buttons in one row
                } else if (maxWidth >= 600) {
                  columns = 3; // tablet: 3 columns
                } else {
                  columns = 2; // phones: 2 columns
                }

                // size for each square button: try to fit nicely with spacing
                final double spacing = Dimens.spacing;
                final double itemSize =
                    (maxWidth - (spacing * (columns - 1))) / columns;

                final List<Widget> items = <Widget>[
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                    size: itemSize,
                    label: 'Characters',
                  ),
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.auto_fix_high),
                    size: itemSize,
                    label: 'Skills',
                  ),
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.book),
                    size: itemSize,
                    label: 'Compendium',
                  ),
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.inventory_2),
                    size: itemSize,
                    label: 'Items',
                  ),
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.build),
                    size: itemSize,
                    label: 'Tools',
                  ),
                  SquareButton.primary(
                    onPressed: () {},
                    icon: const Icon(Icons.map),
                    size: itemSize,
                    label: 'Maps',
                  ),
                ];

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items
                      .map((w) => SizedBox(width: itemSize, child: w))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
