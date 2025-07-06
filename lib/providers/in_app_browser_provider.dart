import 'package:flutter/material.dart';

class InAppBrowserProvider extends ChangeNotifier {
  String _resMessage = "";
  String get resMessage => _resMessage;

  String _urlToBrowse = "";
  String get urlToBrowse => _urlToBrowse;

  String pageTitle = "Payment";

  void updateURLToBrowser(String url, {String title = "Payment"}) {
    _urlToBrowse = url.startsWith("https:") ? url : "https://$url";
    pageTitle = title;
    notifyListeners();
  }

  bool _canGoBack = false;
  bool get canGoBack => _canGoBack;

  bool _canGoForward = false;
  bool get canGoForward => _canGoForward;

  void updateCanGoBack(bool newValue) {
    _canGoBack = newValue;
    debugPrint("Can Go Back $_canGoBack");
    notifyListeners();
  }

  void updateCanGoForward(bool newValue) {
    _canGoForward = newValue;
    debugPrint("Can Go Forward $_canGoBack");
    notifyListeners();
  }

  void clear() {
    _resMessage = "";
    notifyListeners();
  }
}
