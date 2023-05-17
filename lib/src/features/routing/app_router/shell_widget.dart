import 'package:flutter/material.dart';

import '../../../common_widget/responsive_center.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ShellWidget extends StatelessWidget {
  const ShellWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const connection = true;
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ResponsiveCenter(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            child,
            if (!connection) ...[
              Container(
                width: double.infinity,
                height: kToolbarHeight + topPad,
                color: AppColors.black80(context),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: Sizes.p28),
                  child: Text(
                    'lost connection',
                    style:
                        Styles.k14Bold(context).copyWith(color: AppColors.red),
                  ),
                )),
              )
            ]
          ],
        ),
      ),
    );
  }
}
