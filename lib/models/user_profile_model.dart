// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

class UserProfileModel {
  dynamic status;
  dynamic message;
  UserData data;

  UserProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );
}

class UserData {
  dynamic id;
  dynamic email;
  dynamic fullName;
  dynamic password;
  dynamic imageUrl;
  dynamic otp;
  dynamic phone;
  dynamic verified;
  dynamic role;
  dynamic location;
  dynamic isDeleted;
  dynamic deletedAt;
  Vendor? vendor;
  dynamic driver;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.imageUrl,
    required this.otp,
    required this.phone,
    required this.verified,
    required this.role,
    required this.location,
    required this.isDeleted,
    required this.deletedAt,
    required this.vendor,
    required this.driver,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        password: json["password"],
        imageUrl: json["imageUrl"],
        otp: json["otp"],
        phone: json["phone"],
        verified: json["verified"],
        role: json["role"],
        location: json["location"],
        isDeleted: json["isDeleted"],
        deletedAt: json["deletedAt"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
        driver: json["driver"],
      );
}

class Vendor {
  dynamic id;
  dynamic accountName;
  dynamic bankName;
  dynamic accountNumber;
  dynamic address;
  dynamic userId;
  dynamic businessCategory;
  dynamic businessNumber;
  dynamic businessName;
  dynamic isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Vendor({
    required this.id,
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
    required this.address,
    required this.userId,
    required this.businessCategory,
    required this.businessNumber,
    required this.businessName,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        accountName: json["accountName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        address: json["address"],
        userId: json["userId"],
        businessCategory: json["businessCategory"],
        businessNumber: json["businessNumber"],
        businessName: json["businessName"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );
}
