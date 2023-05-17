import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomDataTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 250),
  Curve curve = Curves.easeOut,
  T? data,
}) {
  return CustomDataTransitionPage<T>(
    key: state.pageKey,
    data: data,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween =
          Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
      var animationTween = tween.animate(animation);
      return FadeTransition(opacity: animationTween, child: child);
    },
    transitionDuration: duration,
  );
}

class CustomDataTransitionPage<T> extends CustomTransitionPage<T> {
  final T? data;

  const CustomDataTransitionPage({
    Key? key,
    this.data,
    required Widget child,
    required RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 250),
  }) : super(
          child: child,
          transitionsBuilder: transitionsBuilder,
          transitionDuration: transitionDuration,
        );
}
