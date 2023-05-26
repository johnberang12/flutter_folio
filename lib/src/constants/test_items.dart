import 'dart:io';

import '../features/product/domain/product.dart';

List<Product> kTestProducts = [
  for (var i = 0; i < 3; i++)
    Product(
        id: '10$i',
        title: 'title$i',
        description: 'description$i',
        price: double.tryParse('10+$i') ?? 0,
        photos: ['photos$i'],
        ownerId: 'ownerId$i')
];

List<File> kTestImageFiles = [
  File(
      '/data/user/0/com.example.flutter_folio/cache/scaled_f226734d-cba3-4dd1-a5d0-4670072cfcc2.png'),
  File(
      '/data/user/0/com.example.flutter_folio/cache/scaled_beautyAndPersonalCare.jpg')
];
