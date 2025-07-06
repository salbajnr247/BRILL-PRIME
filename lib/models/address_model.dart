import 'dart:convert';

class AddressModel {
  final String id;
  final String userId;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zip;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        street: json['street'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        zip: json['zip'] ?? '',
        isDefault: json['isDefault'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'zip': zip,
        'isDefault': isDefault,
      };

  static List<AddressModel> listFromJson(String str) =>
      List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));
} 