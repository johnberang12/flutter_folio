import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

//* unit test done
class ConnectivityService extends StateNotifier<bool> {
  ConnectivityService({
    bool value = true,
    required InternetConnectionChecker connectionChecker,
    required Connectivity connectivity,
    required AppToast appToast,
  })  : _connectionChecker = connectionChecker,
        _connectivity = connectivity,
        _appToast = appToast,
        super(value) {
    init();
  }

  final InternetConnectionChecker _connectionChecker;
  final Connectivity _connectivity;
  final AppToast _appToast;

  StreamSubscription? _subscription;

  bool get value => state;

  void init() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((event) => _checkInternetConnection());
  }

  Future<void> _checkInternetConnection() async {
    try {
      await Future.delayed(const Duration(seconds: 400));
      final result = await _connectionChecker.hasConnection;
      if (mounted) {
        state = result;
        _appToast.showToast(msg: result ? "Connected" : "Lost connection");
      }
    } catch (e) {
      if (mounted) {
        state = false;
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityServiceProvider =
    StateNotifierProvider<ConnectivityService, bool>((ref) =>
        ConnectivityService(
            appToast: ref.watch(appToastProvider),
            connectionChecker: InternetConnectionChecker(),
            connectivity: Connectivity()));
