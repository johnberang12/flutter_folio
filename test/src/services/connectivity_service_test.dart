@Timeout(Duration(milliseconds: 500))

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('ConnectivityService', () {
    // late ConnectivityService connectivityService;
    late MockConnectivity mockConnectivity;
    late MockInternetConnectionChecker mockConnectionChecker;
    late StreamController<ConnectivityResult> streamController;
    // late AppToast appToast;

    setUp(() {
      mockConnectivity = MockConnectivity();
      mockConnectionChecker = MockInternetConnectionChecker();
      streamController = StreamController<ConnectivityResult>();
      // appToast = MockAppToast();

      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => streamController.stream);

      // connectivityService = ConnectivityService(
      //     connectionChecker: mockConnectionChecker,
      //     connectivity: mockConnectivity,
      //     appToast: appToast);
    });

    tearDown(() {
      streamController.close();
    });

    test('sets state to true when connected to the internet', () async {
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      streamController.add(ConnectivityResult.wifi);
      await Future.delayed(
          const Duration(milliseconds: 600)); // Allow time for state to be set

      expect(await mockConnectionChecker.hasConnection, true);
    }, timeout: const Timeout(Duration(milliseconds: 700)));

    test('sets state to false when disconnected from the internet', () async {
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      streamController.add(ConnectivityResult.none);
      await Future.delayed(
          const Duration(milliseconds: 600)); // Allow time for state to be set

      expect(await mockConnectionChecker.hasConnection, false);
    }, timeout: const Timeout(Duration(milliseconds: 700)));
  });
}
