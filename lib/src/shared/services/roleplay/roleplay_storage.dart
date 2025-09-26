// Dart imports:
// ignore_for_file: require_trailing_commas

import 'dart:convert';
import 'dart:math';

// Project imports:
import 'package:roleplay_assistant/src/shared/models/roleplay.dart';
import 'package:roleplay_assistant/src/shared/services/storage/keys.dart';
import 'package:roleplay_assistant/src/shared/services/storage/storage.dart';

/// Simple persistent storage helper for `Roleplay` objects.
///
/// Stores a JSON encoded list under the key `roleplays` using the provided
/// `Storage` implementation (backed by `SharedPreferences` in this app).
class RoleplayStorage {
  RoleplayStorage({required this.storage});

  final Storage storage;

  static const String _kKey = kRoleplaysStorageKey;
  final Random _random = Random.secure();

  String _generateId() {
    final int t = DateTime.now().toUtc().microsecondsSinceEpoch;
    final int r = _random.nextInt(0x7fffffff);
    return '${t}_$r';
  }

  Future<List<Roleplay>> _readAll() async {
    final List<String>? list = await storage.read<List<String>>(key: _kKey);
    // If nothing is stored yet, return a single example roleplay so the
    // app can show a helpful demo when first opened. Actual user-created
    // roleplays are persisted once created and will replace this example.
    if (list == null || list.isEmpty) return <Roleplay>[Roleplay.example()];
    try {
      return list
          .map((String e) =>
              Roleplay.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <Roleplay>[Roleplay.example()];
    }
  }

  Future<bool> _writeAll(List<Roleplay> items) async {
    final List<String> encoded =
        items.map((Roleplay e) => jsonEncode(e.toJson())).toList();
    return await storage.writeStringList(key: _kKey, value: encoded);
  }

  /// Returns all stored roleplays.
  Future<List<Roleplay>> list() async => await _readAll();

  /// Get a roleplay by id. Returns null if not found.
  Future<Roleplay?> getById(String id) async {
    final List<Roleplay> all = await _readAll();
    try {
      return all.firstWhere((Roleplay e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Create and persist a new roleplay. If `roleplay.id` is null a new id is assigned.
  Future<Roleplay> create(Roleplay roleplay) async {
    final List<Roleplay> all = await _readAll();
    final Roleplay withId =
        roleplay.id == null ? roleplay.copyWith(id: _generateId()) : roleplay;
    all.add(withId);
    await _writeAll(all);
    return withId;
  }

  /// Update an existing roleplay by id. Returns updated item or null if not found.
  Future<Roleplay?> update(Roleplay roleplay) async {
    if (roleplay.id == null) return null;
    final List<Roleplay> all = await _readAll();
    final int idx = all.indexWhere((Roleplay e) => e.id == roleplay.id);
    if (idx == -1) return null;
    all[idx] = roleplay;
    await _writeAll(all);
    return roleplay;
  }

  /// Delete a roleplay by id. Returns true if deleted.
  Future<bool> delete(String id) async {
    final List<Roleplay> all = await _readAll();
    final int before = all.length;
    all.removeWhere((Roleplay e) => e.id == id);
    if (all.length == before) return false;
    return await _writeAll(all);
  }

  /// Clear all roleplays.
  Future<void> clear() async {
    await storage.remove(key: _kKey);
  }
}
