
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/services/api_client.dart';

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
    });

    test('should have correct base URL', () {
      expect(apiClient.baseUrl, isNotEmpty);
    });

    test('should handle request headers correctly', () {
      final headers = apiClient.getHeaders();
      expect(headers, isA<Map<String, String>>());
      expect(headers['Content-Type'], 'application/json');
    });

    // Add more specific API tests based on your actual implementation
  });
}
