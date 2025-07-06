import 'dart:convert';

class OrderActionModel {
  final String id;
  final String orderId;
  final String status;
  final String message;
  final DateTime createdAt;

  OrderActionModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.message,
    required this.createdAt,
  });

  factory OrderActionModel.fromJson(Map<String, dynamic> json) => OrderActionModel(
        id: json['id'] ?? '',
        orderId: json['orderId'] ?? '',
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'status': status,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };

  static List<OrderActionModel> listFromJson(String str) =>
      List<OrderActionModel>.from(json.decode(str).map((x) => OrderActionModel.fromJson(x)));
} 