class Purchase {
  String? purchaseId;
  String? forUser;
  DateTime? createdAt;
  String? forProduct;
  bool? isBought;
  String? status;

  Purchase({
    this.purchaseId,
    this.forUser,
    this.createdAt,
    this.forProduct,
    this.isBought,
    this.status,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        purchaseId: json['purchase_id'] as String?,
        forUser: json['for_user'] as String?,
        forProduct: json['for_product'] as String?,
        isBought: json['is_bought'] as bool?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'purchase_id': purchaseId,
        'for_user': forUser,
        'for_product': forProduct,
        'is_bought': isBought,
        'created_at': createdAt?.toIso8601String(),
        'status': status,
      };
}
