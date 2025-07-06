import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import '../services/api_client.dart';
import 'dart:convert';

class PaymentMethodsProvider extends ChangeNotifier {
  List<PaymentMethodModel> paymentMethods = [];
  bool loading = false;
  String errorMessage = '';

  Future<void> getPaymentMethods({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'users/me/payment-methods',
        context: context,
        requestName: 'getPaymentMethods',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        paymentMethods = PaymentMethodModel.listFromJson(response.$2);
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

  Future<bool> addPaymentMethod({required BuildContext context, required Map<String, dynamic> cardData}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'users/me/payment-methods',
        context: context,
        body: cardData,
        requestName: 'addPaymentMethod',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        final newCard = PaymentMethodModel.fromJson(json.decode(response.$2));
        paymentMethods.add(newCard);
        notifyListeners();
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

  Future<bool> deletePaymentMethod({required BuildContext context, required String cardId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().deleteRequest(
        'users/me/payment-methods/$cardId',
        context: context,
        requestName: 'deletePaymentMethod',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        paymentMethods.removeWhere((c) => c.id == cardId);
        notifyListeners();
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

  Future<bool> setDefaultCard({required BuildContext context, required String cardId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/payment-methods/$cardId/default',
        context: context,
        body: {},
        requestName: 'setDefaultCard',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        for (var c in paymentMethods) {
          c.isDefault = false;
        }
        final idx = paymentMethods.indexWhere((c) => c.id == cardId);
        if (idx != -1) {
          paymentMethods[idx] = PaymentMethodModel(
            id: paymentMethods[idx].id,
            cardNumber: paymentMethods[idx].cardNumber,
            cardType: paymentMethods[idx].cardType,
            expiryMonth: paymentMethods[idx].expiryMonth,
            expiryYear: paymentMethods[idx].expiryYear,
            cardHolderName: paymentMethods[idx].cardHolderName,
            last4: paymentMethods[idx].last4,
            brand: paymentMethods[idx].brand,
            createdAt: paymentMethods[idx].createdAt,
            isDefault: true,
          );
        }
        notifyListeners();
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