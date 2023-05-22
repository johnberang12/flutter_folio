import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';
import 'package:flutter_folio/src/common_widget/confirmation_callback.dart';
import 'package:flutter_folio/src/common_widget/loading_widget.dart';
import 'package:flutter_folio/src/common_widget/responsive_center.dart';
import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/product/presentation/product/product_screen_appbar.dart';
import 'package:flutter_folio/src/features/product/presentation/product/product_screen_controller.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/product_list_screen.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_folio/src/utils/currency_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widget/primary_button.dart';
import '../../../../common_widget/responsive_two_column_layout.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/styles.dart';
import '../../../routing/app_router/app_route.dart';
import '../../domain/product.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

//this listens to the possible error caught by the controller and show the error to the user using an alert dialog
    ref.listen(productScreenControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

//this watches the state of the controller and rebuild the widget if needed
    final state = ref.watch(productScreenControllerProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ProviderScope(
              overrides: [productProvider.overrideWithValue(product)],
              child: const ProductScreenAppBar()),
          ResponsiveSliverCenter(
              child: ProviderScope(
                  overrides: [productProvider.overrideWithValue(product)],
                  child: LoadingWidget(
                      //This shows a loading indicator when the the controller is triggered
                      isLoading: state.isLoading,
                      child: const ProductDetailsWidget())))
        ],
      ),

      //adding an edit and delete buttons here for simplicity
      //these buttons are only visible if the user is the owner of the product
      bottomNavigationBar: user?.uid == product.ownerId
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  padding: const EdgeInsets.only(
                      bottom: Sizes.p32, right: 16, left: 16),
                  onPressed: () => context.pushNamed(AppRoute.addProduct.name,
                      extra: product),
                  loadingDuration: 3000,
                  buttonTitle: 'Edit product',
                ),
                PrimaryButton(
                  backgroundColor: AppColors.mutedRed,
                  padding: const EdgeInsets.only(
                      bottom: Sizes.p32, right: 16, left: 16),
                  onPressed: () => confirmationCallback(
                      context: context,
                      title: 'Confirm deletion',
                      content: 'Are you sure you want to delete this item',
                      callback: () => ref
                              .read(productScreenControllerProvider.notifier)
                              .deleteProduct(product)
                              .then((success) {
                            if (success) {
                              final toast = AppToast();
                              toast.showToast(
                                  msg: 'Product successfully deleted.');
                              context.pop();
                            }
                          })),
                  loadingDuration: 3000,
                  buttonTitle: 'Delete product',
                ),
              ],
            )
          : null,
    );
  }
}

//a simple widget that displays the product title, price and description
class ProductDetailsWidget extends ConsumerWidget {
  const ProductDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider);
    final formattedPrice =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startContent: Card(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.title, style: Styles.k18Bold(context)),
            gapH12,
            Text(formattedPrice, style: Styles.k20(context)),
          ],
        ),
      )),
      spacing: 2,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(product.description),
        ),
      ),
    );
  }
}
