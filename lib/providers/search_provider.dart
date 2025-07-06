import 'package:flutter/material.dart';
import '../models/commodities_model.dart';
import '../models/vendor_model.dart';
import '../services/api_client.dart';

class SearchProvider extends ChangeNotifier {
  List<CommodityData> productResults = [];
  List<Vendor> vendorResults = [];
  bool loading = false;
  String errorMessage = '';

  Future<void> searchProducts({
    required BuildContext context,
    String query = '',
    String sort = '',
    String filter = '',
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      String endpoint = 'products?search=$query';
      if (sort.isNotEmpty) endpoint += '&sort=$sort';
      if (filter.isNotEmpty) endpoint += '&filter=$filter';
      (bool, String) response = await ApiClient().getRequest(
        endpoint,
        context: context,
        requestName: 'searchProducts',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        productResults = commodityModelFromJson(response.$2).data;
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

  Future<void> searchVendors({
    required BuildContext context,
    String query = '',
    String sort = '',
    String filter = '',
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      String endpoint = 'vendors?search=$query';
      if (sort.isNotEmpty) endpoint += '&sort=$sort';
      if (filter.isNotEmpty) endpoint += '&filter=$filter';
      (bool, String) response = await ApiClient().getRequest(
        endpoint,
        context: context,
        requestName: 'searchVendors',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        vendorResults = vendorModelFromJson(response.$2).data;
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
} 