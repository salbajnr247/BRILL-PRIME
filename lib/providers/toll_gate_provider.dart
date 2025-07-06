import 'dart:io';

import 'package:brill_prime/models/cart_model.dart';
import 'package:brill_prime/models/category_model.dart';
import 'package:brill_prime/models/order_placed_model.dart';
import 'package:brill_prime/models/user_profile_model.dart';
import 'package:brill_prime/models/vendor_model.dart';
import 'package:flutter/material.dart';
import '../models/commodities_model.dart';
import '../models/consumer_order_model.dart';
import '../models/customer_order_detail_model.dart';
import '../models/payment_verified_model.dart';
import '../resources/constants/connectivity.dart';
import '../services/api_client.dart';

class TollGateProvider extends ChangeNotifier {
  bool isError = true;

  Vendor? selectedVendor;

  void updateSelectedTollGate({Vendor? vendor}) {
    selectedVendor = vendor;
    notifyListeners();
  }

  int quantity = 1;

  double pricePerGate = 800;

  void updateQuantity({bool isIncrease = true}) {
    if (isIncrease) {
      quantity++;
    } else {
      if (quantity > 1) {
        quantity--;
      }
    }

    notifyListeners();
  }

  bool gettingCommodities = false;
  List<CommodityData> reservedCommodities = [];
  List<CommodityData> commodities = [];
  Future<bool> getCommodities(
      {required BuildContext context, required String category}) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      gettingCommodities = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest(
              "commodities/all",
              context: context,
              printResponseBody: false,
              requestName: "getCommodities");
          commodities = [];
          reservedCommodities = [];
          if (requestResponse.$1) {
            reservedCommodities =
                commodityModelFromJson(requestResponse.$2).data;
            filterCommodities(category: category);
            fetched = true;
            gettingCommodities = false;
            notifyListeners();
          } else {
            gettingCommodities = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingCommodities = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingCommodities = false;
        debugPrint("getVendorCommodities Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingCommodities = false;
      notifyListeners();
    }
    return fetched;
  }

  void updateSelectedOrder(CustomerOrderDetailData? order) {
    selectedOrder = order;
    notifyListeners();
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
        if (!context.mounted) return false;
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

  List<ConsumerOrderData> consumerOrders = [];
  bool gettingConsumerOrders = false;
  Future<bool> getConsumerOrders({required BuildContext context}) async {
    debugPrint("getConsumerOrders called======");
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      gettingConsumerOrders = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest(
              "orders/consumer",
              context: context,
              printResponseBody: true,
              requestName: "getConsumerOrders");
          consumerOrders = [];
          gettingConsumerOrders = false;
          notifyListeners();
          if (requestResponse.$1) {
            consumerOrders =
                consumerOrderModelFromJson(requestResponse.$2).data;
            fetched = true;
            gettingConsumerOrders = false;
            notifyListeners();
          } else {
            gettingConsumerOrders = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingConsumerOrders = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingConsumerOrders = false;
        debugPrint("getConsumerOrders Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingConsumerOrders = false;
      notifyListeners();
    }
    return fetched;
  }

  List<Vendor> vendors = [];
  bool gettingVendors = false;
  Future<bool> getVendors(
      {required BuildContext context, required String category}) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      gettingVendors = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest(
              "user/vendor/category/$category",
              context: context,
              printResponseBody: false,
              requestName: "getVendors");
          vendors = [];
          if (requestResponse.$1) {
            vendors = vendorModelFromJson(requestResponse.$2).data;
            fetched = true;
            gettingVendors = false;
            notifyListeners();
          } else {
            gettingVendors = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingVendors = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingVendors = false;
        debugPrint("getVendors Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingVendors = false;
      notifyListeners();
    }
    return fetched;
  }

  List<CartData> cartItems = [];
  bool gettingCartDetails = false;
  Future<bool> getCartDetails({required BuildContext context}) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      if (cartItems.isEmpty) {
        gettingCartDetails = true;
      }
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().getRequest("cart",
              context: context,
              printResponseBody: true,
              requestName: "getCartDetails");
          cartItems = [];
          if (requestResponse.$1) {
            cartItems = cartModelFromJson(requestResponse.$2).data;
            fetched = true;
            updateTotalAmount();
            gettingCartDetails = false;
            notifyListeners();
          } else {
            gettingCartDetails = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingCartDetails = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingCartDetails = false;
        debugPrint("getCartDetails Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingCartDetails = false;
      notifyListeners();
    }
    return fetched;
  }

  void filterCommodities({required String category}) {
    debugPrint("Filter Commodity method $category");
    commodities = reservedCommodities
        .where((commodity) => commodity.category
            .toString()
            .toLowerCase()
            .contains(category.toLowerCase()))
        .toList();
    notifyListeners();
  }

  CartData? returnCartItem({required String commodityId}) {
    debugPrint("Return Cart Item  method $commodityId");
    CartData? cart = cartItems.firstWhere(
      (cart) =>
          cart.commodityId.toString().toLowerCase() ==
          commodityId.toLowerCase(),
      orElse: () => CartData(
          id: null,
          cartId: null,
          commodityId: commodityId,
          quantity: quantity,
          commodityName: null,
          commodityDescription: null,
          commmodityPrice: null,
          unit: null,
          imageUrl: null,
          vendorId: null), // Return null if no match is found
    );

    debugPrint("The commodity is:::: ${cart.quantity}");
    return cart;
  }

  CategoryData? selectedSubCategory;
  void updateSelectedSubCategory(CategoryData? subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }

  bool addingCart = false;

  dynamic currentCommodityId;
  Future<bool> addCommodityToCart(
      {required BuildContext context, required dynamic commodityId}) async {
    currentCommodityId = commodityId;
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    final body = {"commodityId": commodityId, "quantity": 1};
    debugPrint("addCommodityToCart:::::: $body");
    if (connected) {
      addingCart = true;
      notifyListeners();

      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().postRequest(
              "cart",
              context: context,
              body: body,
              printResponseBody: true,
              requestName: "addCommodityToCart");
          if (!context.mounted) return false;
          addingCart = false;
          if (requestResponse.$1) {
            getCartDetails(context: context);
            fetched = true;
            addingCart = false;
            notifyListeners();
          } else {
            _resMessage = requestResponse.$2;
            addingCart = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        addingCart = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        addingCart = false;
        debugPrint("addCommodityToCart Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      addingCart = false;
      notifyListeners();
    }
    return fetched;
  }

  bool placingOrder = false;

  OrderPlacedModel? orderPlacedModel;
  Future<bool> placeOrder({required BuildContext context}) async {
    notifyListeners();
    bool fetched = false;
    orderPlacedModel = null;
    final connected = await connectionChecker();
    if (connected) {
      placingOrder = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().postRequest(
              "orders",
              context: context,
              body: {},
              printResponseBody: true,
              requestName: "placeOrder");
          if (!context.mounted) return false;
          placingOrder = false;
          if (requestResponse.$1) {
            getCartDetails(context: context);
            fetched = true;
            placingOrder = false;
            orderPlacedModel = orderPlacedModelFromJson(requestResponse.$2);
            debugPrint(
                "Order Placed======================${orderPlacedModel?.data}");
            notifyListeners();
          } else {
            _resMessage = requestResponse.$2;
            placingOrder = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        placingOrder = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        placingOrder = false;
        debugPrint("placeOrder Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      placingOrder = false;
      notifyListeners();
    }
    return fetched;
  }

  PaymentData? _paymentData;
  Future<bool> verifyPayment(
      {required BuildContext context,
      required dynamic txRef,
      required dynamic transactionId,
      required String orderId}) async {
    _paymentData = null;
    notifyListeners();
    bool fetched = false;
    orderPlacedModel = null;
    final connected = await connectionChecker();
    if (connected) {
      placingOrder = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().patchRequest(
              "orders/$orderId/verify",
              context: context,
              body: {"txRef": txRef, "transactionId": transactionId},
              printResponseBody: true,
              requestName: "verifyPayment");
          if (!context.mounted) return false;
          placingOrder = false;
          if (requestResponse.$1) {
            _paymentData =
                paymentVerifiedModelFromJson(requestResponse.$2).data;
            getConsumerSingleOrders(
                context: context, orderId: orderId);
            getCartDetails(context: context);
            fetched = true;
            placingOrder = false;
            notifyListeners();
          } else {
            _resMessage = requestResponse.$2;
            placingOrder = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        placingOrder = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        placingOrder = false;
        debugPrint("verifyPayment Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      placingOrder = false;
      notifyListeners();
    }
    return fetched;
  }

  double totalAmount = 0.0;

  void updateTotalAmount() {
    totalAmount = 0.0;
    for (int i = 0; i < cartItems.length; i++) {
      totalAmount += double.parse(cartItems[i].commmodityPrice.toString()) *
          double.parse(cartItems[i].quantity.toString());
    }
    notifyListeners();
  }

  bool updatingQuantity = false;
  bool isAddQuantity = true;
  Future<bool> updateCommodityQuantityInCart(
      {required BuildContext context,
      required CartData cart,
      bool isCartScreen = false,
      bool isIncrease = true}) async {
    currentCommodityId = isCartScreen ? cart.id : cart.commodityId;
    isAddQuantity = isIncrease;
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    final body = {
      "quantity": isIncrease ? cart.quantity + 1 : cart.quantity - 1
    };

    debugPrint("updateCommodityQuantityInCart Payload:::::: $body");
    if (connected) {
      updatingQuantity = true;
      notifyListeners();

      if (cart.quantity == 1 && !isIncrease) {
        if (context.mounted) {
          await removeItemFromCart(context: context, cart: cart);
        }
        updatingQuantity = false;
        notifyListeners();
      } else {
        try {
          if (context.mounted) {
            (bool, String) requestResponse = await ApiClient().putRequest(
                "cart/${cart.id}",
                context: context,
                body: body,
                requestName: "updateCommodityQuantityInCart",
                printResponseBody: true);
            if (!context.mounted) return false;
            updatingQuantity = false;
            if (requestResponse.$1) {
              getCartDetails(context: context);
              fetched = true;
              updatingQuantity = false;
              notifyListeners();
            } else {
              updatingQuantity = false;
              notifyListeners();
            }
          }
        } on SocketException catch (_) {
          _resMessage = "Internet connection is not available";
          updatingQuantity = false;
          notifyListeners();
        } catch (e) {
          _resMessage = "Please try again";
          updatingQuantity = false;
          debugPrint(
              "updateCommodityQuantityInCart Exception::::::::${e.toString()}");
          notifyListeners();
        }
      }
    } else {
      _resMessage = "Internet connection is not available";
      updatingQuantity = false;
      notifyListeners();
    }
    return fetched;
  }

  bool deletingItemFromCart = false;
  Future<bool> removeItemFromCart(
      {required BuildContext context,
      required CartData cart,
      bool isFromCartScreen = false}) async {
    currentCommodityId = isFromCartScreen ? cart.id : cart.commodityId;
    debugPrint("Delete Cart Item method called======= ");
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();
    if (connected) {
      deletingItemFromCart = true;
      notifyListeners();
      try {
        if (context.mounted) {
          (bool, String) requestResponse = await ApiClient().deleteRequest(
              "cart/${cart.id}",
              context: context,
              printResponseBody: true,
              requestName: "removeItemFromCart");
          if (!context.mounted) return false;
          deletingItemFromCart = false;
          if (requestResponse.$1) {
            getCartDetails(context: context);
            fetched = true;
            deletingItemFromCart = false;
            notifyListeners();
          } else {
            deletingItemFromCart = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        deletingItemFromCart = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        deletingItemFromCart = false;
        debugPrint("removeItemFromCart Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      deletingItemFromCart = false;
      notifyListeners();
    }
    return fetched;
  }

  String _resMessage = "";
  String get resMessage => _resMessage;
  void clear() {
    _resMessage = "";
    notifyListeners();
  }
}
