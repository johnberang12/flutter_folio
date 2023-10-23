import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';
import 'package:flutter_folio/src/common_widget/appbar_text_button.dart';
import 'package:flutter_folio/src/common_widget/layout_list_view.dart';
import 'package:flutter_folio/src/common_widget/loading_widget.dart';
import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/add_product_controller.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/add_product_screen_validator.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/image_input_widget.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_folio/src/utils/form_validator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widget/clear_text_field.dart';
import '../../../../common_widget/confirmation_callback.dart';
import '../../../../constants/styles.dart';
import '../../domain/product.dart';

const kOnSaveButtonKey = Key('add-prod-screen-done-button-key');
const kAddProductScreenAppbarKey = Key('add-product-screen-appbar-key');
const kProductTitleFieldKey = Key('product-title-field-key');
const kProductPriceFieldKey = Key('product-price-field-key');
const kProductDescriptionFieldKey = Key('product-description-field-key');

class AddProductScreen extends HookConsumerWidget
    with AddProductScreenValidator {
  AddProductScreen({super.key, Product? product}) : _product = product;
  final Product? _product;
  final _formKey = GlobalKey<FormState>();

  // bool _isFormValid() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

//a reusable callback for adding a new product and editing existing one.
  Future<void> _submit(BuildContext context, WidgetRef ref, Product product,
      List<File> images) async {
    final toast = AppToast();
    //this validates the form and save if all fields are valid
    final isValid = formIsValid(_formKey.currentState!);
    // final isValid = _isFormValid();
    //checks if the network images is empty and the picked file images is empty, returns false
    final isNotEmptyPhotos = (images.isNotEmpty || product.photos.isNotEmpty);

    if (isNotEmptyPhotos && isValid) {
      await confirmationCallback(
          context: context,
          title: 'Confirm submission',
          content: 'Are you sure you want to add this product?',
          cancelActionText: "Cancel",
          callback: () async {
            //only update the product if changes is made.
            if (product != _product) {
              await ref
                  .read(addProductControllerProvider.notifier)
                  .addProduct(product, images)
                  .then((success) {
                if (success) {
                  //execute this block if the operation is successful
                  toast.showToast(msg: 'Product successfully added.');
                  context.pop();
                }
              });
            } else {
              toast.showToast(msg: 'No update has been made.');
              context.pop();
            }
          });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final priceController = useTextEditingController();
    final descriptionController = useTextEditingController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_product != null) {
          titleController.text = _product!.title;
          priceController.text = _product!.price.toString();
          descriptionController.text = _product!.description;
        }
      });

      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        key: kAddProductScreenAppbarKey,
        title: Text(_product != null ? 'Edit Product' : 'Add Product'),
        actions: [
          Consumer(builder: (context, ref, _) {
            final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
            //list of imagefiles picked by the user
            final fileValue = ref.watch(fileControllerProvider);
            //list of network images. if the user is adding new product, this is empty
            final networkValue = ref.watch(networkControllerProvider);

            return AppbarActionTextButton(
              text: "Done",
              key: kOnSaveButtonKey,
              // textButtonKey: kOnSaveButtonKey,
              onPressed: () async {
                //creating a new product for adding a new product or editing existing product to minimize code.
                //this is ok for this simple Product object that has few and simple fields.
                //But for complex apps that has a complex fields, its recommended to create separate callback
                //for new product and editing existing product.

                final newProduct = Product(
                    id: _product?.id ?? idFromCurrentDate(),
                    ownerId: _product?.ownerId ?? userId ?? "",
                    title: titleController.text,
                    description: descriptionController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    photos: networkValue);
                await _submit(context, ref, newProduct, fileValue);
              },
              textColor: Colors.white,
              isLoading: false,
            );
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Consumer(builder: (context, ref, _) {
              //this watches for the state of the controller provider
              final state = ref.watch(addProductControllerProvider);
              //listener of the controller for possible exception
              ref.listen(
                  addProductControllerProvider,
                  //showes an error dialog when an exception occured during api call
                  (_, state) => state.showAlertDialogOnError(context));
              return LoadingWidget(
                  isLoading: state.isLoading,
                  child: LayoutListView(children: [
                    gapH12,
                    ImageInputWidget(product: _product),

                    const Divider(
                      height: 0.5,
                    ),
                    gapH20,

                    ///title field
                    ClearTextField(
                      textFieldKey: kProductTitleFieldKey,
                      controller: titleController,
                      label: 'Enter product title',
                      validator: titleErrorText,
                      style: Styles.k16(context),
                    ),
                    const Divider(
                      height: 20,
                    ),

                    ClearTextField(
                        textFieldKey: kProductPriceFieldKey,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^\d*\.?\d*)'))
                        ],
                        controller: priceController,
                        label: 'Enter price',
                        keyboardType: TextInputType.number,
                        validator: priceErrorText),

                    const Divider(
                      height: 20,
                    ),

                    ///description field
                    ClearTextField(
                      textFieldKey: kProductDescriptionFieldKey,
                      controller: descriptionController,
                      label: 'Desribe your item in as much details as you can',
                      validator: descriptionErrorText,
                      minLines: 6,
                      maxLines: 6,
                    ),
                  ]));
            })),
      ),
    );
  }
}
