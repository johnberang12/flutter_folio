import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

//* this class is used to retry an API call when exception was caught.

class APIRetry {
  APIRetry({int delay = 500, int maxDelay = 5000})
      : _delay = delay,
        _maxDelay = maxDelay;
  int _delay;
  final int _maxDelay;

  Future<void> retryAPI({required FutureOr<void> Function() function}) async {
    try {
      await function();
    } catch (e) {
      if (_delay <= _maxDelay) {
        await Future.delayed(Duration(milliseconds: _delay));
        _delay *= 2;
        return retryAPI(function: function);
      } else {
        _delay = 500;
        rethrow;
      }
    }
  }
}

final apiRetryProvider = Provider<APIRetry>((ref) => APIRetry());
