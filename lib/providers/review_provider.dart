import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/api_client.dart';
import 'dart:convert';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> productReviews = [];
  List<ReviewModel> vendorReviews = [];
  bool loading = false;
  String errorMessage = '';
  List<PhotoReview> photoReviews = [];
  List<ReviewModel> pendingReviews = [];
  final Map<String, double> _averageRatings = {};
  final Map<String, int> _reviewCounts = {};

  double getAverageRating(String itemId) {
    return _averageRatings[itemId] ?? 0.0;
  }

  int getReviewCount(String itemId) {
    return _reviewCounts[itemId] ?? 0;
  }

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
        _updateRatingStats(productReviews, productId);
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
        _updateRatingStats(vendorReviews, vendorId);
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

  Future<bool> submitProductReview({
    required BuildContext context,
    required String productId,
    required ReviewModel review,
    List<String>? photoUrls,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      Map<String, dynamic> reviewData = review.toJson();
      if (photoUrls != null && photoUrls.isNotEmpty) {
        reviewData['photoUrls'] = photoUrls;
      }

      (bool, String) response = await ApiClient().postRequest(
        'products/$productId/reviews',
        context: context,
        body: reviewData,
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

  Future<bool> submitVendorReview({
    required BuildContext context,
    required String vendorId,
    required ReviewModel review,
    List<String>? photoUrls,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      Map<String, dynamic> reviewData = review.toJson();
      if (photoUrls != null && photoUrls.isNotEmpty) {
        reviewData['photoUrls'] = photoUrls;
      }

      (bool, String) response = await ApiClient().postRequest(
        'vendors/$vendorId/reviews',
        context: context,
        body: reviewData,
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

  Future<void> fetchPhotoReviews({
    required BuildContext context,
    required String itemId,
    required String itemType,
  }) async {
    try {
      (bool, String) response = await ApiClient().getRequest(
        '$itemType/$itemId/reviews/photos',
        context: context,
        requestName: 'fetchPhotoReviews',
        printResponseBody: true,
      );
      if (response.$1) {
        final List<dynamic> data = json.decode(response.$2);
        photoReviews = data.map((item) => PhotoReview.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching photo reviews: $e');
    }
  }

  Future<void> fetchPendingReviews({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'admin/reviews/pending',
        context: context,
        requestName: 'fetchPendingReviews',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        pendingReviews = ReviewModel.listFromJson(response.$2);
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

  Future<bool> moderateReview({
    required BuildContext context,
    required String reviewId,
    required bool approve,
    String? reason,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'admin/reviews/$reviewId/moderate',
        context: context,
        body: {
          'approve': approve,
          'reason': reason,
        },
        requestName: 'moderateReview',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchPendingReviews(context: context);
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

  Future<bool> reportReview({
    required BuildContext context,
    required String reviewId,
    required String reason,
  }) async {
    try {
      (bool, String) response = await ApiClient().postRequest(
        'reviews/$reviewId/report',
        context: context,
        body: {'reason': reason},
        requestName: 'reportReview',
        printResponseBody: true,
      );
      return response.$1;
    } catch (e) {
      debugPrint('Error reporting review: $e');
      return false;
    }
  }

  void _updateRatingStats(List<ReviewModel> reviews, String itemId) {
    if (reviews.isNotEmpty) {
      final average = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      _averageRatings[itemId] = average;
      _reviewCounts[itemId] = reviews.length;
    }
  }
}

class PhotoReview {
  final String url;
  final String reviewId;

  PhotoReview({
    required this.url,
    required this.reviewId,
  });

  factory PhotoReview.fromJson(Map<String, dynamic> json) {
    return PhotoReview(
      url: json['url'],
      reviewId: json['reviewId'],
    );
  }
}