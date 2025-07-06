import 'package:hive_flutter/hive_flutter.dart';

part 'hive_user_model.g.dart';

@HiveType(typeId: 1)
class HiveUserModel {
  HiveUserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.token,
    required this.phoneNumber,
    required this.userName,
    required this.address,
    required this.vcn,
    required this.role,
  });
  @HiveField(0)
  dynamic userId;

  @HiveField(1)
  String? fullName;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phoneNumber;

  @HiveField(4)
  String? userName;

  @HiveField(5)
  String? token;

  @HiveField(6)
  String? address;

  @HiveField(7)
  String? vcn;

  @HiveField(8)
  String? role;
}
