import 'package:hive_flutter/hive_flutter.dart';

part 'biometric_detail_model.g.dart';

@HiveType(typeId: 2)
class HiveBiometricModel {
  HiveBiometricModel({
    required this.email,
    required this.password,
  });

  @HiveField(0)
  String? email;

  @HiveField(1)
  String? password;
}
