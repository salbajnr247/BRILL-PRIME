import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../services/api_client.dart';

class AddressBookProvider extends ChangeNotifier {
  List<AddressModel> addresses = [];
  bool loading = false;
  String errorMessage = '';

  Future<void> fetchAddresses({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'users/me/addresses',
        context: context,
        requestName: 'fetchAddresses',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        addresses = AddressModel.listFromJson(response.$2);
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

  Future<bool> addAddress({required BuildContext context, required AddressModel address}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'users/me/addresses',
        context: context,
        body: address.toJson(),
        requestName: 'addAddress',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchAddresses(context: context);
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

  Future<bool> updateAddress({required BuildContext context, required AddressModel address}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().putRequest(
        'users/me/addresses/${address.id}',
        context: context,
        body: address.toJson(),
        requestName: 'updateAddress',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchAddresses(context: context);
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

  Future<bool> deleteAddress({required BuildContext context, required String addressId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().deleteRequest(
        'users/me/addresses/$addressId',
        context: context,
        requestName: 'deleteAddress',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchAddresses(context: context);
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

  Future<bool> setDefaultAddress({required BuildContext context, required String addressId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/addresses/$addressId/default',
        context: context,
        body: {},
        requestName: 'setDefaultAddress',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchAddresses(context: context);
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