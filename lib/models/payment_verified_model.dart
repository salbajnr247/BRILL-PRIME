// To parse this JSON data, do
//
//     final paymentVerifiedModel = paymentVerifiedModelFromJson(jsonString);

import 'dart:convert';

PaymentVerifiedModel paymentVerifiedModelFromJson(String str) =>
    PaymentVerifiedModel.fromJson(json.decode(str));

class PaymentVerifiedModel {
  dynamic message;
  dynamic status;
  PaymentData data;

  PaymentVerifiedModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory PaymentVerifiedModel.fromJson(Map<String, dynamic> json) =>
      PaymentVerifiedModel(
        message: json["message"],
        status: json["status"],
        data: PaymentData.fromJson(json["data"]),
      );
}

class PaymentData {
  dynamic id;
  dynamic totalPrice;
  dynamic consumerId;
  dynamic vendorId;
  dynamic status;
  dynamic txRef;
  dynamic transactionId;
  dynamic isDeleted;

  PaymentData({
    required this.id,
    required this.totalPrice,
    required this.consumerId,
    required this.vendorId,
    required this.status,
    required this.txRef,
    required this.transactionId,
    required this.isDeleted,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        id: json["id"],
        totalPrice: json["totalPrice"],
        consumerId: json["consumerId"],
        vendorId: json["vendorId"],
        status: json["status"],
        txRef: json["txRef"],
        transactionId: json["transactionId"],
        isDeleted: json["isDeleted"],
      );
}
