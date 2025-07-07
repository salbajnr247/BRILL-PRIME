import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final String priority; // 'low', 'normal', 'high'

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.priority = 'normal',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        type: json['type'] ?? '',
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        data: json['data'] as Map<String, dynamic>?,
        imageUrl: json['imageUrl'],
        actionUrl: json['actionUrl'],
        priority: json['priority'] ?? 'normal',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'data': data,
        'imageUrl': imageUrl,
        'actionUrl': actionUrl,
        'priority': priority,
      };

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? priority,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      priority: priority ?? this.priority,
    );
  }

  static List<NotificationModel> listFromJson(String str) =>
      List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));
}