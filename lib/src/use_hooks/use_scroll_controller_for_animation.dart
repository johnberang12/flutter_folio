import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

//custom use hook used for animating widget when scrolling
ScrollController useScrollControllerForAnimation(
        AnimationController animationController) =>
    use(_ScrollControllerHook(animationController: animationController));

class _ScrollControllerHook extends Hook<ScrollController> {
  const _ScrollControllerHook({
    required this.animationController,
  });
  final AnimationController animationController;

  @override
  _ScrollControllerHookState createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ScrollController, _ScrollControllerHook> {
  late ScrollController _scrollController;
  @override
  void initHook() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          hook.animationController.forward();
          break;

        case ScrollDirection.reverse:
          hook.animationController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  ScrollController build(BuildContext context) => _scrollController;

  @override
  void dispose() => _scrollController.dispose();
}
