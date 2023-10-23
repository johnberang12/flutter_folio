import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tester_repository.dart';

part 'tester_service.g.dart';

@Riverpod(keepAlive: true)
class TesterService extends _$TesterService {
  @override
  build() {}

  Future<void> doSomethingService() async {
    await ref.read(testerRepositoryProvider).doSomethingRepo();
  }
}
