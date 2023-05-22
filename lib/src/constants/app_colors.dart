import 'package:flutter/material.dart';

class AppColors {
  // static Color? getPrimaryHue(BuildContext context) =>
  //     Theme.of(context).brightness == Brightness.dark
  //         ? null
  //         : const Color(0xffffbf00);
  static const amber = Color(0xffffbf00);
  static const primaryHue = Color(0xff2196F3);
  static const primaryTint100 = Color(0xffBBDEFB);
  static const primaryTint50 = Color(0xffE3F2FD);
  static const primaryShade600 = Color(0xff1E88E5);
  static const primaryShade900 = Color(0xff0D47A1);

  static const red = Color(0xffFF0000);
  //use for delete button
  static const mutedRed = Color(0xffFF6961);
  //* Grey
  static const grey = Color(0xff808080);

  static const grey50 = Color(0xfffafafa);
  static const grey100 = Color(0xfff5f5f5);
  static const grey150 = Color(0xff969696);
  static const grey200 = Color(0xffEEEEEE);

  static const grey250 = Color(0xffFAFAFA);
  static const grey300 = Color(0xffE0E0E0);
  // static const grey350 = Color(0xfffafafa);
  static const grey400 = Color(0xffBDBDBD);
  // static const grey450 = Color(0xfffafafa);
  static const grey500 = Color(0xff9E9E9E);
  // static const grey550 = Color(0xfffafafa);
  static const grey600 = Color(0xff757575);
  static const grey650 = Color(0xff686868);
  static const grey700 = Color(0xff616161);
  static const grey750 = Color(0xff515151);
  static const grey800 = Color(0xff424242);
  static const grey850 = Color(0xff313131);
  static const grey900 = Color(0xff212121);
  // static const grey950 = Color(0xfffafafa);

  static const appWhite = Color(0xffFFFFFF);
  static const appBlack = Color(0xff000000);

  static const facebookColor = Color(0xFF1877F2);

  static const blues = Color.fromARGB(255, 57, 94, 138);

  static Color blue(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? blues
          : const Color(0xff1d4e89);

  static const activeColor = Color(0xff418452);

  // static Color? unreadIndicatoreColor(BuildContext context) =>
  //     Theme.of(context).brightness == Brightness.dark
  //         ? primaryGrey80
  //         : primaryTint10;

//* text colors
  static Color? textBlack80(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? null
          : const Color(0xff424242);

  static Color? textBlack50(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? null
          : const Color(0xff9E9E9E);

  static Color? black80(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffEEEEEE)
          : const Color(0xff424242);
  // static const black80 = Color(0xff424242);
  static Color black60(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffBDBDBD) // const Color.fromARGB(255, 196, 196, 196)
          : const Color(0xff757575);
  static Color black50(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff9e9e9e)
          : const Color(0xff9e9e9e);
  static Color black40(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffbdbdbd)
          : const Color(0xffbdbdbd);
  static Color? black20(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff616161)
          : const Color(0xffeeeeee);
  static Color? black10(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff616161)
          : const Color(0xfff5f5f5);
  static Color black5(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xfffafafa)
          : const Color(0xfffafafa);

  static Color? transparent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0x00000000)
          : const Color(0x00000000);
  static Color transparent80(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0x70000000)
          : const Color(0x70000000);
  static Color greyTransparent20(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0x20767676)
          : const Color(0x20767676);
  static Color greyTransparent80(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0x80767676)
          : const Color(0x80767676);

  static Color? appBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff212121)
          : const Color(0xF6FFFFFF);

  static Color? containerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff424242)
          : Colors.grey[100];

  static Color? containerHolderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff0a0a0a)
          : const Color(0xffFFFFFF);

  static Color black(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffFFFFFF)
          : const Color(0xff000000);
  static Color white(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff000000)
          : const Color(0xffFFFFFF);

  static Color? headlineBoxColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff0a0a0a)
          : const Color(0xff9e9e9e);

//Colors.white.withOpacity(0.96): Color(0xF6FFFFFF)
}
