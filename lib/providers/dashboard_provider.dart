import 'dart:io';
import 'package:flutter/material.dart';
import '../resources/constants/connectivity.dart';
import '../services/api_client.dart';

class DashboardProvider extends ChangeNotifier {
  String inboxTab = "";

  String resMessage = "";
  void clear() {
    resMessage = "";
    notifyListeners();
  }

  String reservedFilter = "";
  String searchFilter = "";

  bool showSearchFilter = false;
  void updateSearchFilter({bool isReset = true, String filter = ""}) {
    if (isReset) {
      searchFilter = reservedFilter;
    } else {
      searchFilter = filter;
    }
    notifyListeners();
  }

  bool gettingDashboardInfo = false;
  Future<bool> getDashboardInfo({
    required BuildContext context,
    bool isFilter = false,
    String filter = "",
  }) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (isFilter) {
      //   Reset Dashboard
    }
    if (connected) {
      String url = isFilter ? "helpers/home/page?$filter" : "helpers/home/page";
      debugPrint("Get Dashboard Info URL:::: $url");

      try {
        if (context.mounted) {
          (bool, String) requestFetched = await ApiClient().getRequest(
              url.replaceAll(",", ""),
              context: context,
              printResponseBody: false,
              requestName: "getDashboardInfo ");
          gettingDashboardInfo = false;
          if (requestFetched.$1) {
            fetched = true;
            notifyListeners();
          } else {
            gettingDashboardInfo = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        resMessage = "Internet connection is not available";
        gettingDashboardInfo = false;
        notifyListeners();
      } catch (e) {
        resMessage = "Please try again";
        gettingDashboardInfo = false;
        debugPrint("Get Canines Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      resMessage = "Internet connection is not available";
      gettingDashboardInfo = false;
      notifyListeners();
    }
    return fetched;
  }
}
