// To parse this JSON data, do
//
//     final orderPlacedModel = orderPlacedModelFromJson(jsonString);

import 'dart:convert';

OrderPlacedModel orderPlacedModelFromJson(String str) =>
    OrderPlacedModel.fromJson(json.decode(str));

class OrderPlacedModel {
  dynamic status;
  dynamic message;
  dynamic data;

  OrderPlacedModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderPlacedModel.fromJson(Map<String, dynamic> json) =>
      OrderPlacedModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );
}
