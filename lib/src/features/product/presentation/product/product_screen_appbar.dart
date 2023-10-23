import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';
import 'package:flutter_folio/src/common_widget/custom_image.dart';
import 'package:flutter_folio/src/extensions/app_navigator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widget/dot_length_indicator.dart';
import '../../../../services/connectivity_service.dart';
import '../../../routing/app_router/app_route.dart';
import '../../domain/product.dart';
import '../product_list/product_list_screen.dart';

class ProductScreenAppBar extends StatelessWidget {
  const ProductScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      // foregroundColor: foregroundColor,
      leadingWidth: 100,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new_outlined)),
          IconButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(
                Icons.home_outlined,
                size: 30,
              )),
        ],
      ),

      pinned: true,
      stretch: true,
      expandedHeight: 330,
      flexibleSpace: const FlexibleSpaceBar(background: AppBarPhotoGallery()),
    );
  }
}

class AppBarPhotoGallery extends ConsumerStatefulWidget {
  const AppBarPhotoGallery({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppBarPhotoGalleryState();
}

class _AppBarPhotoGalleryState extends ConsumerState<AppBarPhotoGallery> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider);
    final screenWith = MediaQuery.of(context).size.width;
    final photos = product.photos;
    final connection = ref.watch(connectivityServiceProvider);
    return Stack(
      children: [
        SizedBox(
          width: screenWith,
          child: CarouselSlider.builder(
            itemCount: photos.length,
            itemBuilder: ((context, index, realIndex) {
              final imageUrl = photos[index];
              return _buildImage(imageUrl, index, connection, product);
            }),
            options: CarouselOptions(
              aspectRatio: 01,
              height: double.infinity,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 32,
            child: _imageIndecator(product),
          ),
        )
      ],
    );
  }

  Widget _buildImage(
      String imageUrl, int index, bool connection, Product product) {
    return InkWell(
        onTap: () => connection
            ? context.appPushNamed(AppRoute.photoGallery.name,
                extra: product.photos)
            : ref
                .read(appToastProvider)
                .showToast(msg: "Check internet connection"),
        child: CustomImage(
          clipRRect: 0,
          imageUrl: product.photos[index],
          width: double.infinity,
        ));
  }

  Widget _imageIndecator(Product product) => DotLengthIndicator(
      pageIndex: currentIndex, length: product.photos.length);
}
