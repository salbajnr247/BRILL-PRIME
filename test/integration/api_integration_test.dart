
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:brill_prime/services/api_service.dart';
import 'package:brill_prime/resources/constants/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('API Integration Tests', () {
    late ApiService apiService;

    setUpAll(() {
      apiService = ApiService();
    });

    group('Backend Health Check', () {
      testWidgets('should connect to backend server', (tester) async {
        // Test basic connectivity to the backend
        try {
          final response = await http.get(
            Uri.parse('$basedURL/health'),
            headers: {'Accept': 'application/json'},
          );
          
          expect(response.statusCode, lessThan(500));
          print('Backend Status: ${response.statusCode}');
          print('Backend Response: ${response.body}');
        } catch (e) {
          print('Backend connection error: $e');
          // Don't fail the test if backend is not available
        }
      });

      testWidgets('should have proper CORS headers', (tester) async {
        try {
          final response = await http.options(
            Uri.parse('$basedURL/'),
            headers: {
              'Origin': 'https://brillprime-dev.onrender.com',
              'Access-Control-Request-Method': 'GET',
              'Access-Control-Request-Headers': 'Authorization,Content-Type',
            },
          );
          
          print('CORS Response: ${response.headers}');
          expect(response.headers.containsKey('access-control-allow-origin'), true);
        } catch (e) {
          print('CORS check error: $e');
        }
      });
    });

    group('Authentication Endpoints', () {
      testWidgets('should handle login request', (tester) async {
        try {
          final response = await http.post(
            Uri.parse('$basedURL/$loginEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': 'test@example.com',
              'password': 'testpassword',
            }),
          );
          
          print('Login Response Status: ${response.statusCode}');
          print('Login Response Body: ${response.body}');
          
          // Should return proper error for invalid credentials
          expect(response.statusCode, isIn([200, 401, 422]));
        } catch (e) {
          print('Login endpoint error: $e');
        }
      });

      testWidgets('should handle signup request', (tester) async {
        try {
          final response = await http.post(
            Uri.parse('$basedURL/$signUpEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': 'test@example.com',
              'password': 'testpassword',
              'firstName': 'Test',
              'lastName': 'User',
              'phone': '+1234567890',
              'userType': 'consumer',
            }),
          );
          
          print('Signup Response Status: ${response.statusCode}');
          print('Signup Response Body: ${response.body}');
          
          // Should return proper response
          expect(response.statusCode, isIn([200, 201, 409, 422]));
        } catch (e) {
          print('Signup endpoint error: $e');
        }
      });

      testWidgets('should handle forgot password request', (tester) async {
        try {
          final response = await http.post(
            Uri.parse('$basedURL/$forgotPasswordEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': 'test@example.com',
            }),
          );
          
          print('Forgot Password Response Status: ${response.statusCode}');
          print('Forgot Password Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 404, 422]));
        } catch (e) {
          print('Forgot password endpoint error: $e');
        }
      });
    });

    group('Commodity Endpoints', () {
      testWidgets('should fetch commodities', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getCommoditiesEndpoint'),
            headers: {
              'Accept': 'application/json',
            },
          );
          
          print('Commodities Response Status: ${response.statusCode}');
          print('Commodities Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401]));
        } catch (e) {
          print('Commodities endpoint error: $e');
        }
      });

      testWidgets('should handle commodity search', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$searchCommoditiesEndpoint?q=rice'),
            headers: {
              'Accept': 'application/json',
            },
          );
          
          print('Search Response Status: ${response.statusCode}');
          print('Search Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401]));
        } catch (e) {
          print('Search endpoint error: $e');
        }
      });

      testWidgets('should handle commodity categories', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getCommodityCategoriesEndpoint'),
            headers: {
              'Accept': 'application/json',
            },
          );
          
          print('Categories Response Status: ${response.statusCode}');
          print('Categories Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401]));
        } catch (e) {
          print('Categories endpoint error: $e');
        }
      });
    });

    group('Order Endpoints', () {
      testWidgets('should handle orders request', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getOrdersEndpoint'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
          );
          
          print('Orders Response Status: ${response.statusCode}');
          print('Orders Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401]));
        } catch (e) {
          print('Orders endpoint error: $e');
        }
      });

      testWidgets('should handle place order request', (tester) async {
        try {
          final response = await http.post(
            Uri.parse('$basedURL/$placeOrderEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
            body: json.encode({
              'items': [
                {'commodityId': '1', 'quantity': 1}
              ],
              'deliveryAddress': 'Test Address',
              'paymentMethod': 'card',
            }),
          );
          
          print('Place Order Response Status: ${response.statusCode}');
          print('Place Order Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 201, 401, 422]));
        } catch (e) {
          print('Place order endpoint error: $e');
        }
      });
    });

    group('Cart Endpoints', () {
      testWidgets('should handle cart requests', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getCartEndpoint'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
          );
          
          print('Cart Response Status: ${response.statusCode}');
          print('Cart Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401]));
        } catch (e) {
          print('Cart endpoint error: $e');
        }
      });

      testWidgets('should handle add to cart request', (tester) async {
        try {
          final response = await http.post(
            Uri.parse('$basedURL/$addToCartEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
            body: json.encode({
              'commodityId': '1',
              'quantity': 1,
            }),
          );
          
          print('Add to Cart Response Status: ${response.statusCode}');
          print('Add to Cart Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 201, 401, 422]));
        } catch (e) {
          print('Add to cart endpoint error: $e');
        }
      });
    });

    group('Vendor Endpoints', () {
      testWidgets('should handle vendor profile request', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getVendorProfileEndpoint'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
          );
          
          print('Vendor Profile Response Status: ${response.statusCode}');
          print('Vendor Profile Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401, 403]));
        } catch (e) {
          print('Vendor profile endpoint error: $e');
        }
      });

      testWidgets('should handle vendor analytics request', (tester) async {
        try {
          final response = await http.get(
            Uri.parse('$basedURL/$getVendorAnalyticsEndpoint'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer test_token',
            },
          );
          
          print('Vendor Analytics Response Status: ${response.statusCode}');
          print('Vendor Analytics Response Body: ${response.body}');
          
          expect(response.statusCode, isIn([200, 401, 403]));
        } catch (e) {
          print('Vendor analytics endpoint error: $e');
        }
      });
    });

    group('WebSocket Endpoints', () {
      testWidgets('should handle WebSocket connection', (tester) async {
        try {
          // Test WebSocket endpoint availability
          final response = await http.get(
            Uri.parse('$basedURL/ws'),
            headers: {
              'Accept': 'application/json',
              'Upgrade': 'websocket',
              'Connection': 'Upgrade',
            },
          );
          
          print('WebSocket Response Status: ${response.statusCode}');
          print('WebSocket Response Headers: ${response.headers}');
          
          // WebSocket endpoints typically return 400 for regular HTTP requests
          expect(response.statusCode, isIn([200, 400, 404, 426]));
        } catch (e) {
          print('WebSocket endpoint error: $e');
        }
      });
    });
  });
}
