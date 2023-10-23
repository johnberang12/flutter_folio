import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/application/signin_service.dart';

class AppRouterListenable extends ChangeNotifier {
  AppRouterListenable({required this.ref});
  final Ref ref;

  Future<void> verifyOtpCode(
          {required String verificationId, required String otpCode}) =>
      ref
          .read(signinServiceProvider)
          .verifyOtpCode(verificationId: verificationId, otpCode: otpCode)
          .then((value) => notifyListeners());

  Future<void> signOut() => ref
      .read(accountServiceProvider)
      .logout()
      .then((value) => notifyListeners());

  Future<void> deleteAccount(String confirmation) => ref
      .read(accountServiceProvider)
      .deleteAccount(confirmation: confirmation)
      .then((value) => notifyListeners());
}

final appRouterListenableProvider =
    Provider<AppRouterListenable>((ref) => AppRouterListenable(ref: ref));
