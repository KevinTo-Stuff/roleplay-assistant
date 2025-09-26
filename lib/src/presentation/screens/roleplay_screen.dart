// Flutter imports:
// ignore_for_file: always_specify_types

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/routing/app_router.dart';
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import 'package:roleplay_assistant/src/presentation/screens/skills_screen.dart';
import 'package:roleplay_assistant/src/shared/locator.dart';
import 'package:roleplay_assistant/src/shared/models/character.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay_settings.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';
import 'package:roleplay_assistant/src/shared/services/roleplay/roleplay_storage.dart';
import 'package:roleplay_assistant/src/shared/widgets/buttons/button.dart';
import 'package:roleplay_assistant/src/shared/widgets/buttons/square_button.dart';

@RoutePage()
class RoleplayScreen extends StatefulWidget {
  const RoleplayScreen({super.key, required this.roleplay});

  /// The full Roleplay object to display and edit.
  final Roleplay roleplay;

  @override
  State<RoleplayScreen> createState() => _RoleplayScreenState();
}

class _RoleplayScreenState extends State<RoleplayScreen> {
  late Roleplay _roleplay;

  @override
  void initState() {
    super.initState();
    _roleplay = widget.roleplay;
  }

  Future<void> _toggleActive() async {
    final RoleplayStorage storage = locator<RoleplayStorage>();
    final Roleplay updated = _roleplay.copyWith(active: !_roleplay.active);
    setState(() {
      _roleplay = updated;
    });
    if (updated.id != null) {
      await storage.update(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        _roleplay.name.isNotEmpty ? _roleplay.name : 'Roleplay';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: Dimens.spacing),
            child: IconButton(
              tooltip: _roleplay.active ? 'Active' : 'Inactive',
              onPressed: _toggleActive,
              icon: Icon(
                _roleplay.active ? Icons.check_circle : Icons.cancel,
                color: _roleplay.active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _roleplay.description.isNotEmpty
                  ? _roleplay.description
                  : 'No description provided.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: Dimens.spacing),
            const SizedBox(height: Dimens.spacing),
            Button.outline(
              title: 'Roleplay Settings',
              onPressed: () async {
                final Object? result = await context.router.push(
                  RoleplaySettingsRoute(
                    initial: _roleplay.settings,
                  ),
                );
                if (result is RoleplaySettings) {
                  final RoleplayStorage storage = locator<RoleplayStorage>();
                  final Roleplay updated = _roleplay.copyWith(settings: result);
                  setState(() {
                    _roleplay = updated;
                  });
                  if (updated.id != null) {
                    await storage.update(updated);
                  }
                }
              },
            ),
            // Active indicator moved to AppBar actions
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
                    onPressed: () async {
                      // Navigate to the Characters screen using auto_route and provide onChanged callback.
                      final RoleplayStorage storage =
                          locator<RoleplayStorage>();
                      final Object? result = await context.router.push(
                        CharacterRoute(
                          characters: _roleplay.characters,
                          settings: _roleplay.settings,
                        ),
                      );
                      if (result is List<Character>) {
                        final Roleplay updatedRp = _roleplay.copyWith(
                          characters: result,
                        );
                        if (updatedRp.id != null) {
                          await storage.update(updatedRp);
                        }
                        setState(() {
                          _roleplay = updatedRp;
                        });
                      }
                    },
                    icon: const Icon(Icons.person),
                    size: itemSize,
                    label: 'Characters',
                  ),
                  SquareButton.primary(
                    onPressed: () async {
                      await Navigator.of(context).push<Object>(
                        MaterialPageRoute<Object>(
                          builder: (BuildContext ctx) => SkillsScreen(
                            skills: _roleplay.skills,
                            onAdd: (skill) async {
                              final Roleplay updated = _roleplay.copyWith(
                                skills: List.from(_roleplay.skills)..add(skill),
                              );
                              setState(() {
                                _roleplay = updated;
                              });
                              final RoleplayStorage storage =
                                  locator<RoleplayStorage>();
                              if (updated.id != null) {
                                await storage.update(updated);
                              }
                            },
                            onUpdate: (skill) async {
                              final List<Skill> newSkills =
                                  List<Skill>.from(_roleplay.skills);
                              final int idx =
                                  newSkills.indexWhere((s) => s.id == skill.id);
                              if (idx >= 0) newSkills[idx] = skill;
                              final Roleplay updated =
                                  _roleplay.copyWith(skills: newSkills);
                              setState(() {
                                _roleplay = updated;
                              });
                              final RoleplayStorage storage =
                                  locator<RoleplayStorage>();
                              if (updated.id != null) {
                                await storage.update(updated);
                              }
                            },
                            onDelete: (String id) async {
                              final List<Skill> newSkills =
                                  List<Skill>.from(_roleplay.skills)
                                    ..removeWhere((s) => s.id == id);
                              final Roleplay updated =
                                  _roleplay.copyWith(skills: newSkills);
                              setState(() {
                                _roleplay = updated;
                              });
                              final RoleplayStorage storage =
                                  locator<RoleplayStorage>();
                              if (updated.id != null) {
                                await storage.update(updated);
                              }
                            },
                          ),
                        ),
                      );
                    },
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
                    onPressed: () async {
                      await context.router.push(const ToolsRoute());
                    },
                    icon: const Icon(Icons.inventory_2),
                    size: itemSize,
                    label: 'Items',
                  ),
                  SquareButton.primary(
                    onPressed: () async {
                      await context.router.push(const ToolsRoute());
                    },
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
                      .map((Widget w) => SizedBox(width: itemSize, child: w))
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
