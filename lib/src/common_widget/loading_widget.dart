import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_loader.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.child, this.isLoading = false})
      : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.5 : 1.0,
          child: child,
        ),
        isLoading ? AppLoader.circularProgress() : const SizedBox()
      ],
    );
  }
}
