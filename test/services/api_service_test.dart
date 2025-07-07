
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:brill_prime/services/api_service.dart';
import 'package:brill_prime/resources/constants/endpoints.dart';

@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      apiService = ApiService();
      mockClient = MockClient();
    });

    group('Authentication Tests', () {
      test('login should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'token': 'test_token',
          'user': {
            'id': '1',
            'email': 'test@example.com',
            'name': 'Test User'
          }
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$loginEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          200,
        ));

        // Act
        final result = await apiService.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result['success'], true);
        expect(result['token'], 'test_token');
        expect(result['user']['email'], 'test@example.com');
      });

      test('signUp should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'message': 'User created successfully',
          'user': {
            'id': '1',
            'email': 'test@example.com',
            'firstName': 'Test',
            'lastName': 'User'
          }
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$signUpEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          201,
        ));

        // Act
        final result = await apiService.signUp(
          email: 'test@example.com',
          password: 'password123',
          firstName: 'Test',
          lastName: 'User',
          phone: '+1234567890',
          userType: 'consumer',
        );

        // Assert
        expect(result['success'], true);
        expect(result['user']['email'], 'test@example.com');
      });

      test('verifyOtp should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'message': 'OTP verified successfully',
          'token': 'verified_token'
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$verifyOtpEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          200,
        ));

        // Act
        final result = await apiService.verifyOtp(
          email: 'test@example.com',
          otp: '123456',
        );

        // Assert
        expect(result['success'], true);
        expect(result['token'], 'verified_token');
      });
    });

    group('Commodity Tests', () {
      test('getCommodities should return commodities list', () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'name': 'Rice',
              'price': 100.0,
              'category': 'grains'
            },
            {
              'id': '2',
              'name': 'Wheat',
              'price': 80.0,
              'category': 'grains'
            }
          ],
          'pagination': {
            'page': 1,
            'limit': 20,
            'total': 2
          }
        };

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          200,
        ));

        // Act
        final result = await apiService.getCommodities();

        // Assert
        expect(result['success'], true);
        expect(result['data'], isA<List>());
        expect(result['data'].length, 2);
      });

      test('createCommodity should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'message': 'Commodity created successfully',
          'data': {
            'id': '1',
            'name': 'Rice',
            'price': 100.0,
            'category': 'grains'
          }
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$createCommodityEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          201,
        ));

        // Act
        final result = await apiService.createCommodity(
          commodityData: {
            'name': 'Rice',
            'price': 100.0,
            'category': 'grains',
            'description': 'High quality rice'
          },
        );

        // Assert
        expect(result['success'], true);
        expect(result['data']['name'], 'Rice');
      });
    });

    group('Cart Tests', () {
      test('getCart should return cart items', () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': {
            'id': '1',
            'items': [
              {
                'id': '1',
                'commodityId': '1',
                'quantity': 2,
                'price': 100.0
              }
            ],
            'total': 200.0
          }
        };

        when(mockClient.get(
          Uri.parse('$basedURL/$getCartEndpoint'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          200,
        ));

        // Act
        final result = await apiService.getCart();

        // Assert
        expect(result['success'], true);
        expect(result['data']['items'], isA<List>());
        expect(result['data']['total'], 200.0);
      });

      test('addToCart should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'message': 'Item added to cart successfully',
          'data': {
            'itemId': '1',
            'commodityId': '1',
            'quantity': 1
          }
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$addToCartEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          201,
        ));

        // Act
        final result = await apiService.addToCart(
          commodityId: '1',
          quantity: 1,
        );

        // Assert
        expect(result['success'], true);
        expect(result['data']['commodityId'], '1');
      });
    });

    group('Order Tests', () {
      test('placeOrder should return success response', () async {
        // Arrange
        final responseData = {
          'success': true,
          'message': 'Order placed successfully',
          'data': {
            'orderId': '1',
            'status': 'pending',
            'total': 200.0
          }
        };

        when(mockClient.post(
          Uri.parse('$basedURL/$placeOrderEndpoint'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          201,
        ));

        // Act
        final result = await apiService.placeOrder(
          orderData: {
            'items': [
              {'commodityId': '1', 'quantity': 2}
            ],
            'deliveryAddress': 'Test Address',
            'paymentMethod': 'card'
          },
        );

        // Assert
        expect(result['success'], true);
        expect(result['data']['orderId'], '1');
      });

      test('getOrders should return orders list', () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'status': 'pending',
              'total': 200.0,
              'createdAt': '2024-01-01T00:00:00Z'
            }
          ],
          'pagination': {
            'page': 1,
            'limit': 20,
            'total': 1
          }
        };

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(responseData),
          200,
        ));

        // Act
        final result = await apiService.getOrders();

        // Assert
        expect(result['success'], true);
        expect(result['data'], isA<List>());
        expect(result['data'].length, 1);
      });
    });

    group('Error Handling Tests', () {
      test('should throw exception on 401 unauthorized', () async {
        // Arrange
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode({'error': 'Unauthorized'}),
          401,
        ));

        // Act & Assert
        expect(
          () => apiService.getUserProfile(),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception on 500 server error', () async {
        // Arrange
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode({'error': 'Internal Server Error'}),
          500,
        ));

        // Act & Assert
        expect(
          () => apiService.getUserProfile(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
