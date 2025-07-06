import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/api_client.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> productReviews = [];
  List<ReviewModel> vendorReviews = [];
  bool loading = false;
  String errorMessage = '';

  Future<void> fetchProductReviews({required BuildContext context, required String productId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'products/$productId/reviews',
        context: context,
        requestName: 'fetchProductReviews',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        productReviews = ReviewModel.listFromJson(response.$2);
      } else {
        errorMessage = response.$2;
      }
      notifyListeners();
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchVendorReviews({required BuildContext context, required String vendorId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'vendors/$vendorId/reviews',
        context: context,
        requestName: 'fetchVendorReviews',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        vendorReviews = ReviewModel.listFromJson(response.$2);
      } else {
        errorMessage = response.$2;
      }
      notifyListeners();
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> submitProductReview({required BuildContext context, required String productId, required ReviewModel review}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'products/$productId/reviews',
        context: context,
        body: review.toJson(),
        requestName: 'submitProductReview',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchProductReviews(context: context, productId: productId);
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitVendorReview({required BuildContext context, required String vendorId, required ReviewModel review}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'vendors/$vendorId/reviews',
        context: context,
        body: review.toJson(),
        requestName: 'submitVendorReview',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchVendorReviews(context: context, vendorId: vendorId);
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
} 