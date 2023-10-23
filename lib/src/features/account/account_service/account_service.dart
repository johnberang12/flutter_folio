import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/connection_checker.dart';
import '../../authentication/data/auth_repository.dart';

part 'account_service.g.dart';

//*unit test done
class AccountService {
  AccountService({required this.ref});
  final Ref ref;

  Future<void> logout() => ref.read(connectionCheckerProvider).checkConnection(
      function: () => ref.read(authRepositoryProvider).signOut());

  Future<void> deleteAccount({required String confirmation}) async {
    const delete = "DELETE";
    if (delete != confirmation) {
      throw StateError(
          "Wrong confirmation text. Please type DELETE if you wish to proceed.");
    }
    await ref.watch(connectionCheckerProvider).checkConnection(
        function: () => ref.read(authRepositoryProvider).deleteAccount());
  }
}

@Riverpod(keepAlive: true)
AccountService accountService(AccountServiceRef ref) =>
    AccountService(ref: ref);
