import 'package:flutter/material.dart';

class LayoutListView extends StatelessWidget {
  const LayoutListView({super.key, required this.children, this.padding});
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      children: children.reversed.toList(),
    );
  }
}
