// To parse this JSON data, do
//
//     final passwordResetModel = passwordResetModelFromJson(jsonString);

import 'dart:convert';

PasswordResetModel passwordResetModelFromJson(String str) =>
    PasswordResetModel.fromJson(json.decode(str));

class PasswordResetModel {
  dynamic status;
  dynamic message;
  PasswordResetData data;

  PasswordResetModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PasswordResetModel.fromJson(Map<String, dynamic> json) =>
      PasswordResetModel(
        status: json["status"],
        message: json["message"],
        data: PasswordResetData.fromJson(json["data"]),
      );
}

class PasswordResetData {
  String accessToken;

  PasswordResetData({
    required this.accessToken,
  });

  factory PasswordResetData.fromJson(Map<String, dynamic> json) =>
      PasswordResetData(
        accessToken: json["access_token"],
      );
}
