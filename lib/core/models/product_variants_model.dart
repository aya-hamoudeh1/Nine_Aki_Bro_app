class ProductVariantModel {
  final String variantId;
  final String color;
  final String size;
  final double price;
  final int stock;
  final String imageUrl;

  ProductVariantModel({
    required this.variantId,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['product_variants_id'] ?? '',
      color: json['color'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'product_variants_id': variantId,
    'color': color,
    'size': size,
    'price': price,
    'stock': stock,
    'image_url': imageUrl,
  };
}
