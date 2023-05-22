@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/utils/api_retry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late APIRetry apiRetry;

  setUp(() {
    apiRetry = APIRetry(delay: 5, maxDelay: 50);
  });

  group('api retry test', () {
    test('Should retry function call if it fails initially and then succeed',
        () async {
      int attempt = 0;

      Future<void> function() async {
        if (attempt == 0) {
          attempt += 1;
          throw Exception('API call failed');
        } else {
          return;
        }
      }

      expect(apiRetry.retryAPI(function: function), completes);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('Should rethrow error if function call keeps failing', () async {
      int attempt = 0;

      Future<void> function() async {
        attempt += 1;
        throw Exception('API call failed');
      }

      try {
        await apiRetry.retryAPI(function: function);
        fail('Expected apiRetry.retryAPI to throw Exception');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(attempt, equals(5));
      }
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
