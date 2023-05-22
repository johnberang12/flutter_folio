// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_folio/src/features/image_upload/image_path.dart';
import 'package:flutter_folio/src/features/image_upload/image_upload_repository.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:flutter_folio/src/utils/owner_verifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product_service.g.dart';

//* unit test done
class ProductService {
  ProductService({
    required this.ref,
  });

  final Ref ref;

//this is a function used to set new product or edit existing
//unit test for this is very simple, only test if the function is correctly calling the  uploadFileImages() and setProduct()

  Future<void> setProduct(Product product, List<File> images) =>
      //checks if the current user is the product owner.
      //This is paramount to ensure that only the owner of the product can edit his/her own product
      ref.read(ownerVerifierProvider).verifyOwner(
          //check whether or not the user has an internet connection.
          //This is important as uploading an image may fail when there is no stable connection
          function: () => ref.read(connectionCheckerProvider).checkConnection(
                  function: () async {
                //image urls of the images uploaded
                final imageUrls = await ref
                    .read(imageUploadRepositoryProvider)
                    .uploadFileImages(
                        files: images, path: ImagePath.product(product.id));
                //adding up the network images and the imageurls
                final photos = [...product.photos, ...imageUrls];
                final newProduct = product.copyWith(photos: photos);
                //save the product to the database after uploading images
                await ref
                    .read(productRepositoryProvider)
                    .setProduct(newProduct);
              }),
          ownerId: product.ownerId);

//unit test for this is to simple check if the verifyOwner() is correctly called as verifyOwner and checkConnection methods have their own unit test
  Future<void> deleteProduct(Product product) =>
      //it checkes if the currentUser deleting the product is the product owner
      ref.read(ownerVerifierProvider).verifyOwner(
          // it checks if the users device has a stable internet connection before performing deletion
          function: () => ref.read(connectionCheckerProvider).checkConnection(
              function: () => ref
                  .read(productRepositoryProvider)
                  .deleteProduct(product)
                  .then((value) => ref
                      .read(imageUploadRepositoryProvider)
                      .deleteImages(product.photos))),
          ownerId: product.ownerId);
}

@Riverpod(keepAlive: true)
ProductService productService(ProductServiceRef ref) =>
    ProductService(ref: ref);
