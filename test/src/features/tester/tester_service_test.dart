import 'package:flutter_folio/src/features/tester/tester_repository.dart';
import 'package:flutter_folio/src/features/tester/tester_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockTesterRepository repository) {
    final container = ProviderContainer(overrides: [
      testerRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
    return container;
  }

  group('TesterService', () {
    test('doSomething calls doSomethingRepo', () async {
      final repository = MockTesterRepository();

      final container = makeProviderContainer(repository);

      when(() => repository.doSomethingRepo())
          .thenAnswer((_) => Future.value());

      await container
          .read(testerServiceProvider.notifier)
          .doSomethingService()
          .then((value) => null);

      verify(() => repository.doSomethingRepo()).called(1);
    });
  });
}
