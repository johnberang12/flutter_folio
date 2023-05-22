// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_folio/src/features/app_user/domain/app_user.dart';
import 'package:flutter_folio/src/utils/owner_verifier.dart';

class FakeOwnerVerifier extends Fake implements OwnerVerifier {
  FakeOwnerVerifier({
    this.userId,
  });
  @override
  final UserID? userId;

  @override
  Future<void> verifyOwner(
      {required Future<void> Function() function,
      required UserID ownerId}) async {
    if (ownerId == userId) {
      await function();
    } else {
      throw StateError("You are not authorize to make this operation.");
    }
  }
}
