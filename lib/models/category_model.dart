// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryData> categoryModelFromJson(String str) => List<CategoryData>.from(
    json.decode(str).map((x) => CategoryData.fromJson(x)));

class CategoryData {
  dynamic id;
  dynamic name;
  dynamic imageUrl;

  CategoryData({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );
}
