import 'dart:convert';

class FavouriteModel {
  final String id;
  final String userId;
  final String itemId;
  final String itemType; // e.g. 'commodity', 'vendor', etc.
  final DateTime createdAt;

  FavouriteModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.createdAt,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        itemId: json['itemId'] ?? '',
        itemType: json['itemType'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'itemId': itemId,
        'itemType': itemType,
        'createdAt': createdAt.toIso8601String(),
      };

  static List<FavouriteModel> listFromJson(String str) =>
      List<FavouriteModel>.from(json.decode(str).map((x) => FavouriteModel.fromJson(x)));
} 