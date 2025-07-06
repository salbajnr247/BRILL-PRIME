// To parse this JSON data, do
//
//     final retrievedAccountModel = retrievedAccountModelFromJson(jsonString);

import 'dart:convert';

RetrievedAccountModel retrievedAccountModelFromJson(String str) =>
    RetrievedAccountModel.fromJson(json.decode(str));

class RetrievedAccountModel {
  dynamic accountName;
  dynamic accountNumber;

  RetrievedAccountModel({
    required this.accountName,
    required this.accountNumber,
  });

  factory RetrievedAccountModel.fromJson(Map<String, dynamic> json) =>
      RetrievedAccountModel(
        accountName: json["account_name"],
        accountNumber: json["account_number"],
      );
}
