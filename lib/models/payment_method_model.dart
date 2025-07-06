import 'dart:convert';

class PaymentMethodModel {
  final String id;
  final String cardNumber;
  final String cardType;
  final String expiryMonth;
  final String expiryYear;
  final String cardHolderName;
  final String last4;
  final String brand;
  final DateTime createdAt;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.cardNumber,
    required this.cardType,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardHolderName,
    required this.last4,
    required this.brand,
    required this.createdAt,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: json['id'] ?? '',
        cardNumber: json['cardNumber'] ?? '',
        cardType: json['cardType'] ?? '',
        expiryMonth: json['expiryMonth'] ?? '',
        expiryYear: json['expiryYear'] ?? '',
        cardHolderName: json['cardHolderName'] ?? '',
        last4: json['last4'] ?? '',
        brand: json['brand'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        isDefault: json['isDefault'] == true || json['isDefault'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardNumber': cardNumber,
        'cardType': cardType,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cardHolderName': cardHolderName,
        'last4': last4,
        'brand': brand,
        'createdAt': createdAt.toIso8601String(),
        'isDefault': isDefault,
      };

  static List<PaymentMethodModel> listFromJson(String str) =>
      List<PaymentMethodModel>.from(json.decode(str).map((x) => PaymentMethodModel.fromJson(x)));
} 