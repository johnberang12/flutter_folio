import 'dart:async';

//a functionality that disables the tap function for 2 seconds after it has already been tapped.
//this is to prevent multiple calles when the user accidentally or intentionally
//tapped the button multiple times in a row.
class SingleTapHandler {
  static bool _isTapped = false;
  static Future<T?> tap<T extends Object?>(
      {required FutureOr<void> Function() onTap,
      Duration resetDelay = const Duration(seconds: 2)}) async {
    if (!_isTapped) {
      _isTapped = true;
      await onTap();
      await Future.delayed(resetDelay, () {
        _isTapped = false;
      });
    }
    return null;
  }
}
