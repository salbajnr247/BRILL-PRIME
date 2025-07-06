import 'package:flutter/material.dart';
import '../models/favourite_model.dart';
import '../services/api_client.dart';

class FavouritesProvider extends ChangeNotifier {
  List<FavouriteModel> favourites = [];
  bool loading = false;
  String errorMessage = '';

  Future<void> fetchFavourites({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'users/me/favourites',
        context: context,
        requestName: 'fetchFavourites',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        favourites = FavouriteModel.listFromJson(response.$2);
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

  Future<bool> addFavourite({required BuildContext context, required FavouriteModel favourite}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'users/me/favourites',
        context: context,
        body: favourite.toJson(),
        requestName: 'addFavourite',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchFavourites(context: context);
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

  Future<bool> removeFavourite({required BuildContext context, required String favouriteId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().deleteRequest(
        'users/me/favourites/$favouriteId',
        context: context,
        requestName: 'removeFavourite',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchFavourites(context: context);
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