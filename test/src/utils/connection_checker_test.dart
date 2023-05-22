@Timeout(Duration(milliseconds: 500))
import 'dart:async';
import 'package:flutter_folio/src/utils/api_retry.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks.dart';

void main() {
  late APIRetry apiRetry;

  setUp(() {
    apiRetry = MockAPIRetry();
  });

  group('connection checker test', () {
    test('Should execute function if there is a connection', () async {
      final connectionChecker = ConnectionChecker(
          retry: apiRetry, connection: true, delay: 5, maxDelay: 50);
      int attempt = 0;

      Future<void> function() async {
        attempt += 1;
        return Future.value();
      }

      when(() => apiRetry.retryAPI(function: any(named: 'function')))
          .thenAnswer((realInvocation) async {
        var capturedFunction = realInvocation.namedArguments.values.single
            as FutureOr<void> Function();
        await capturedFunction();
      });

      await connectionChecker.checkConnection(function: function);
      expect(attempt, equals(1));
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('Should use retry if withRetry is set to true', () async {
      final connectionChecker = ConnectionChecker(
          retry: apiRetry, connection: true, delay: 5, maxDelay: 50);
      Future<void> function() async {}

      when(() => apiRetry.retryAPI(function: function))
          .thenAnswer((_) => Future.value());

      await connectionChecker.checkConnection(function: function);

      verify(() => apiRetry.retryAPI(function: function)).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('Should retry until max delay if there is no connection', () async {
      final connectionChecker = ConnectionChecker(
          retry: apiRetry, connection: false, delay: 5, maxDelay: 50);

      int attempt = 0;
      int failed = 0;

      Future<void> function() async {
        attempt += 1;
      }

      Future<void> failedConnection() async {
        failed += 1;
      }

      try {
        await connectionChecker.checkConnection(
            failedConnection: failedConnection,
            function: function,
            withRetry: false);
        fail('Expected checkConnection to throw an Exception');
      } on StateError catch (e) {
        expect(
            e.message,
            equals(
                'No internet connection found. Please check your connection and try again.'));
        expect(attempt, equals(0));
        expect(failed, 5);
      }
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
