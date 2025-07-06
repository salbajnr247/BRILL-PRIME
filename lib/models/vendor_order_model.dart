// To parse this JSON data, do
//
//     final vendorOrderModel = vendorOrderModelFromJson(jsonString);

import 'dart:convert';

VendorOrderModel vendorOrderModelFromJson(String str) =>
    VendorOrderModel.fromJson(json.decode(str));

class VendorOrderModel {
  dynamic status;
  dynamic message;
  List<VendorOrderData> data;

  VendorOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VendorOrderModel.fromJson(Map<String, dynamic> json) =>
      VendorOrderModel(
        status: json["status"],
        message: json["message"],
        data: List<VendorOrderData>.from(
            json["data"].map((x) => VendorOrderData.fromJson(x))),
      );
}

class VendorOrderData {
  dynamic id;
  dynamic totalPrice;
  dynamic consumerId;
  dynamic vendorId;
  dynamic status;
  dynamic txRef;
  dynamic transactionId;
  dynamic isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  VendorOrderData({
    required this.id,
    required this.totalPrice,
    required this.consumerId,
    required this.vendorId,
    required this.status,
    required this.txRef,
    required this.transactionId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory VendorOrderData.fromJson(Map<String, dynamic> json) =>
      VendorOrderData(
        id: json["id"],
        totalPrice: json["totalPrice"],
        consumerId: json["consumerId"],
        vendorId: json["vendorId"],
        status: json["status"],
        txRef: json["txRef"],
        transactionId: json["transactionId"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );
}
