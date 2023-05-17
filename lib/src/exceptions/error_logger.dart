import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * this. can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stackTrace');
    debugPrint('printing error logs from error logger: $error');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
