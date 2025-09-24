// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/routing/app_router.dart';
import 'package:roleplay_assistant/src/core/theme/dimens.dart';
import 'package:roleplay_assistant/src/presentation/screens/roleplay_screen.dart';
import 'package:roleplay_assistant/src/shared/extensions/context_extensions.dart';
import 'package:roleplay_assistant/src/shared/locator.dart';
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/services/roleplay/roleplay_storage.dart';
import 'package:roleplay_assistant/src/shared/widgets/buttons/button.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoleplayStorage _storage = locator<RoleplayStorage>();
  late Future<List<Roleplay>> _futureRoleplays;

  @override
  void initState() {
    super.initState();
    _futureRoleplays = _storage.list();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureRoleplays = _storage.list();
    });
  }

  Future<void> _showCreateDialog() async {
    final TextEditingController controller = TextEditingController();
    final TextEditingController descController = TextEditingController();

    final String? result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: Dimens.spacing,
            right: Dimens.spacing,
            top: Dimens.spacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Create Roleplay', style: ctx.textTheme.titleMedium),
              const SizedBox(height: Dimens.minSpacing),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onSubmitted: (String v) {
                  // move focus to description when pressing next
                  // (handled automatically by the keyboard in many platforms)
                },
              ),
              const SizedBox(height: Dimens.minSpacing),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onSubmitted: (String v) {
                  final String name = controller.text.trim();
                  final String description = v.trim();
                  if (name.isEmpty) return;
                  Navigator.of(ctx)
                      .pop(<String>[name, description].join('\u0000'));
                },
              ),
              const SizedBox(height: Dimens.spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: Dimens.minSpacing),
                  ElevatedButton(
                    onPressed: () {
                      final String name = controller.text.trim();
                      final String description = descController.text.trim();
                      if (name.isEmpty) return;
                      Navigator.of(ctx)
                          .pop(<String>[name, description].join('\u0000'));
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result == null) return;

    // We passed name and description joined by a null separator above.
    final List<String> parts = result.split('\u0000');
    final String name = parts.isNotEmpty ? parts[0].trim() : '';
    final String description = parts.length > 1 ? parts[1].trim() : '';
    if (name.isEmpty) return;

    final Roleplay rp = Roleplay(
      name: name,
      active: true,
      description: description,
      // characters left unspecified -> defaults to empty list
    );

    await _storage.create(rp);
    await _refresh();
  }

  Future<void> _showOptionsForRoleplay(Roleplay r) async {
    final String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () => Navigator.of(ctx).pop('edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () => Navigator.of(ctx).pop('delete'),
              ),
              const SizedBox(height: Dimens.minSpacing),
            ],
          ),
        );
      },
    );

    if (action == 'edit') {
      await _showEditDialog(r);
    } else if (action == 'delete') {
      await _confirmDelete(r);
    }
  }

  Future<void> _showEditDialog(Roleplay r) async {
    final TextEditingController controller =
        TextEditingController(text: r.name);

    final String? result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: Dimens.spacing,
            right: Dimens.spacing,
            top: Dimens.spacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Edit Roleplay', style: ctx.textTheme.titleMedium),
              const SizedBox(height: Dimens.minSpacing),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.done,
                onSubmitted: (String v) {
                  final String name = v.trim();
                  if (name.isEmpty) return;
                  Navigator.of(ctx).pop(name);
                },
              ),
              const SizedBox(height: Dimens.spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: Dimens.minSpacing),
                  ElevatedButton(
                    onPressed: () {
                      final String name = controller.text.trim();
                      if (name.isEmpty) return;
                      Navigator.of(ctx).pop(name);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result == null || result.trim().isEmpty) return;

    final Roleplay updated = r.copyWith(name: result.trim());
    await _storage.update(updated);
    await _refresh();
  }

  Future<void> _confirmDelete(Roleplay r) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Roleplay'),
          content: Text('Are you sure you want to delete "${r.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      if (r.id != null) {
        await _storage.delete(r.id!);
        await _refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Roleplay Assistant', style: context.textTheme.titleLarge),
            const SizedBox(height: Dimens.minSpacing),
            Text(
              'Welcome! This app helps you manage your roleplaying.',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: Dimens.spacing),
            Button.outline(
              title: 'Settings',
              onPressed: () {
                context.router.push(const SettingsRoute());
              },
            ),
            const SizedBox(height: Dimens.spacing),
            Button.primary(
              title: 'Add Roleplay',
              onPressed: _showCreateDialog,
            ),
            const SizedBox(height: Dimens.spacing),

            // Roleplays list area should scroll independently of the header
            Expanded(
              child: FutureBuilder<List<Roleplay>>(
                future: _futureRoleplays,
                builder:
                    (BuildContext ctx, AsyncSnapshot<List<Roleplay>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load roleplays',
                        style: context.textTheme.bodyMedium,
                      ),
                    );
                  }

                  final List<Roleplay> items = snap.data ?? <Roleplay>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Create a new roleplay from the settings or import one to get started.',
                        style: context.textTheme.labelMedium,
                      ),
                    );
                  }

                  final List<Roleplay> active =
                      items.where((Roleplay r) => r.active).toList();
                  final List<Roleplay> inactive =
                      items.where((Roleplay r) => !r.active).toList();

                  final List<Widget> listChildren = <Widget>[];

                  if (active.isNotEmpty) {
                    listChildren.add(
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimens.minSpacing),
                      ),
                    );
                    listChildren.addAll(
                      active
                          .map((Roleplay r) => _buildRoleplayCard(context, r)),
                    );
                  }

                  if (inactive.isNotEmpty) {
                    listChildren.add(const SizedBox(height: Dimens.spacing));
                    listChildren.add(
                      ExpansionTile(
                        childrenPadding: const EdgeInsets.fromLTRB(
                          0,
                          Dimens.spacing,
                          0,
                          Dimens.spacing,
                        ),
                        title: Text(
                          'Inactive Roleplays',
                          style: context.textTheme.titleMedium,
                        ),
                        initiallyExpanded: false,
                        children: inactive
                            .map(
                              (Roleplay r) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: Dimens.minSpacing / 2,
                                ),
                                child: _buildRoleplayCard(context, r),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }

                  return ListView(
                    children: listChildren,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleplayCard(BuildContext context, Roleplay r) {
    final String title = r.name;
    final String subtitle = r.description.isNotEmpty
        ? r.description
        : 'Tap to open or long press for options';

    final bool isActive = r.active;
    final double opacity = isActive ? 1.0 : 0.55;

    return Card(
      key: ValueKey<String>(r.id ?? r.name),
      margin: const EdgeInsets.symmetric(
        vertical: Dimens.minSpacing / 2,
      ),
      elevation: 2.5,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Opacity(
        opacity: opacity,
        // Keep interactive behavior but visually dim when inactive
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacing,
            vertical: Dimens.minSpacing,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : '?',
              style: context.textTheme.titleSmall,
            ),
          ),
          title: Text(title, style: context.textTheme.titleMedium),
          subtitle: Text(subtitle, style: context.textTheme.labelSmall),
          trailing: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            // Navigate to the Characters screen with the current
            // roleplay's characters using AutoRoute.
            context.router.push(
              RoleplayRoute(
                roleplay: r,
              ),
            );
          },
          onLongPress: () => _showOptionsForRoleplay(r),
        ),
      ),
    );
  }
}
