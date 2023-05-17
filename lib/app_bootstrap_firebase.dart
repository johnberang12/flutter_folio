import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  //// TODO: Replace with Firebase repositories
  // final reviewsRepository = FakeReviewsRepository(addDelay: addDelay);
  // * set delay to false to make it easier to add/remove items
  // final localCartRepository = FakeLocalCartRepository(addDelay: false);
  // final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
  // final ordersRepository = FakeOrdersRepository(addDelay: addDelay);

  return ProviderContainer(
    overrides: [
      // repositories
      // reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
      // ordersRepositoryProvider.overrideWithValue(ordersRepository),
      // localCartRepositoryProvider.overrideWithValue(localCartRepository),
      // remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
    ],
    observers: [],
  );
}