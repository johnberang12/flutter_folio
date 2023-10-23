import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeRef<T> extends Ref<T> {
  @override
  ProviderContainer get container => throw UnimplementedError();

  @override
  void invalidate(ProviderOrFamily provider) {}

  @override
  void invalidateSelf() {}

  @override
  // ignore: avoid_shadowing_type_parameters
  ProviderSubscription<T> listen<T>(AlwaysAliveProviderListenable<T> provider,
      void Function(T? previous, T next) listener,
      {void Function(Object error, StackTrace stackTrace)? onError,
      bool? fireImmediately}) {
    throw UnimplementedError();
  }

  @override
  void listenSelf(void Function(T? previous, T next) listener,
      {void Function(Object error, StackTrace stackTrace)? onError}) {}

  @override
  void onAddListener(void Function() cb) {}

  @override
  void onCancel(void Function() cb) {}

  @override
  void onDispose(void Function() cb) {}

  @override
  void onRemoveListener(void Function() cb) {}

  @override
  void onResume(void Function() cb) {}

  @override
  // ignore: avoid_shadowing_type_parameters
  T read<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  // ignore: avoid_shadowing_type_parameters
  T refresh<T>(Refreshable<T> provider) {
    throw UnimplementedError();
  }

  @override
  // ignore: avoid_shadowing_type_parameters
  T watch<T>(AlwaysAliveProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  bool exists(ProviderBase<Object?> provider) {
    //nothing to do
    throw UnimplementedError();
  }

  @override
  void notifyListeners() {
    //nothing to do
  }
}
