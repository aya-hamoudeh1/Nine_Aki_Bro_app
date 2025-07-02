class Favorite {
  String? favoriteId;
  String? forUser;
  DateTime? createdAt;
  String? forProduct;
  bool? isFavorite;

  Favorite({
    this.favoriteId,
    this.forUser,
    this.createdAt,
    this.forProduct,
    this.isFavorite,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favoriteId: json['favorite_id'] as String?,
        forUser: json['for_user'] as String?,
        forProduct: json['for_product'] as String?,
        isFavorite: json['is_favorite'] as bool?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'favorite_id': favoriteId,
        'for_user': forUser,
        'for_product': forProduct,
        'is_favorite': isFavorite,
        'created_at': createdAt?.toIso8601String(),
      };
}
