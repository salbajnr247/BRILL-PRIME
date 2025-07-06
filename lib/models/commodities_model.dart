// To parse this JSON data, do
//
//     final commodityModel = commodityModelFromJson(jsonString);

import 'dart:convert';

CommodityModel commodityModelFromJson(String str) =>
    CommodityModel.fromJson(json.decode(str));

class CommodityModel {
  dynamic status;
  dynamic message;
  List<CommodityData> data;

  CommodityModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommodityModel.fromJson(Map<String, dynamic> json) => CommodityModel(
        status: json["status"],
        message: json["message"],
        data: List<CommodityData>.from(
            json["data"].map((x) => CommodityData.fromJson(x))),
      );
}

class CommodityData {
  dynamic id;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic quantity;
  dynamic imageUrl;
  dynamic unit;
  dynamic vendorId;
  dynamic category;
  dynamic isDeleted;

  CommodityData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.unit,
    required this.vendorId,
    required this.category,
    required this.isDeleted,
  });

  factory CommodityData.fromJson(Map<String, dynamic> json) => CommodityData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        quantity: json["quantity"],
        imageUrl: json["imageUrl"],
        unit: json["unit"],
        vendorId: json["vendorId"],
        category: json["category"],
        isDeleted: json["isDeleted"],
      );
}
