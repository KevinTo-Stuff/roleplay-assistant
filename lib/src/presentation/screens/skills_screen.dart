// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/skill.dart';
import 'package:roleplay_assistant/src/presentation/widgets/skills_creator.dart';

@RoutePage()
class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key, this.skills = const <Skill>[], this.onAdd});

  final List<Skill> skills;
  final void Function(Skill)? onAdd;

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
      if (widget.onAdd != null) {
        widget.onAdd!(result);
      }
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
                  trailing: s.cost != null ? Text('${s.cost}') : null,
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: _skills.length,
            ),
    );
  }
}
