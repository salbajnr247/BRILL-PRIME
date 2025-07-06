// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

List<BankData> bankModelFromJson(String str) =>
    List<BankData>.from(json.decode(str).map((x) => BankData.fromJson(x)));

class BankData {
  dynamic id;
  dynamic code;
  dynamic name;

  BankData({
    required this.id,
    required this.code,
    required this.name,
  });

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );
}
