// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_floating_action_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ComWidRobot {
  ComWidRobot(
    this.tester,
  );
  final WidgetTester tester;

  Future<void> pumpAppFloatingActionButton(
      {required void Function() onPressed}) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: AppFloatingActionButton(onPressed: onPressed),
        ),
      ),
    ));
  }

  void expectAppFloatingActionButton() {
    final appFAB = find.byType(AppFloatingActionButton);
    expect(appFAB, findsOneWidget);
  }
}
