import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_exception.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * this. can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stackTrace');
    debugPrint('printing error logs from error logger: $error');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('app exception from error_logger');
    debugPrint('$exception');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
