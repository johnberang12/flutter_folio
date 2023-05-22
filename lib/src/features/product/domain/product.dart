// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../app_user/domain/app_user.dart';

typedef ProductID = String;

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.photos,
    required this.ownerId,
  });

  final ProductID id;
  final String title;
  final String description;
  final double price;
  final List<String> photos;
  final UserID ownerId;

  Product copyWith({
    ProductID? id,
    String? title,
    String? description,
    double? price,
    List<String>? photos,
    UserID? ownerId,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      photos: photos ?? this.photos,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'photos': photos,
      'ownerId': ownerId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      price: map['price'] ?? 0.0,
      //this is used to convert the List<dynamic> to List<String>
      photos: List<String>.from(map['photos'] ?? []),
      ownerId: map['ownerId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, photos: $photos, ownerId: $ownerId)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        listEquals(other.photos, photos) &&
        other.ownerId == ownerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        photos.hashCode ^
        ownerId.hashCode;
  }
}
