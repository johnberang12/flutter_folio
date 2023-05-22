import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widget/custom_image.dart';
import '../../../common_widget/image_editing_controller.dart';

//a widget used to take in the imageEditingControllers and display its content
class ImageInputField extends ConsumerWidget {
  const ImageInputField(
      {super.key,
      required this.fileController,
      this.networkController,
      this.itemsGap,
      this.verticalPadding,
      this.imageHeight,
      this.imageWidth,
      required this.fileValue,
      this.networkValue,
      this.child,
      this.imageCountPadding = const EdgeInsets.all(0),
      this.onDeleteNetworkImage});
  final ImageEditingController<String>? networkController;
  final ImageEditingController<File> fileController;
  final double? itemsGap;
  final double? verticalPadding;
  final void Function(String)? onDeleteNetworkImage;
  final double? imageHeight;
  final double? imageWidth;
  //*make this required to ensure value is updated when there is a change
  final List fileValue;
  final List? networkValue;
  final Widget? child;
  final EdgeInsetsGeometry imageCountPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageCount = fileValue.length + (networkValue?.length ?? 0);
    final networkimages = networkController?.value.length;
    print('networkImage length: $networkimages');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (child != null) ...[
                child ?? const SizedBox(),
              ],
              if (networkController != null &&
                  networkController!.value.isNotEmpty) ...[
                SizedBox(
                  height: imageCount > 0 ? (imageHeight ?? 65) : 0,
                  child: ImageField.network(
                    itemsGap: itemsGap,
                    verticalPadding: verticalPadding,
                    controller: networkController!,
                    imageBuilder: (context, item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CustomImage(
                        imageUrl: item,
                        clipRRect: 6,
                        height: imageHeight ?? 65,
                        width: imageWidth ?? 65,
                      ),
                    ),
                    onNetworkImageDelete: onDeleteNetworkImage ?? (_) {},
                  ),
                )
              ],
              SizedBox(
                height: imageCount > 0 ? (imageHeight ?? 65) : 0,
                child: ImageField.file(
                  itemsGap: itemsGap,
                  verticalPadding: verticalPadding,
                  controller: fileController,
                  imageBuilder: (context, item) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: imageHeight ?? 65,
                    width: imageWidth ?? 65,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: FileImage(
                            item,
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (imageCount > 0) ...[
          Padding(
            padding: imageCountPadding,
            child: Text('$imageCount/10'),
          )
        ]
      ],
    );
  }
}

enum ImageType {
  file,
  network,
}

//a widget used to display the selected images horizontally
class ImageField extends ConsumerWidget {
  const ImageField.network({
    super.key,
    this.child,
    required this.controller,
    this.maxCount = 10,
    this.deleteBuilder,
    required this.imageBuilder,
    required this.onNetworkImageDelete,
    this.gridRows = 3,
    this.gridRowGap = 0,
    this.gridColumnGap = 0,
    this.type = ImageType.network,
    this.itemsGap,
    this.verticalPadding,
  }) : assert(onNetworkImageDelete != null,
            'onNetworkImageDelete must be null on type file.');
  const ImageField.file({
    super.key,
    this.child,
    required this.controller,
    this.maxCount = 10,
    this.deleteBuilder,
    required this.imageBuilder,
    this.onNetworkImageDelete,
    this.gridRows = 3,
    this.gridRowGap = 0,
    this.gridColumnGap = 0,
    this.type = ImageType.file,
    this.itemsGap,
    this.verticalPadding,
  }) : assert(onNetworkImageDelete == null,
            'onNetworkImageDelete must be null on type file.');

  final Widget? child;
  final ImageEditingController controller;

  final int maxCount;
  final void Function(String)? onNetworkImageDelete;
  final ItemWidgetBuilder? deleteBuilder;
  final ItemWidgetBuilder imageBuilder;
  final int gridRows;
  final double gridRowGap;
  final double gridColumnGap;
  final ImageType type;
  final double? itemsGap;
  final double? verticalPadding;

  void _onSelectNetworkImage(String url, WidgetRef ref) {
    if (ref.read(selectedNetworkImage.notifier).state == url) {
      ref.read(selectedNetworkImage.notifier).state = null;
    } else {
      ref.read(selectedNetworkImage.notifier).state = url;
    }
  }

  void _onDeleteNetworkImage(String image) {
    if (onNetworkImageDelete != null) {
      onNetworkImageDelete!(image);
    }

    controller.removeItem(image);
  }

//function used to select/deselect a picked image
  void _onSelectImageFile(File file, WidgetRef ref) {
    if (ref.read(selectedImageFile.notifier).state == file) {
      ref.read(selectedImageFile.notifier).state = null;
    } else {
      ref.read(selectedImageFile.notifier).state = file;
    }
  }

  void _onDeleteImageFile(File file) => controller.removeItem(file);

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = controller.removeAt(oldIndex);
    controller.insert(newIndex, item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //this removes duplicates images just incase some mother widgets were rebuilt causing the list to add duplicate images
    final items = controller.value.toSet().toList();
    final selectedFile = ref.watch(selectedImageFile);
    final selectedImageNetwork = ref.watch(selectedNetworkImage);
    return items.length == 1
        ? SingleImageChild(
            type: type,
            image: items.first,
            onSelectImageFile: _onSelectImageFile,
            onSelectNetworkImage: _onSelectNetworkImage,
            onDeleteImageFile: controller.removeItem,
            onDeleteNetworkImage: _onDeleteNetworkImage,
            imageBuilder: imageBuilder,
            verticalPadding: verticalPadding,
            selectedFile: selectedFile,
            selectedImageNetwork: selectedImageNetwork,
          )
        //using reorderableListview to allow users to reorder the images they took
        : ReorderableListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            onReorder: _reorder,
            children: [
                // displays the images horizontally
                for (var i = 0; i < items.length; i++)
                  type == ImageType.file
                      ? ImageTile<File>(
                          type: ImageType.file,
                          key: ValueKey(items[i]),
                          image: items[i],
                          onImageTap: () => _onSelectImageFile(items[i], ref),
                          verticalPadding: verticalPadding,
                          selectedImage: selectedFile,
                          deleteBuilder: deleteBuilder,
                          imageBuilder: imageBuilder,
                          onDelete: _onDeleteImageFile,
                        )
                      : ImageTile<String>(
                          key: ValueKey(items[i]),
                          type: ImageType.network,
                          image: items[i].toString(),
                          onImageTap: (() =>
                              _onSelectNetworkImage(items[i], ref)),
                          verticalPadding: verticalPadding,
                          selectedImage: selectedImageNetwork,
                          deleteBuilder: deleteBuilder,
                          imageBuilder: imageBuilder,
                          onDelete: _onDeleteNetworkImage)
              ]);
  }
}

//a widget used to display a single image
class SingleImageChild extends ConsumerWidget {
  const SingleImageChild({
    super.key,
    required this.type,
    required this.image,
    required this.onSelectImageFile,
    required this.onSelectNetworkImage,
    required this.onDeleteImageFile,
    required this.onDeleteNetworkImage,
    required this.imageBuilder,
    this.fileDeleteBuilder,
    this.networkDeleteBuilder,
    this.verticalPadding,
    this.selectedFile,
    this.selectedImageNetwork,
  });
  final ImageType type;
  final dynamic image;
  final void Function(File, WidgetRef) onSelectImageFile;
  final void Function(String, WidgetRef) onSelectNetworkImage;
  final void Function(File) onDeleteImageFile;
  final void Function(String) onDeleteNetworkImage;
  final Widget Function(BuildContext, File)? fileDeleteBuilder;
  final Widget Function(BuildContext, String)? networkDeleteBuilder;
  final ItemWidgetBuilder imageBuilder;
  final double? verticalPadding;
  final File? selectedFile;
  final String? selectedImageNetwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        type == ImageType.file
            ? ImageTile<File>(
                key: ValueKey(image),
                type: ImageType.file,
                image: image,
                onImageTap: () => onSelectImageFile(image, ref),
                verticalPadding: verticalPadding,
                selectedImage: selectedFile,
                deleteBuilder: fileDeleteBuilder,
                imageBuilder: imageBuilder,
                onDelete: onDeleteImageFile,
              )
            : ImageTile<String>(
                key: ValueKey(image),
                type: ImageType.network,
                image: image,
                onImageTap: () => onSelectNetworkImage(image, ref),
                verticalPadding: verticalPadding,
                selectedImage: selectedImageNetwork,
                deleteBuilder: networkDeleteBuilder,
                imageBuilder: imageBuilder,
                onDelete: onDeleteNetworkImage,
              ),
      ]),
    );
  }
}

//a provider use for sellecting a network image
final selectedNetworkImage = StateProvider.autoDispose<String?>((ref) => null);
//a provider use for sellecting a file image
final selectedImageFile = StateProvider.autoDispose<File?>((ref) => null);

//A type representing the imageBuilder
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

//generic image tile that displays either file image or network image
class ImageTile<T> extends StatelessWidget {
  const ImageTile(
      {super.key,
      required this.image,
      required this.onImageTap,
      required this.selectedImage,
      this.deleteBuilder,
      required this.type,
      required this.imageBuilder,
      this.itemsGap,
      this.verticalPadding,
      required this.onDelete});
  final T image;
  final VoidCallback onImageTap;
  final T? selectedImage;
  final ItemWidgetBuilder<T>? deleteBuilder;
  final ItemWidgetBuilder<T> imageBuilder;
  final void Function(T) onDelete;
  final ImageType type;
  final double? verticalPadding;
  final double? itemsGap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0),
      child: InkWell(
        onTap: onImageTap,
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            imageBuilder(context, image),
            Positioned(
              top: -10,
              right: -05,
              child: Visibility(
                visible: selectedImage != null && image == selectedImage,
                child: InkWell(
                  onTap: () => onDelete(image),
                  child: deleteBuilder != null
                      ? deleteBuilder!(context, image)
                      : _defaultDelete(context, image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultDelete(context, image) => const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.black45,
        child: Icon(
          Icons.close,
          size: 18,
          color: Colors.white,
        ),
      );
}
