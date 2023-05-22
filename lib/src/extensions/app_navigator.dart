import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/single_tap_handler.dart';
import 'package:go_router/go_router.dart';

//this creates an app's version of go_router's pushNamed to add a
// functionality toe disabled the the callback for 2 seconds to prevent pushing
//2 or more pages in the stack incase the user tapped multiple times the button.
extension AppNavigator on BuildContext {
  Future<T?> appPushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      SingleTapHandler.tap(
          onTap: () => GoRouter.of(this).pushNamed(
                name,
                pathParameters: pathParameters,
                queryParameters: queryParameters,
                extra: extra,
              ));

  /// Navigate to a location.
  void appGo(String location, {Object? extra}) => SingleTapHandler.tap(
      onTap: () => GoRouter.of(this).go(location, extra: extra));

  /// Navigate to a named route.
  void appGoNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      SingleTapHandler.tap(
          onTap: () => GoRouter.of(this).goNamed(
                name,
                pathParameters: pathParameters,
                queryParameters: queryParameters,
                extra: extra,
              ));

  /// Push a location onto the page stack.
  ///
  /// See also:
  /// * [pushReplacement] which replaces the top-most page of the page stack and
  ///   always uses a new page key.
  /// * [replace] which replaces the top-most page of the page stack but treats
  ///   it as the same page. The page key will be reused. This will preserve the
  ///   state and not run any page animation.
  Future<T?> appPush<T extends Object?>(String location, {Object? extra}) =>
      SingleTapHandler.tap(
          onTap: () => GoRouter.of(this).push<T>(location, extra: extra));
}
