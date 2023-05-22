import 'package:flutter/material.dart';

import '../constants/sizes.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {Key? key,
      this.thumbnail,
      this.title,
      this.location,
      this.price,
      this.trailing1,
      this.trailing2,
      this.expansionTile,
      this.onTap,
      this.tileHeight = 0.15,
      this.boost,
      this.tileColor})
      : super(key: key);

  final Widget? thumbnail;
  final Widget? title;
  final Widget? location;
  final Widget? price;

  final List<Widget>? trailing1;
  final List<Widget>? trailing2;
  final ExpansionTile? expansionTile;
  final VoidCallback? onTap;
  final Color? tileColor;
  final Widget? boost;
  final double tileHeight;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textFactor = MediaQuery.of(context).textScaleFactor;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * textFactor * tileHeight,
        width: size.width,
        color: tileColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .02, vertical: size.height * 0.012),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: thumbnail ?? const SizedBox(),
              ),
              gapW12,
              Expanded(
                flex: 5,
                child: _ProductDescription(
                  title: title,
                  subTitle: location,
                  price: price,
                  boost: boost,
                  trailing1: trailing1,
                  trailing2: trailing2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription(
      {Key? key,
      this.title,
      this.subTitle,
      this.price,
      this.boost,
      this.trailing1,
      this.trailing2})
      : super(key: key);

  final Widget? title;
  final Widget? subTitle;
  final Widget? price;

  final Widget? boost;
  final List<Widget>? trailing1;
  final List<Widget>? trailing2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title ?? const SizedBox(),
            gapH4,
            subTitle ?? const SizedBox(),
            gapH4,
            price ?? const SizedBox(),
            gapH4,
            if (boost != null) ...[
              boost!,
            ]
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: trailing1 ?? const [],
              ),
              gapW8,
              Row(
                children: trailing2 ?? const [],
              )
            ],
          ),
        ),
      ],
    );
  }
}
