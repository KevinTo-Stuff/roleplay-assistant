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
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result == null || result.trim().isEmpty) return;

    final Roleplay rp = Roleplay(
      name: result.trim(),
      active: false,
      description: '',
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
      body: ListView(
        padding: const EdgeInsets.all(Dimens.spacing),
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
          // Roleplays list
          FutureBuilder<List<Roleplay>>(
            future: _futureRoleplays,
            builder: (BuildContext ctx, AsyncSnapshot<List<Roleplay>> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snap.hasError) {
                return Text(
                  'Failed to load roleplays',
                  style: context.textTheme.bodyMedium,
                );
              }

              final List<Roleplay> items = snap.data ?? <Roleplay>[];
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimens.spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Create a new roleplay from the settings or import one to get started.',
                          style: context.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: items.map((Roleplay r) {
                  final String title = r.name;
                  final String subtitle = r.description.isNotEmpty
                      ? r.description
                      : 'Tap to open or long press for options';

                  return Card(
                    key: ValueKey<String>(r.id ?? r.name),
                    margin: const EdgeInsets.symmetric(
                      vertical: Dimens.minSpacing / 2,
                    ),
                    elevation: 2.5,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacing,
                        vertical: Dimens.minSpacing,
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        child: Text(
                          title.isNotEmpty ? title[0].toUpperCase() : '?',
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      title: Text(title, style: context.textTheme.titleMedium),
                      subtitle:
                          Text(subtitle, style: context.textTheme.labelSmall),
                      trailing: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      // Only display the name for now
                      onTap: () {
                        // Navigate to the RoleplayScreen and pass the selected
                        // roleplay's name. Using a direct MaterialPageRoute so
                        // we don't need to regenerate auto_route code.
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext ctx) =>
                                RoleplayScreen(roleplay: r),
                          ),
                        );
                      },
                      onLongPress: () => _showOptionsForRoleplay(r),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
