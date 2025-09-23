// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/app_initializer.dart';
import 'package:roleplay_assistant/src/core/application.dart';

void main() {
  final AppInitializer appInitializer = AppInitializer();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await appInitializer.preAppRun();

      runApp(Application());

      appInitializer.postAppRun();
    },
    (Object error, StackTrace stack) {},
  );
}
