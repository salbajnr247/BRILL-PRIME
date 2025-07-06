// To parse this JSON data, do
//
//     final consumerOrderModel = consumerOrderModelFromJson(jsonString);

import 'dart:convert';

ConsumerOrderModel consumerOrderModelFromJson(String str) =>
    ConsumerOrderModel.fromJson(json.decode(str));

class ConsumerOrderModel {
  dynamic status;
  dynamic message;
  List<ConsumerOrderData> data;

  ConsumerOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ConsumerOrderModel.fromJson(Map<String, dynamic> json) =>
      ConsumerOrderModel(
        status: json["status"],
        message: json["message"],
        data: List<ConsumerOrderData>.from(
            json["data"].map((x) => ConsumerOrderData.fromJson(x))),
      );
}

class ConsumerOrderData {
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

  ConsumerOrderData({
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

  factory ConsumerOrderData.fromJson(Map<String, dynamic> json) =>
      ConsumerOrderData(
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
