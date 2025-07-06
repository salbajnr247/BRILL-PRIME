
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/resources/constants/validator_function.dart';

void main() {
  group('Validator Function Tests', () {
    test('should validate email correctly', () {
      expect(isValidEmail('test@example.com'), true);
      expect(isValidEmail('invalid-email'), false);
      expect(isValidEmail(''), false);
      expect(isValidEmail('test@'), false);
      expect(isValidEmail('@example.com'), false);
    });

    test('should validate phone number correctly', () {
      expect(isValidPhoneNumber('+1234567890'), true);
      expect(isValidPhoneNumber('1234567890'), true);
      expect(isValidPhoneNumber('123'), false);
      expect(isValidPhoneNumber(''), false);
      expect(isValidPhoneNumber('abcd'), false);
    });

    test('should validate password correctly', () {
      expect(isValidPassword('Password123!'), true);
      expect(isValidPassword('password'), false); // No uppercase/number/special
      expect(isValidPassword('PASSWORD'), false); // No lowercase/number/special
      expect(isValidPassword('Password'), false); // No number/special
      expect(isValidPassword('12345678'), false); // No letters
      expect(isValidPassword('Pass1!'), false); // Too short
    });

    test('should validate required field correctly', () {
      expect(isRequired('test'), true);
      expect(isRequired(''), false);
      expect(isRequired('   '), false); // Only whitespace
    });
  });
}
