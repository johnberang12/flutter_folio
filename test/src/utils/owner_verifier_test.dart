@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/utils/owner_verifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OwnerVirifier class test', () {
    test('verifyOwner should execute function if ownerId equals userId',
        () async {
      const userId = 'user1';
      final verifier = OwnerVerifier(userId: userId);
      bool functionCalled = false;
      await verifier.verifyOwner(
        ownerId: userId,
        function: () async {
          functionCalled = true;
        },
      );
      expect(functionCalled, isTrue);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('verifyOwner should throw StateError if ownerId does not equal userId',
        () async {
      const userId = 'user1';
      const differentUserId = 'user2';
      final verifier = OwnerVerifier(userId: userId);
      bool functionCalled = false;
      await expectLater(
        () async {
          await verifier.verifyOwner(
            ownerId: differentUserId,
            function: () async {
              functionCalled = true;
            },
          );
        },
        throwsA(isA<StateError>()),
      );
      expect(functionCalled, isFalse);
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
