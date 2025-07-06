import 'dart:convert';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  static List<NotificationModel> listFromJson(String str) =>
      List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));
} 