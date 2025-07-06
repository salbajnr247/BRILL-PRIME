
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/models/vendor_model.dart';

void main() {
  group('VendorModel Tests', () {
    test('should create VendorModel from JSON correctly', () {
      final json = {
        'id': '456',
        'name': 'Test Vendor',
        'email': 'vendor@example.com',
        'phone': '+1234567890',
        'address': '123 Main St',
        'isVerified': true,
      };

      final vendor = VendorModel.fromJson(json);
      
      expect(vendor.id, '456');
      expect(vendor.name, 'Test Vendor');
      expect(vendor.email, 'vendor@example.com');
      expect(vendor.isVerified, true);
    });

    test('should convert VendorModel to JSON correctly', () {
      final vendor = VendorModel(
        id: '456',
        name: 'Test Vendor',
        email: 'vendor@example.com',
        phone: '+1234567890',
        address: '123 Main St',
        isVerified: true,
      );

      final json = vendor.toJson();
      
      expect(json['id'], '456');
      expect(json['name'], 'Test Vendor');
      expect(json['email'], 'vendor@example.com');
      expect(json['isVerified'], true);
    });
  });
}
