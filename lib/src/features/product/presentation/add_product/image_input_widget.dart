import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widget/image_editing_controller.dart';
import '../../../../constants/styles.dart';
import '../../../camera/presentation/image_input_field.dart';
import '../../domain/product.dart';
import 'add_product_screen_validator.dart';
import 'camera_icon_button.dart';

class ImageInputWidget extends ConsumerStatefulWidget {
  const ImageInputWidget({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImageInputWidgetState();
}

class _ImageInputWidgetState extends ConsumerState<ImageInputWidget>
    with AddProductScreenValidator {
  final double _imageSize = 70;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final product = widget.product;
      if (product != null) {
        //adds the product photos to the networkControllerProvider
        ref.read(networkControllerProvider.notifier).addAll(product.photos);
        //removes duplicate images just incase this initState was reinitialized and another set of product photos was added thereby adding duplicates in the list
        ref.read(networkControllerProvider.notifier).removeDuplicates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileController = ref.watch(fileControllerProvider.notifier);
    final networkController = ref.watch(networkControllerProvider.notifier);
    //the value of the file and network image controller
    //this is important to be watched to rebuild the UI when needed
    final fileValue = ref.watch(fileControllerProvider).toSet().toList();
    final networkValue = ref.watch(networkControllerProvider).toSet().toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageInputField(
          imageHeight: _imageSize,
          imageWidth: _imageSize,
          fileController: fileController,
          fileValue: fileValue,
          networkController: networkController,
          networkValue: networkValue,
          child: CameraIconButton(
              height: _imageSize,
              width: _imageSize,
              fileController: fileController,
              networkController: networkController),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            imageErrorText(fileValue.length + networkValue.length) ?? '',
            style: Styles.k12(context)
                .copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}

final fileControllerProvider =
    StateNotifierProvider.autoDispose<ImageEditingController<File>, List<File>>(
        (ref) => ImageEditingController<File>());
final networkControllerProvider = StateNotifierProvider.autoDispose<
    ImageEditingController<String>,
    List<String>>((ref) => ImageEditingController<String>());
