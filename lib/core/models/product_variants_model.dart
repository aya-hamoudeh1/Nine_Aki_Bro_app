class ProductVariantModel {
  final String color;
  final String size;

  ProductVariantModel({
    required this.color,
    required this.size,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      color: json['color'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
    );
  }
  Map<String, dynamic> toJson() => {
        'color': color,
        'size': size,
      };
}
