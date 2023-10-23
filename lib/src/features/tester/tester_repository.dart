import 'package:riverpod_annotation/riverpod_annotation.dart';

// @Riverpod(keepAlive: true)
// class TesterRepository extends _$TesterRepository {
//   @override
//   build() {}

// }

class TesterRepository {
  Future<void> doSomethingRepo() async {}
}

final testerRepositoryProvider =
    Provider<TesterRepository>((ref) => TesterRepository());
