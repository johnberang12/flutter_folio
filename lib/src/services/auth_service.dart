import 'package:firebase_auth/firebase_auth.dart';

/// `AuthService` defines the contract for an authentication service in the application.
///
/// It is an abstract class, also known as an interface, which declares the required
/// authentication-related operations without implementing them.
///
/// This design provides several benefits:
/// 1. Decoupling: The rest of the application interacts with `AuthService` rather than
///    directly with a specific implementation like `AuthRepository`. This means we can
///    easily swap out `AuthRepository` with a different implementation in the future without
///    affecting the rest of the application.
///
/// 2. Testability: By programming to an interface, we can easily mock this service in our
///    tests. This allows us to write unit tests that run quickly and in isolation, without
///    requiring actual authentication.
///
/// 3. Clear contract: By declaring methods here, we ensure that any class implementing
///    `AuthService` will provide these methods, creating a clear contract for what our
///    authentication service is expected to do.
///
/// Note: The actual Firebase-related logic is implemented in classes that implement `AuthService`.
abstract class AuthService {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  });

  Future<void> verifyOtpCode({
    required String otpCode,
    required String verificationId,
  });

  Future<void> signOut();

  Future<void>? deleteAccount();
}
