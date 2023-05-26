import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/custom_image.dart';
import 'package:flutter_folio/src/common_widget/custom_list_tile.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/product_list_screen.dart';
import 'package:flutter_folio/src/utils/currency_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/styles.dart';
import '../../../routing/app_router/app_route.dart';

const kProductTileKey = Key('product-list-tile-key');

class ProductListTile extends ConsumerWidget {
  const ProductListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider);
    final price = ref.watch(currencyFormatterProvider).format(product.price);
    return CustomListTile(
      productTileKey: kProductTileKey,
      onTap: () => context.pushNamed(AppRoute.product.name, extra: product),
      thumbnail: CustomImage(
        clipRRect: 12,
        height: double.infinity,
        width: double.infinity,
        imageUrl: product.photos.first,
      ),
      title: Text(product.title, style: Styles.k18Bold(context)),
      price: Text(price, style: Styles.k20(context)),
      trailing1: [
        Icon(Icons.messenger_outline,
            size: Sizes.p18, color: AppColors.black60(context))
      ],
      trailing2: [
        Icon(Icons.favorite_border_outlined,
            size: Sizes.p18, color: AppColors.black60(context))
      ],
    );
  }
}
