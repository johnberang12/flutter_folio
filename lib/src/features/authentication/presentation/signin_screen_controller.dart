import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_folio/src/features/routing/app_router/app_router_listenable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/signin_service.dart';

part 'signin_screen_controller.g.dart';

//* this controller is designed to set the state of the UI while performing an api call
// whether to set to loading, data or error.
//* these controllers depends only from a repository class or service class
//*unit test done
@riverpod
class SigninScreenController extends _$SigninScreenController {
  @override
  FutureOr<void> build() {
    //*used to initialize async operation
    //nothing to do
  }

  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String?, int?) codeSent,
    required void Function(FirebaseAuthException) verificationFailed,
  }) async {
    //* same principle as below
    state = const AsyncLoading();
    // //*fake delay
    // await Future.delayed(const Duration(milliseconds: 300));
    print('calling verify in controller...');
    state = await AsyncValue.guard(() => ref
        .read(signinServiceProvider)
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            codeSent: codeSent,
            verificationFailed: verificationFailed));

    //*returns boolean
    return state.hasError == false;
  }

  Future<bool> verifyOtpCode(
      {required String otpCode, required String verificationId}) async {
    //* it initially set the UI to loading
    state = const AsyncLoading();
    print('calling verify in controller...otp');
    //* perform api call and save its result to a variable
    //* the .guard() method is used to catch possible error/exceptions
    final newState = await AsyncValue.guard(() => ref
        .read(appRouterListenableProvider)
        .verifyOtpCode(otpCode: otpCode, verificationId: verificationId));
    if (newState.hasError) {
      //only assign the state when verification failed. if not leave it as is to prevent updating the UI when screen is already unmounted
      state = newState;
    }
    return state.hasError == false;
  }
}
