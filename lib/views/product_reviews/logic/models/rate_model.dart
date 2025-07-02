class RatingModel {
  String? rateId;
  DateTime? createdAt;
  int? rate;
  String? forUser;
  String? forProduct;

  RatingModel({
    this.rateId,
    this.createdAt,
    this.rate,
    this.forUser,
    this.forProduct,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    rateId: json['rate_id'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    rate: json['rate'] as int?,
    forUser: json['for_user'] as String?,
    forProduct: json['for_product'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'rate_id': rateId,
    'created_at': createdAt?.toIso8601String(),
    'rate': rate,
    'for_user': forUser,
    'for_product': forProduct,
  };
}
