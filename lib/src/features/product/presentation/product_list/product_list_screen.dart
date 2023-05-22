import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_floating_action_button.dart';
import 'package:flutter_folio/src/extensions/app_navigator.dart';
import 'package:flutter_folio/src/common_widget/list_collection_builder.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/home_appbar.dart';
import 'package:flutter_folio/src/features/routing/app_router/app_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widget/app_loader.dart';
import '../../../../use_hooks/use_scroll_controller_for_animation.dart';
import '../../domain/product.dart';
import 'product_list_tile.dart';

class ProductListScreen extends HookWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 250);
    //animation controller for the bannerAd and FAB
    final hideFabController =
        useAnimationController(duration: animationDuration, initialValue: 1);
    //hight of the bannerAd
    final adBannerHeight = useState<double>(150);
    //a custom use hook to animate and hide FAB when scrolling as well as the static banner ad
    final scrollController = useScrollControllerForAnimation(hideFabController);
    useEffect(() {
      scrollController.addListener(() {
        adBannerHeight.value = hideFabController.value == 0 ? 0 : 150;
      });
      return null;
    }, []);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: animationDuration,
              height: adBannerHeight.value,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/sale_banner.png'))),
            ),
            Expanded(
                child: ProductList(
              controller: scrollController,
            ))
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
          animation: hideFabController,
          builder: (context, _) {
            return Visibility(
              visible: hideFabController.status == AnimationStatus.completed,
              replacement: const SizedBox.shrink(),
              child: AppFloatingActionButton(
                onPressed: () => context.appPushNamed(AppRoute.addProduct.name),
                loaderColor: Colors.white,
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class ProductList extends ConsumerWidget {
  const ProductList({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(productQueryProvider);
    // return const Center(child: Text('Products...'));

    return ListCollectionBuilder(
        controller: controller,
        query: query,
        itemBuilder: (product, _) => ProviderScope(
            overrides: [productProvider.overrideWithValue(product)],
            child: const ProductListTile()),
        separatorBuilder: (_, __) => const Divider(
              height: .5,
            ),
        screenTitle: "Product list screen",
        loadingBuilder: (snapshot) => AppLoader.circularProgress());
  }
}

//product provider that used to pass the product oject to the widget children to
//prevent passing thru constructor.
//this is to give the children a const keyword that improves performance because it prevents them from rebuilding when there is a changes in the product list.
final productProvider = Provider<Product>((ref) => throw UnimplementedError());
