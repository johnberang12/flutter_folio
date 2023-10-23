import 'package:flutter_folio/src/exceptions/async_error_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Creates the top-level [ProviderContainer] by overriding providers with fake
/// repositories only. This is useful for testing purposes and for running the
/// app with a "fake" backend.
///
/// Note: all repositories needed by the app can be accessed via providers.
/// Some of these providers throw an [UnimplementedError] by default.
///
/// Example:
/// ```dart
/// @Riverpod(keepAlive: true)
/// LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
///   throw UnimplementedError();
/// }
/// ```
///
/// As a result, this method does two things:
/// - create and configure the repositories as desired
/// - override the default implementations with a list of "overrides"
Future<ProviderContainer> createFirebaseProviderContainer(
    {bool addDelay = true}) async {
//exmple:
  // final mockAuthRepository = MockAuthRepository();
  return ProviderContainer(
    overrides: [
      // repositories
      // example:
      // authRepositoryProvider.overrideWithValue(mockAuhRepository),
    ],
    observers: [AsyncErrorLogger()],
  );
}
