import 'package:nine_aki_bro_app/core/models/product_variants_model.dart';
import 'package:nine_aki_bro_app/core/models/purchase_model.dart';

import 'favorite_model.dart';

class ProductModel {
  String? productId;
  DateTime? createdAt;
  String? productName;
  String? price;
  String? oldPrice;
  String? sale;
  String? description;
  String? categoryId;
  String? imageUrl;
  List<Favorite>? favoriteProduct;
  List<Purchase>? purchase;
  int quantity;
  List<ProductVariantModel>? variants;
  String? userOrderStatus;

  ProductModel({
    this.productId,
    this.createdAt,
    this.productName,
    this.price,
    this.oldPrice,
    this.sale,
    this.description,
    this.categoryId,
    this.imageUrl,
    this.favoriteProduct,
    this.purchase,
    this.quantity = 1,
    this.variants,
    this.userOrderStatus,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json['product_id'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        productName: json['product_name'] as String?,
        price: json['price'] as String?,
        oldPrice: json['old_price'] as String?,
        sale: json['sale'] as String?,
        description: json['description'] as String?,
        categoryId: json['category_id'] as String?,
        imageUrl: json['image_url'] as String?,
        favoriteProduct: (json['favorite'] as List<dynamic>?)
            ?.map((e) => Favorite.fromJson(e as Map<String, dynamic>))
            .toList(),
        purchase: (json['purchase'] as List<dynamic>?)
            ?.map((e) => Purchase.fromJson(e as Map<String, dynamic>))
            .toList(),
        quantity: json['quantity'] ?? 1,
        variants: (json['product_variants'] as List<dynamic>?)
            ?.map(
                (e) => ProductVariantModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'created_at': createdAt?.toIso8601String(),
        'product_name': productName,
        'price': price,
        'old_price': oldPrice,
        'sale': sale,
        'description': description,
        'category': categoryId,
        'image_url': imageUrl,
        'favorite': favoriteProduct?.map((e) => e.toJson).toList(),
        'purchase': purchase?.map((e) => e.toJson).toList(),
        'quantity': quantity,
        'variants': variants?.map((e) => e.toJson()).toList(),
      };
}
