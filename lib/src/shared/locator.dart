// Package imports:
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/routing/app_router.dart';
import 'package:roleplay_assistant/src/shared/services/roleplay/roleplay_storage.dart';
import 'package:roleplay_assistant/src/shared/services/storage/local_storage.dart';
import 'package:roleplay_assistant/src/shared/services/storage/storage.dart';

final GetIt locator = GetIt.instance
  ..registerLazySingleton(() => AppRouter())
  ..registerLazySingleton<Storage>(() => LocalStorage())
  // Register RoleplayStorage after Storage so it can be resolved with the concrete Storage implementation
  ..registerLazySingleton<RoleplayStorage>(
      () => RoleplayStorage(storage: GetIt.instance<Storage>()),);
