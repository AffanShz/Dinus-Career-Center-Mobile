import 'package:flutter/foundation.dart';

/// Debug-only logger.
///
/// Output is emitted **only** in debug builds (`kDebugMode`). In release and
/// profile builds the call is a no-op, so sensitive data (emails, tokens, user
/// IDs, file contents) never leaks to production logcat.
///
/// Use this instead of `print`/`debugPrint`. Note that a bare `debugPrint`
/// still writes to the system log in release mode, which is exactly the leak
/// this helper prevents.
void appLog(Object? message) {
  if (kDebugMode) {
    debugPrint(message?.toString());
  }
}
