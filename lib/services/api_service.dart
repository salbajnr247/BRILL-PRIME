
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../resources/constants/endpoints.dart';
import '../utils/functions.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';
import '../models/commodities_model.dart';
import '../models/cart_model.dart';
import '../models/order_placed_model.dart';
import '../models/payment_method_model.dart';
import '../models/notification_model.dart';
import '../models/review_model.dart';
import '../models/address_model.dart';
import '../models/bank_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Map<String, String> _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Map<String, String> get headers {
    final token = getToken();
    if (token.isNotEmpty) {
      return {
        ..._headers,
        'Authorization': 'Bearer $token',
      };
    }
    return _headers;
  }

  // Authentication Services
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$loginEndpoint'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String userType,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$signUpEndpoint'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'userType': userType,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$verifyOtpEndpoint'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'otp': otp,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$forgotPasswordEndpoint'),
      headers: _headers,
      body: json.encode({'email': email}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$resetPasswordEndpoint'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'password': newPassword,
        'token': token,
      }),
    );
    return _handleResponse(response);
  }

  // User Profile Services
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getProfileEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> profileData,
  }) async {
    final response = await http.put(
      Uri.parse('$basedURL/$updateProfileEndpoint'),
      headers: headers,
      body: json.encode(profileData),
    );
    return _handleResponse(response);
  }

  // Vendor Services
  Future<Map<String, dynamic>> createVendor({
    required Map<String, dynamic> vendorData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$createVendorEndpoint'),
      headers: headers,
      body: json.encode(vendorData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getVendorProfile() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getVendorProfileEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getVendorAnalytics() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getVendorAnalyticsEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getVendorOrders() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getVendorOrdersEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateVendorOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$basedURL/$updateVendorOrderStatusEndpoint'),
      headers: headers,
      body: json.encode({
        'orderId': orderId,
        'status': status,
      }),
    );
    return _handleResponse(response);
  }

  // Commodity Services
  Future<Map<String, dynamic>> getCommodities({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse('$basedURL/$getCommoditiesEndpoint')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCommodityDetails({
    required String commodityId,
  }) async {
    final response = await http.get(
      Uri.parse('$basedURL/$getCommodityDetailsEndpoint/$commodityId'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createCommodity({
    required Map<String, dynamic> commodityData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$createCommodityEndpoint'),
      headers: headers,
      body: json.encode(commodityData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateCommodity({
    required String commodityId,
    required Map<String, dynamic> commodityData,
  }) async {
    final response = await http.put(
      Uri.parse('$basedURL/$updateCommodityEndpoint/$commodityId'),
      headers: headers,
      body: json.encode(commodityData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteCommodity({
    required String commodityId,
  }) async {
    final response = await http.delete(
      Uri.parse('$basedURL/$deleteCommodityEndpoint/$commodityId'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // Cart Services
  Future<Map<String, dynamic>> getCart() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getCartEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addToCart({
    required String commodityId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$addToCartEndpoint'),
      headers: headers,
      body: json.encode({
        'commodityId': commodityId,
        'quantity': quantity,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await http.patch(
      Uri.parse('$basedURL/$updateCartItemEndpoint'),
      headers: headers,
      body: json.encode({
        'itemId': itemId,
        'quantity': quantity,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> removeFromCart({
    required String itemId,
  }) async {
    final response = await http.delete(
      Uri.parse('$basedURL/$removeFromCartEndpoint'),
      headers: headers,
      body: json.encode({'itemId': itemId}),
    );
    return _handleResponse(response);
  }

  // Order Services
  Future<Map<String, dynamic>> placeOrder({
    required Map<String, dynamic> orderData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$placeOrderEndpoint'),
      headers: headers,
      body: json.encode(orderData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) queryParams['status'] = status;

    final uri = Uri.parse('$basedURL/$getOrdersEndpoint')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrderDetails({
    required String orderId,
  }) async {
    final response = await http.get(
      Uri.parse('$basedURL/$getOrderDetailsEndpoint/$orderId'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$basedURL/$updateOrderStatusEndpoint'),
      headers: headers,
      body: json.encode({
        'orderId': orderId,
        'status': status,
      }),
    );
    return _handleResponse(response);
  }

  // Payment Services
  Future<Map<String, dynamic>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getPaymentMethodsEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addPaymentMethod({
    required Map<String, dynamic> paymentData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$addPaymentMethodEndpoint'),
      headers: headers,
      body: json.encode(paymentData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> processPayment({
    required Map<String, dynamic> paymentData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$processPaymentEndpoint'),
      headers: headers,
      body: json.encode(paymentData),
    );
    return _handleResponse(response);
  }

  // Notification Services
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$basedURL/$getNotificationsEndpoint')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> markNotificationRead({
    required String notificationId,
  }) async {
    final response = await http.patch(
      Uri.parse('$basedURL/$markNotificationReadEndpoint'),
      headers: headers,
      body: json.encode({'notificationId': notificationId}),
    );
    return _handleResponse(response);
  }

  // Address Services
  Future<Map<String, dynamic>> getAddresses() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getAddressesEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addAddress({
    required Map<String, dynamic> addressData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$addAddressEndpoint'),
      headers: headers,
      body: json.encode(addressData),
    );
    return _handleResponse(response);
  }

  // Bank Account Services
  Future<Map<String, dynamic>> getBankAccounts() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getBankAccountsEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addBankAccount({
    required Map<String, dynamic> bankData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$addBankAccountEndpoint'),
      headers: headers,
      body: json.encode(bankData),
    );
    return _handleResponse(response);
  }

  // Review Services
  Future<Map<String, dynamic>> getReviews({
    required String vendorId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'vendorId': vendorId,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$basedURL/$getReviewsEndpoint')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addReview({
    required Map<String, dynamic> reviewData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$addReviewEndpoint'),
      headers: headers,
      body: json.encode(reviewData),
    );
    return _handleResponse(response);
  }

  // Search Services
  Future<Map<String, dynamic>> search({
    required String query,
    String? category,
    String? location,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'q': query,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;

    final uri = Uri.parse('$basedURL/$searchEndpoint')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  // Toll Gate Services
  Future<Map<String, dynamic>> getTollGates() async {
    final response = await http.get(
      Uri.parse('$basedURL/$getTollGatesEndpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> purchaseTollTicket({
    required Map<String, dynamic> ticketData,
  }) async {
    final response = await http.post(
      Uri.parse('$basedURL/$purchaseTollTicketEndpoint'),
      headers: headers,
      body: json.encode(ticketData),
    );
    return _handleResponse(response);
  }

  // File Upload Services
  Future<Map<String, dynamic>> uploadImage({
    required File imageFile,
    required String fieldName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$basedURL/$uploadImageEndpoint'),
    );

    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(fieldName, imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  // Private helper method to handle responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    log('Response Status: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
