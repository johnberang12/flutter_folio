import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* its only used for testing purposes
class CallbackDelay {
  int count = 0;
  Future<void> iterate() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    debugPrint("counterCall: $count");
    if (count <= 5) {
      count++;
      return iterate();
    }
    return;
  }
}

final callbackDelayProvider = Provider<CallbackDelay>((ref) => CallbackDelay());
