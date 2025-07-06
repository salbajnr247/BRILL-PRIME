import 'dart:io';
import 'dart:convert';

import 'package:brill_prime/models/category_model.dart';
import 'package:brill_prime/models/commodities_model.dart';
import 'package:flutter/material.dart';

import '../models/customer_order_detail_model.dart';
import '../models/vendor_order_model.dart';
import '../resources/constants/connectivity.dart';
import '../services/api_client.dart';

class VendorProvider extends ChangeNotifier {
  CategoryData? selectedSubCategory;
  void updateSelectedSubCategory(CategoryData? commodity) {
    selectedSubCategory = commodity;
    notifyListeners();
  }

  String _resMessage = "";
  String get resMessage => _resMessage;
  void clear() {
    _resMessage = "";
    notifyListeners();
  }

  String? selectedUnitOfItem;

  void updateSelectedUnitOfItem(String? unit) {
    selectedUnitOfItem = unit;
    notifyListeners();
  }

  CommodityData? selectedCommodity;
  void updateSelectedCommodity(CommodityData? commodityData) {
    selectedCommodity = commodityData;
    notifyListeners();
  }

  bool gettingVendorCommodities = false;
  List<CommodityData> vendorCommodities = [];
  Future<bool> getVendorCommodities(
      {required BuildContext context, required String vendorId}) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      gettingVendorCommodities = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest(
              "commodities/vendor/$vendorId",
              context: context,
              printResponseBody: true,
              requestName: "getVendorCommodities");
          if (requestResponse.$1) {
            vendorCommodities = commodityModelFromJson(requestResponse.$2).data;
            fetched = true;
            gettingVendorCommodities = false;
            notifyListeners();
          } else {
            gettingVendorCommodities = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingVendorCommodities = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingVendorCommodities = false;
        debugPrint("getVendorCommodities Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingVendorCommodities = false;
      notifyListeners();
    }
    return fetched;
  }

  bool gettingSingleOrder = false;
  CustomerOrderDetailData? selectedOrder;
  Future<bool> getConsumerSingleOrders(
      {required BuildContext context, required String orderId}) async {
    debugPrint("getConsumerSingleOrders called======");
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      gettingSingleOrder = true;
      notifyListeners();
      try {
        if (!context.mounted) return false;
        (bool, String) requestResponse = await ApiClient().getRequest(
            "orders/$orderId",
            context: context,
            printResponseBody: true,
            requestName: "getConsumerSingleOrders");
        gettingSingleOrder = false;
        notifyListeners();
        if (requestResponse.$1) {
          selectedOrder =
              consumerOrderDetailModelFromJson(requestResponse.$2).data;
          fetched = true;
          gettingSingleOrder = false;
          notifyListeners();
        } else {
          gettingSingleOrder = false;
          notifyListeners();
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingSingleOrder = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingSingleOrder = false;
        debugPrint("getConsumerOrders Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingSingleOrder = false;
      notifyListeners();
    }
    return fetched;
  }

  List<VendorOrderData> vendorOrders = [];
  bool gettingVendorOrders = false;
  Future<bool> getVendorOrders({required BuildContext context}) async {
    notifyListeners();
    bool fetched = false;
    if (vendorOrders.isEmpty) {
      gettingVendorOrders = true;
      notifyListeners();
    }
    final connected = await connectionChecker();
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest(
              "orders/vendor-orders",
              context: context,
              printResponseBody: true,
              requestName: "getVendorOrders");
          if (requestResponse.$1) {
            vendorOrders = vendorOrderModelFromJson(requestResponse.$2).data;
            fetched = true;
            gettingVendorOrders = false;
            notifyListeners();
          } else {
            gettingVendorOrders = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingVendorOrders = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingVendorOrders = false;
        debugPrint("getVendorCommodities Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingVendorOrders = false;
      notifyListeners();
    }
    return fetched;
  }

  bool confirmingOrder = false;
  Future<bool> confirmOrder(
      {required BuildContext context,
      required dynamic txRef,
      required dynamic transactionId}) async {
    notifyListeners();
    bool fetched = false;
    confirmingOrder = true;
    notifyListeners();
    final body = {
      "txRef": txRef.toString().replaceAll("order-", ""),
      "transactionId": transactionId.toString().replaceAll("order-", "")
    };
    final connected = await connectionChecker();
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().postRequest(
              "orders/confirm-order",
              context: context,
              body: body,
              printResponseBody: true,
              requestName: "confirmOrder");

          debugPrint("Confirm Order Payload is:::: $body");
          confirmingOrder = false;
          if (requestResponse.$1) {
            fetched = true;
            notifyListeners();
          } else {
            _resMessage = requestResponse.$2;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        confirmingOrder = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        confirmingOrder = false;
        debugPrint("placeOrder Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      confirmingOrder = false;
      notifyListeners();
    }
    return fetched;
  }

  bool addingCommodity = false;
  Future<bool> addCommodity(
      {required BuildContext context,
      required String commodityName,
      required String price,
      required String unit,
      required String description,
      required dynamic quantity,
      required String category,
      required String imageURL,
      required}) async {
    bool isRegistered = false;
    final connected = await connectionChecker();

    if (context.mounted && connected) {
      addingCommodity = true;
      notifyListeners();
      final body = {
        "name": commodityName,
        "price": price,
        "imageUrl": imageURL,
        "unit": unit,
        "description": description,
        "quantity": quantity,
        "category": category
      };

      debugPrint("Add Commodity Payload::::$body");

      (bool, String) registerUserRequest = await ApiClient().postRequest(
          "commodities/add",
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "addCommodity");
      if (registerUserRequest.$1) {
        isRegistered = true;
        addingCommodity = false;
        _resMessage = "Commodity added successfully";
        notifyListeners();
      } else {
        _resMessage = registerUserRequest.$2;
        addingCommodity = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      addingCommodity = false;
      notifyListeners();
    }
    return isRegistered;
  }

  bool updatingCommodity = false;
  Future<bool> updateCommodity(
      {required BuildContext context,
      required String commodityName,
      required String price,
      required String unit,
      required String description,
      required dynamic quantity,
      required String category,
      required dynamic commodityId,
      required String imageURL,
      required}) async {
    bool updated = false;
    final connected = await connectionChecker();

    if (context.mounted && connected) {
      updatingCommodity = true;
      notifyListeners();
      final body = {
        "name": commodityName,
        "price": price,
        "imageUrl": imageURL,
        "unit": unit,
        "description": description,
        "quantity": quantity,
        "category": category
      };

      debugPrint("Add Commodity Payload::::$body");

      (bool, String) registerUserRequest = await ApiClient().postRequest(
          "commodities/update/$commodityId",
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "updateCommodity");
      updatingCommodity = false;
      notifyListeners();
      if (registerUserRequest.$1) {
        updated = true;
        addingCommodity = false;
        _resMessage = "Commodity updated successfully";
        notifyListeners();
      } else {
        _resMessage = registerUserRequest.$2;
        updatingCommodity = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      updatingCommodity = false;
      notifyListeners();
    }
    return updated;
  }

  bool deletingCommodity = false;
  Future<bool> deleteCommodity(
      {required BuildContext context,
      required dynamic commodityId,
      required}) async {
    bool isRegistered = false;
    final connected = await connectionChecker();

    if (context.mounted && connected) {
      deletingCommodity = true;
      notifyListeners();

      (bool, String) registerUserRequest = await ApiClient().deleteRequest(
          "commodities/remove/$commodityId",
          context: context,
          printResponseBody: true,
          requestName: "deleteCommodity");
      deletingCommodity = false;
      notifyListeners();
      if (registerUserRequest.$1) {
        isRegistered = true;
        deletingCommodity = false;
        _resMessage = "Commodity deleted successfully";
        notifyListeners();
      } else {
        _resMessage = registerUserRequest.$2;
        deletingCommodity = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      deletingCommodity = false;
      notifyListeners();
    }
    return isRegistered;
  }

  // Vendor dashboard data
  Map<String, dynamic>? dashboardData;
  bool loadingDashboard = false;
  Future<bool> getVendorDashboard({required BuildContext context}) async {
    loadingDashboard = true;
    notifyListeners();
    final connected = await connectionChecker();
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) response = await ApiClient().getRequest(
            'vendors/me/dashboard',
            context: context,
            printResponseBody: true,
            requestName: 'getVendorDashboard',
          );
          loadingDashboard = false;
          if (response.$1) {
            dashboardData = response.$2 is String ? Map<String, dynamic>.from(json.decode(response.$2)) : response.$2;
            notifyListeners();
            return true;
          } else {
            _resMessage = response.$2;
            notifyListeners();
            return false;
          }
        }
      } catch (e) {
        _resMessage = e.toString();
        loadingDashboard = false;
        notifyListeners();
        return false;
      }
    } else {
      _resMessage = "Internet connection is not available";
      loadingDashboard = false;
      notifyListeners();
      return false;
    }
    return false;
  }

  // Vendor profile update
  bool updatingVendorProfile = false;
  Future<bool> updateVendorProfile({
    required BuildContext context,
    required Map<String, dynamic> updateData,
  }) async {
    updatingVendorProfile = true;
    notifyListeners();
    final connected = await connectionChecker();
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) response = await ApiClient().patchRequest(
            'vendors/me',
            context: context,
            body: updateData,
            printResponseBody: true,
            requestName: 'updateVendorProfile',
          );
          updatingVendorProfile = false;
          if (response.$1) {
            notifyListeners();
            return true;
          } else {
            _resMessage = response.$2;
            notifyListeners();
            return false;
          }
        }
      } catch (e) {
        _resMessage = e.toString();
        updatingVendorProfile = false;
        notifyListeners();
        return false;
      }
    } else {
      _resMessage = "Internet connection is not available";
      updatingVendorProfile = false;
      notifyListeners();
      return false;
    }
    return false;
  }
}

final List<String> unitOfItems = ["Litre", "Ticket"];
