import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DotLengthIndicator extends StatelessWidget {
  const DotLengthIndicator(
      {Key? key,
      required this.pageIndex,
      required this.length,
      this.dotSize = 6,
      this.dotSizeActive = 10,
      this.padding = const EdgeInsets.only(right: 4),
      this.indicatorColor = AppColors.primaryHue})
      : super(key: key);
  final int pageIndex;
  final int length;
  final double dotSize;
  final double dotSizeActive;
  final EdgeInsets padding;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
            length,
            (index) => Padding(
                  padding: padding,
                  child: DotIndicator(
                    isActive: index == pageIndex,
                    dotSize: dotSize,
                    dotSizeActive: dotSizeActive,
                    indicatorColor: indicatorColor,
                  ),
                )),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator(
      {Key? key,
      required this.isActive,
      this.dotSize = 6,
      this.dotSizeActive = 10,
      this.indicatorColor = AppColors.primaryHue})
      : super(key: key);
  final bool isActive;
  final double dotSize;
  final double dotSizeActive;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: isActive ? dotSizeActive : dotSize,
      width: isActive ? dotSizeActive : dotSize,
      decoration: BoxDecoration(
          color: isActive ? indicatorColor : indicatorColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
