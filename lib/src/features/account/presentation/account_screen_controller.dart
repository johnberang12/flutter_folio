import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'delete_account_dialog_content.dart';

part 'account_screen_controller.g.dart';

//* a controller subclass generated using riverpod generator.
//* it is used to render UI state while api is being called

@riverpod
class AccountScreenController extends _$AccountScreenController {
  @override
  FutureOr<void> build() {
    //nothing to do
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => ref.read(accountServiceProvider).logout());
  }

  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    final confirmation =
        ref.read(editBottomSheetTextProvider('').notifier).state;
    state = await AsyncValue.guard(
        () => ref.read(accountServiceProvider).deleteAccount(confirmation));
  }
}
