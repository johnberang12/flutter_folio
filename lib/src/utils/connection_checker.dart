// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_folio/src/services/connectivity_service.dart';
import 'package:flutter_folio/src/utils/api_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* this class is used to check user's internet connection before calling an api
//* it tries to retry fetching internet connection 5 times before it finally delares that the user has no internet connection
class ConnectionChecker {
  ConnectionChecker({
    required this.retry,
    required this.connection,
    int delay = 500,
    int maxDelay = 5000,
  })  : _delay = delay,
        _maxDelay = maxDelay;

  final APIRetry retry;
  final bool connection;

  int _delay;
  final int _maxDelay;

  Future<void> checkConnection(
      {required FutureOr<void> Function() function,
      Future<void> Function()? failedConnection,
      bool withRetry = true}) async {
    if (connection) {
      if (withRetry) {
        await retry.retryAPI(function: function);
      } else {
        await function();
      }
    } else {
      if (_delay <= _maxDelay) {
        await Future.delayed(Duration(milliseconds: _delay));
        _delay *= 2;
        if (failedConnection != null) {
          await failedConnection();
        }
        return checkConnection(
            function: function, failedConnection: failedConnection);
      } else {
        if (failedConnection != null) {
          await failedConnection();
        }
        _delay = 500;
        throw StateError(
            'No internet connection found. Please check your connection and try again.');
      }
    }
  }
}

final connectionCheckerProvider = Provider<ConnectionChecker>((ref) =>
    ConnectionChecker(
        retry: ref.watch(apiRetryProvider),
        connection: ref.watch(connectivityServiceProvider)));
