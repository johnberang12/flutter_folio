// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
part 'signin_service.g.dart';

//* this service class is used to perform additional logic needed before or after calling an api
//*unit test done
class SigninService {
  SigninService({
    required this.ref,
  });

  final Ref ref;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String?, int?) codeSent,
    required void Function(FirebaseAuthException) verificationFailed,
  }) =>
      ref.watch(connectionCheckerProvider).checkConnection(
          withRetry: false,
          function: () => ref
                  .read(authRepositoryProvider)
                  .verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    codeSent: codeSent,
                    codeAutoRetrievalTimeout: (verificationId) {},
                    verificationFailed: verificationFailed,
                  )
                  .onError((error, stackTrace) async {
                debugPrint('verifyPhoneNumber onError: $error');
                throw (error!);
              }).catchError((error) {
                debugPrint('verifyPhoneNumber catchError: $error');
                throw (error);
              }));

  Future<void> verifyOtpCode(
          {required String otpCode, required String verificationId}) =>
      ref.watch(connectionCheckerProvider).checkConnection(
          function: () => ref
              .read(authRepositoryProvider)
              .verifyOtpCode(otpCode: otpCode, verificationId: verificationId));
}

@Riverpod(keepAlive: true)
SigninService signinService(SigninServiceRef ref) => SigninService(ref: ref);
