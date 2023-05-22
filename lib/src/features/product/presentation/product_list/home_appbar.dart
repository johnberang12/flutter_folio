import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widget/alert_dialogs.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/styles.dart';
import '../../../product_search/product_search_screen.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.black80(context),
      bottom: PreferredSize(
          preferredSize: preferredSize,
          child: const Divider(
            height: 0.5,
            thickness: 1,
          )),
      title: const PropsSearchBar(),
      actions: [
        IconButton(
            onPressed: () => showUnimplementedAlertDialog(context: context),
            icon: const Icon(Icons.notifications_active))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      // isHomeScreen ? size :
      kToolbarHeight);
}

class PropsSearchBar extends ConsumerWidget {
  const PropsSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: () =>
          showSearch(context: context, delegate: ProductSearchScreen(ref: ref)),
      child: Container(
        height: 35 * textScaleFactor,
        decoration: BoxDecoration(
            // color: Colors.amber,
            border: Border.all(width: 0.5, color: AppColors.grey500),
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: Text(
                      'What are you looking for?',
                      style: Styles.k16(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  color: AppColors.primaryHue,
                  borderRadius: BorderRadius.circular(24)),
              child: Center(
                child: Text(
                  'Search',
                  style: Styles.k16Bold(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
