import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_widget_robot.dart';

void main() {
  testWidgets('app floating action button should work correctly',
      (tester) async {
    bool isPressed = false;
    void onPressed() {
      isPressed = true;
    }

    final r = ComWidRobot(tester);
    await r.pumpAppFloatingActionButton(onPressed: onPressed);
    r.expectAppFloatingActionButton();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(isPressed, true);
  });
}
