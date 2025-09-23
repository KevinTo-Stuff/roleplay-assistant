// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/services/roleplay/roleplay_storage.dart';
import 'package:roleplay_assistant/src/shared/services/storage/local_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RoleplayStorage', () {
    late LocalStorage local;
    late RoleplayStorage repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      local = LocalStorage();
      await local.init();
      repo = RoleplayStorage(storage: local);
      await repo.clear();
    });

    test('create and list', () async {
      final Roleplay r = const Roleplay(name: 'Test', active: true, description: 'd');
      final Roleplay created = await repo.create(r);
      expect(created.id, isNotNull);

      final List<Roleplay> all = await repo.list();
      expect(all.length, 1);
      expect(all.first.name, 'Test');
    });

    test('getById returns null for missing', () async {
      final Roleplay? got = await repo.getById('nope');
      expect(got, isNull);
    });

    test('update existing', () async {
      final Roleplay r = const Roleplay(name: 'a', active: false, description: 'd');
      final Roleplay created = await repo.create(r);
      final Roleplay updated = created.copyWith(name: 'b');
      final Roleplay? result = await repo.update(updated);
      expect(result, isNotNull);
      expect(result!.name, 'b');

      final Roleplay? fetched = await repo.getById(created.id!);
      expect(fetched!.name, 'b');
    });

    test('delete existing', () async {
      final Roleplay r = const Roleplay(name: 'x', active: false, description: 'd');
      final Roleplay created = await repo.create(r);
      final bool deleted = await repo.delete(created.id!);
      expect(deleted, isTrue);
      final List<Roleplay> all = await repo.list();
      expect(all, isEmpty);
    });
  });
}
