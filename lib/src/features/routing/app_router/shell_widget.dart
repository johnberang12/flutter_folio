import 'package:flutter/material.dart';
import 'package:flutter_folio/src/services/connectivity_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widget/responsive_center.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

//* this widget is the mother scaffold of the app
//* this is used to show that the user has no internet connection
//* it is also can be use to show any widget in the future that can be visible in anywhere in the app if needed
class ShellWidget extends ConsumerWidget {
  const ShellWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectivityServiceProvider);
    final topPad = MediaQuery.paddingOf(context).top;
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
