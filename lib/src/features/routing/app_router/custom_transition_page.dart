import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// This function builds a page with a default transition
// It uses the CustomDataTransitionPage class
CustomDataTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context, // Context of the widget calling this function
  required GoRouterState
      state, // State of the current route, passed from GoRouter
  required Widget child, // Widget which will be displayed with the transition
  Duration duration = const Duration(
      milliseconds: 250), // Duration for the transition. Defaults to 250ms
  Curve curve = Curves.easeOut, // Animation curve. Defaults to easeOut
  T? data, // Optional data that can be passed to the transition
}) {
  return CustomDataTransitionPage<T>(
    key: state.pageKey, // Key for the page
    data: data, // Data passed to the transition
    child: child, // The child widget
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // This is where the transition is built
      // A Tween is created which starts from 0 and ends at 1
      // The tween is then chained to a CurveTween to apply the curve to the animation
      var tween =
          Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));

      // The animation is driven by the tween
      var animationTween = tween.animate(animation);

      // The FadeTransition widget uses the animationTween for its opacity
      // This causes the child to fade in/out
      return FadeTransition(opacity: animationTween, child: child);
    },
    transitionDuration: duration, // The duration of the transition
  );
}

// This class is a Custom Page which uses a Transition and can carry data
class CustomDataTransitionPage<T> extends CustomTransitionPage<T> {
  final T? data; // Optional data that can be carried by the page

  const CustomDataTransitionPage({
    Key? key, // Key for the widget
    this.data, // Data to be carried by the page
    required Widget child, // The child widget
    required RouteTransitionsBuilder
        transitionsBuilder, // Function which builds the transitions
    Duration transitionDuration = const Duration(
        milliseconds: 250), // Duration of the transition. Defaults to 250ms
  }) : super(
          child: child, // The child widget
          transitionsBuilder:
              transitionsBuilder, // Function which builds the transitions
          transitionDuration:
              transitionDuration, // The duration of the transition
        );
}
