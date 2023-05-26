import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final newState =
        await AsyncValue.guard(() => ref.read(accountServiceProvider).logout());

    if (newState.hasError) {
      //only assign the state to show error dialog in the UI if the logout fails
      state = newState;
    }
    // no need to assign the state and update the UI as the use will be redirected to the welcome screen
  }

  Future<void> deleteAccount(String confirmation) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => ref
        .read(accountServiceProvider)
        .deleteAccount(confirmation: confirmation));
    if (newState.hasError) {
      state = newState;
    }
  }
}
