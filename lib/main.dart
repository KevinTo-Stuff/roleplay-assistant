// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:roleplay_assistant/src/core/app_initializer.dart';
import 'package:roleplay_assistant/src/core/application.dart';

void main() {
  final AppInitializer appInitializer = AppInitializer();

  // Route Flutter framework errors to the default console reporter. This
  // ensures uncaught Flutter errors are visible during development and
  // are forwarded to the zone's error handler in release builds.
  FlutterError.onError = (FlutterErrorDetails details) {
    // Dump to console (works in dev and is visible in most CI logs).
    FlutterError.dumpErrorToConsole(details);
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await appInitializer.preAppRun();

      runApp(Application());

      await appInitializer.postAppRun();
    },
    (Object error, StackTrace stack) {
      // Prefer `log` from `dart:developer` so errors appear in DevTools.
      try {
        log(error.toString(), error: error, stackTrace: stack);
      } catch (_) {
        // Fallback to print if logging fails for any reason.
        // ignore: avoid_print
        print('Unhandled error: $error\n$stack');
      }
    },
  );
}
