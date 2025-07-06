// To parse this JSON data, do
//
//     final consumerOrderDetailModel = consumerOrderDetailModelFromJson(jsonString);

import 'dart:convert';

ConsumerOrderDetailModel consumerOrderDetailModelFromJson(String str) =>
    ConsumerOrderDetailModel.fromJson(json.decode(str));

class ConsumerOrderDetailModel {
  dynamic status;
  dynamic message;
  CustomerOrderDetailData data;

  ConsumerOrderDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ConsumerOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      ConsumerOrderDetailModel(
        status: json["status"],
        message: json["message"],
        data: CustomerOrderDetailData.fromJson(json["data"]),
      );
}

class CustomerOrderDetailData {
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
  List<CustomerOrderItem> items;
  dynamic consumerName;

  CustomerOrderDetailData({
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
    required this.items,
    required this.consumerName,
  });

  factory CustomerOrderDetailData.fromJson(Map<String, dynamic> json) =>
      CustomerOrderDetailData(
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
          items: List<CustomerOrderItem>.from(
              json["items"].map((x) => CustomerOrderItem.fromJson(x))),
          consumerName: json["consumerName"]);
}

class CustomerOrderItem {
  dynamic id;
  dynamic orderId;
  dynamic cartId;
  dynamic commodityId;
  dynamic quantity;
  dynamic commodityName;
  dynamic commodityDescription;
  dynamic commodityPrice;
  dynamic unit;
  dynamic imageUrl;
  dynamic vendorId;
  dynamic isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  CustomerOrderItem({
    required this.id,
    required this.orderId,
    required this.cartId,
    required this.commodityId,
    required this.quantity,
    required this.commodityName,
    required this.commodityDescription,
    required this.commodityPrice,
    required this.unit,
    required this.imageUrl,
    required this.vendorId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CustomerOrderItem.fromJson(Map<String, dynamic> json) =>
      CustomerOrderItem(
        id: json["id"],
        orderId: json["orderId"],
        cartId: json["cartId"],
        commodityId: json["commodityId"],
        quantity: json["quantity"],
        commodityName: json["commodityName"],
        commodityDescription: json["commodityDescription"],
        commodityPrice: json["commodityPrice"],
        unit: json["unit"],
        imageUrl: json["imageUrl"],
        vendorId: json["vendorId"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );
}
