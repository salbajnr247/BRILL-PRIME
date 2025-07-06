// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:brill_prime/models/user_profile_model.dart';

VendorModel vendorModelFromJson(String str) =>
    VendorModel.fromJson(json.decode(str));

class VendorModel {
  dynamic status;
  dynamic message;
  List<Vendor> data;

  VendorModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        status: json["status"],
        message: json["message"],
        data: List<Vendor>.from(json["data"].map((x) => Vendor.fromJson(x))),
      );
}
