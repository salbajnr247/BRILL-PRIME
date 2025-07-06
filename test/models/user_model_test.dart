
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create UserModel from JSON correctly', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
      };

      final user = UserModel.fromJson(json);
      
      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '+1234567890');
    });

    test('should convert UserModel to JSON correctly', () {
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
      );

      final json = user.toJson();
      
      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '+1234567890');
    });
  });
}
