import 'dart:async';

import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class FakeConnectionChecker extends Fake implements ConnectionChecker {
  FakeConnectionChecker({required this.connection});

  @override
  final bool connection;

  // Implement the methods that are to be faked here.
  // Note: For testing purposed this this to call the passed function if connection is true and throw stateError otherwise

  @override
  Future<void> checkConnection(
      {required FutureOr<void> Function() function,
      void Function()? failedConnection,
      bool withRetry = false}) async {
    if (connection) {
      if (withRetry) {
        await retry.retryAPI(function: function);
      } else {
        await function();
      }
    } else {
      throw StateError(
          'No internet connection found. Please check your connection and try again.');
    }
  }
}

  // Implement other methods from ConnectionChecker here.

