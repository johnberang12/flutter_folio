// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

//*unit test done//
//the test ensures that calling each functions would correctly calles the FirebaseAuth methods
class AuthRepository extends ChangeNotifier implements AuthService {
  AuthRepository({
    required this.auth,
  });

  final FirebaseAuth auth;

  @override
  User? get currentUser => auth.currentUser;

  @override
  Stream<User?> authStateChanges() => auth.authStateChanges();

//*error handling tested
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) =>
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 120),
        verificationFailed: verificationFailed,
      );

  @override
  Future<void> verifyOtpCode({
    required String otpCode,
    required String verificationId,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    await auth
        .signInWithCredential(credential)
        .then((value) => notifyListeners());
  }

  @override
  Future<void> signOut() => auth.signOut().then((value) => notifyListeners());

  @override
  Future<void>? deleteAccount() =>
      auth.currentUser?.delete().then((value) => notifyListeners());
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(auth: ref.watch(firebaseAuthProvider));

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(AuthStateChangesRef ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();
