// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
// Widgets
import 'package:roleplay_assistant/src/shared/widgets/buttons/square_button.dart';

@RoutePage()
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        // Data-driven list of tools so this can be extended easily.
        final List<Map<String, dynamic>> tools = <Map<String, dynamic>>[
          <String, dynamic>{
            'label': 'Dice Rolling',
            'icon': Icons.casino,
            'key': 'dice',
          },
          <String, dynamic>{
            'label': 'Damage Calculator',
            'icon': Icons.local_fire_department,
            'key': 'damage',
          },
          <String, dynamic>{
            'label': 'Run Simulator',
            'icon': Icons.directions_run,
            'key': 'run',
          },
          <String, dynamic>{
            'label': 'Battle Simulator',
            'icon': Icons.shield,
            'key': 'battle',
          },
        ];

        final double width = constraints.maxWidth;
        // Use the same breakpoints and sizing logic as RoleplayScreen so the
        // button tiles match visually.
        final int columns;
        if (width >= 900) {
          columns = 6;
        } else if (width >= 600) {
          columns = 3;
        } else {
          columns = 2;
        }

        final double spacing = Dimens.spacing;
        // Account for the padding we apply around the Wrap so sizing is based
        // on the actual available inner width (matching RoleplayScreen
        // behavior where LayoutBuilder is inside the Padding).
        final double innerWidth =
            (width - (Dimens.spacing * 2)).clamp(0.0, width);
        final double itemSize =
            (innerWidth - (spacing * (columns - 1))) / columns;

        final List<Widget> items = tools
            .map((Map<String, dynamic> t) => SquareButton.primary(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Open ${t['label']}')),
                    );
                  },
                  icon: Icon(t['icon'] as IconData),
                  label: t['label'] as String?,
                  size: itemSize,
                ),)
            .toList();

        return Padding(
          padding: const EdgeInsets.all(Dimens.spacing),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: items
                .map((Widget w) => SizedBox(width: itemSize, child: w))
                .toList(),
          ),
        );
      },),
    );
  }
}
