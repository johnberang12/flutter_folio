// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/app_user/domain/app_user.dart';
import '../features/authentication/data/auth_repository.dart';

part 'owner_verifier.g.dart';

//*unit test done
class OwnerVerifier {
  OwnerVerifier({
    required this.userId,
  });
  final UserID? userId;

  //this function is used to verify that the user trying to edit/delete any document in the database is the owner, otherwise it throws an error.

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

@Riverpod(keepAlive: true)
OwnerVerifier ownerVerifier(OwnerVerifierRef ref) =>
    OwnerVerifier(userId: ref.watch(authRepositoryProvider).currentUser?.uid);
