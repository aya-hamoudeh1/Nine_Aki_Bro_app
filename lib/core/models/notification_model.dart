class NotificationModel {
  String? id;
  String? userId;
  String? title;
  String? body;
  bool? isRead;
  DateTime? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['notifications_id'] as String?,
        userId: json['for_user'] as String?,
        title: json['title'] as String?,
        body: json['body'] as String?,
        isRead: json['is_read'] as bool?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'notifications_id': id,
        'for_user': userId,
        'title': title,
        'body': body,
        'is_read': isRead,
        'created_at': createdAt?.toIso8601String(),
      };
}
