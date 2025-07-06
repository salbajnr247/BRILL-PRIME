// To parse this JSON data, do
//
//     final placeOrderModel = placeOrderModelFromJson(jsonString);

import 'dart:convert';

PlaceOrderModel placeOrderModelFromJson(String str) =>
    PlaceOrderModel.fromJson(json.decode(str));

class PlaceOrderModel {
  dynamic status;
  dynamic message;
  dynamic data;

  PlaceOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlaceOrderModel.fromJson(Map<String, dynamic> json) =>
      PlaceOrderModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );
}
