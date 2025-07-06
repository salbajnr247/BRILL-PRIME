// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

class CartModel {
  dynamic status;
  dynamic message;
  List<CartData> data;

  CartModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        status: json["status"],
        message: json["message"],
        data:
            List<CartData>.from(json["data"].map((x) => CartData.fromJson(x))),
      );
}

class CartData {
  dynamic id;
  dynamic cartId;
  dynamic commodityId;
  dynamic quantity;
  dynamic commodityName;
  dynamic commodityDescription;
  dynamic commmodityPrice;
  dynamic unit;
  dynamic imageUrl;
  dynamic vendorId;

  CartData({
    required this.id,
    required this.cartId,
    required this.commodityId,
    required this.quantity,
    required this.commodityName,
    required this.commodityDescription,
    required this.commmodityPrice,
    required this.unit,
    required this.imageUrl,
    required this.vendorId,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        id: json["id"],
        cartId: json["cartId"],
        commodityId: json["commodityId"],
        quantity: json["quantity"],
        commodityName: json["commodityName"],
        commodityDescription: json["commodityDescription"],
        commmodityPrice: json["commmodityPrice"],
        unit: json["unit"],
        imageUrl: json["imageUrl"],
        vendorId: json["vendorId"],
      );
}
