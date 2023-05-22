import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Custom image widget that loads an image as a static asset.
class CustomImage extends StatefulWidget {
  const CustomImage({
    super.key,
    this.imageUrl,
    required this.clipRRect,
    this.emptyFillColor,
    this.height,
    this.width,
    this.onTap,
    this.fit,
    this.showLoading = true,
    this.opacity = 1.0,
  });
  final String? imageUrl;
  final double clipRRect;
  final Color? emptyFillColor;
  final double? height;
  final double? width;
  final void Function()? onTap;
  final BoxFit? fit;
  final bool showLoading;
  final double opacity;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  @override
  Widget build(BuildContext context) {
    // const imageHeight = 200.0;
    const imageWidth = 300.0;
    // final screenWith = MediaQuery.of(context).size.width;

    // bool valid =
    //     widget.imageUrl != null && widget.imageUrl!.contains('https://');

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.clipRRect),
        child: Opacity(
          opacity: widget.opacity,
          child: CachedNetworkImage(
            // i use SizedBox as a placeholder for siplicity but can use custom shimmer depending on app requirement.
            placeholder: ((context, url) => const SizedBox()),
            imageUrl: widget.imageUrl!,
            fit: widget.fit ?? BoxFit.cover,
            height: widget.height,
            width: widget.width,
            errorWidget: ((context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.clipRRect),
                    color: widget.emptyFillColor ?? AppColors.black20(context),
                  ),
                  height: widget.height,
                  child: const Center(
                      child: Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                  )),
                )),
          ),
        ),
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.clipRRect),
          color: widget.emptyFillColor ?? AppColors.black20(context),
        ),
        height: widget.height ?? imageWidth,
        width: widget.width ?? imageWidth,
        child: const Center(
            child: Text(
          'Something went wrong',
          textAlign: TextAlign.center,
        )),
      );
    }
  }
}
