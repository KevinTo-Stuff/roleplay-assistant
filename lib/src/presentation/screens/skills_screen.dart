// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';

// Project imports:
import 'package:roleplay_assistant/src/presentation/widgets/skills_creator.dart';
import 'package:roleplay_assistant/src/shared/models/skill.dart';

@RoutePage()
class SkillsScreen extends StatefulWidget {
  const SkillsScreen(
      {super.key,
      this.skills = const <Skill>[],
      this.onAdd,
      this.onUpdate,
      this.onDelete,});

  final List<Skill> skills;
  final void Function(Skill)? onAdd;
  final void Function(Skill)? onUpdate;
  final void Function(String /* id */)? onDelete;

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  late List<Skill> _skills;

  @override
  void initState() {
    super.initState();
    _skills = List<Skill>.from(widget.skills);
  }

  Future<void> _openCreator() async {
    final Object? result = await Navigator.of(context).push<Object>(
      MaterialPageRoute<Object>(
        builder: (BuildContext ctx) => const SkillsCreatorScreen.fullscreen(),
        fullscreenDialog: true,
      ),
    );

    if (result is Skill) {
      setState(() {
        _skills.add(result);
      });
      widget.onAdd?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreator,
        child: const Icon(Icons.add),
      ),
      body: _skills.isEmpty
          ? const Center(child: Text('No skills yet. Tap + to add one.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (BuildContext ctx, int index) {
                final Skill s = _skills[index];
                return ListTile(
                  title: Text(s.name),
                  subtitle: s.description != null && s.description!.isNotEmpty
                      ? Text(s.description!)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (s.cost != null)
                        Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text('${s.cost}'),),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        onPressed: () async {
                          final Object? res =
                              await Navigator.of(context).push<Object>(
                            MaterialPageRoute<Object>(
                              builder: (BuildContext ctx) =>
                                  SkillsCreatorScreen.fullscreen(initial: s),
                              fullscreenDialog: true,
                            ),
                          );
                          if (res is Skill) {
                            setState(() {
                              _skills[index] = res;
                            });
                            widget.onUpdate?.call(res);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final bool? confirmed = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext dctx) => AlertDialog(
                              title: const Text('Delete skill?'),
                              content: Text(
                                  'Delete "${s.name}"? This cannot be undone.',),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(dctx).pop(false),
                                    child: const Text('Cancel'),),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(dctx).pop(true),
                                    child: const Text('Delete'),),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            setState(() {
                              _skills.removeAt(index);
                            });
                            widget.onDelete?.call(s.id);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: _skills.length,
            ),
    );
  }
}
