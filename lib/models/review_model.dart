import 'dart:convert';

class ReviewModel {
  final String id;
  final String userId;
  final String itemId;
  final String itemType; // 'product' or 'vendor'
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        itemId: json['itemId'] ?? '',
        itemType: json['itemType'] ?? '',
        rating: json['rating'] ?? 0,
        comment: json['comment'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'itemId': itemId,
        'itemType': itemType,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  static List<ReviewModel> listFromJson(String str) =>
      List<ReviewModel>.from(json.decode(str).map((x) => ReviewModel.fromJson(x)));
} 