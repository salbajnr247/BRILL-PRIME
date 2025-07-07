
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (total, item) => total + item.totalPrice);
  
  int get vendorCount => _items.map((item) => item.vendorId).toSet().length;

  // Group items by vendor
  Map<String, List<CartItem>> get itemsByVendor {
    Map<String, List<CartItem>> groupedItems = {};
    for (var item in _items) {
      if (!groupedItems.containsKey(item.vendorId)) {
        groupedItems[item.vendorId] = [];
      }
      groupedItems[item.vendorId]!.add(item);
    }
    return groupedItems;
  }

  CartProvider() {
    _loadCartFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_items');
      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', cartData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.commodityId == item.commodityId,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    
    _saveCartToStorage();
    notifyListeners();
  }

  void removeItem(String commodityId) {
    _items.removeWhere((item) => item.commodityId == commodityId);
    _saveCartToStorage();
    notifyListeners();
  }

  void updateQuantity(String commodityId, int quantity) {
    if (quantity <= 0) {
      removeItem(commodityId);
      return;
    }

    final index = _items.indexWhere((item) => item.commodityId == commodityId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void increaseQuantity(String commodityId) {
    final index = _items.indexWhere((item) => item.commodityId == commodityId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void decreaseQuantity(String commodityId) {
    final index = _items.indexWhere((item) => item.commodityId == commodityId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCartToStorage();
    notifyListeners();
  }

  void clearVendorItems(String vendorId) {
    _items.removeWhere((item) => item.vendorId == vendorId);
    _saveCartToStorage();
    notifyListeners();
  }

  bool isInCart(String commodityId) {
    return _items.any((item) => item.commodityId == commodityId);
  }

  CartItem? getCartItem(String commodityId) {
    try {
      return _items.firstWhere((item) => item.commodityId == commodityId);
    } catch (e) {
      return null;
    }
  }

  double getVendorTotal(String vendorId) {
    return _items
        .where((item) => item.vendorId == vendorId)
        .fold(0.0, (total, item) => total + item.totalPrice);
  }

  List<CartItem> getVendorItems(String vendorId) {
    return _items.where((item) => item.vendorId == vendorId).toList();
  }

  // Save for later functionality
  List<CartItem> _savedItems = [];
  List<CartItem> get savedItems => _savedItems;

  // Guest checkout functionality
  bool _isGuestCheckout = false;
  bool get isGuestCheckout => _isGuestCheckout;

  // Cart session management
  String? _cartSessionId;
  String? get cartSessionId => _cartSessionId;

  void saveForLater(String commodityId) {
    final index = _items.indexWhere((item) => item.commodityId == commodityId);
    if (index >= 0) {
      _savedItems.add(_items[index]);
      _items.removeAt(index);
      _saveCartToStorage();
      _saveSavedItemsToStorage();
      notifyListeners();
    }
  }

  void moveToCart(String commodityId) {
    final index = _savedItems.indexWhere((item) => item.commodityId == commodityId);
    if (index >= 0) {
      addItem(_savedItems[index]);
      _savedItems.removeAt(index);
      _saveSavedItemsToStorage();
    }
  }

  void removeSavedItem(String commodityId) {
    _savedItems.removeWhere((item) => item.commodityId == commodityId);
    _saveSavedItemsToStorage();
    notifyListeners();
  }

  void clearSavedItems() {
    _savedItems.clear();
    _saveSavedItemsToStorage();
    notifyListeners();
  }

  // Guest checkout methods
  void enableGuestCheckout() {
    _isGuestCheckout = true;
    _cartSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _saveCartToStorage();
    notifyListeners();
  }

  void disableGuestCheckout() {
    _isGuestCheckout = false;
    _cartSessionId = null;
    _saveCartToStorage();
    notifyListeners();
  }

  // Enhanced persistence methods
  Future<void> _loadCartFromStorage() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load cart items
      final cartData = prefs.getString('cart_items');
      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
      }
      
      // Load saved items
      final savedData = prefs.getString('saved_items');
      if (savedData != null) {
        final List<dynamic> decodedSavedData = json.decode(savedData);
        _savedItems = decodedSavedData.map((item) => CartItem.fromJson(item)).toList();
      }
      
      // Load guest checkout status
      _isGuestCheckout = prefs.getBool('is_guest_checkout') ?? false;
      _cartSessionId = prefs.getString('cart_session_id');
      
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', cartData);
      await prefs.setBool('is_guest_checkout', _isGuestCheckout);
      if (_cartSessionId != null) {
        await prefs.setString('cart_session_id', _cartSessionId!);
      }
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _saveSavedItemsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = json.encode(_savedItems.map((item) => item.toJson()).toList());
      await prefs.setString('saved_items', savedData);
    } catch (e) {
      debugPrint('Error saving saved items: $e');
    }
  }

  // Merge guest cart with user cart on login
  Future<void> mergeGuestCartWithUserCart() async {
    if (_isGuestCheckout && _items.isNotEmpty) {
      // Here you would typically sync with your backend
      // For now, we'll just disable guest mode
      _isGuestCheckout = false;
      _cartSessionId = null;
      _saveCartToStorage();
      notifyListeners();
    }
  }

  // Cart expiry management
  Future<void> checkCartExpiry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSavedTime = prefs.getInt('cart_last_saved') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final daysDifference = (currentTime - lastSavedTime) / (1000 * 60 * 60 * 24);
      
      // Clear cart if older than 30 days
      if (daysDifference > 30) {
        clearCart();
        clearSavedItems();
      }
    } catch (e) {
      debugPrint('Error checking cart expiry: $e');
    }
  }

  // Enhanced cart statistics
  Map<String, dynamic> getCartStatistics() {
    final totalItems = itemCount;
    final totalValue = totalAmount;
    final uniqueProducts = _items.length;
    final vendorCount = this.vendorCount;
    
    return {
      'totalItems': totalItems,
      'totalValue': totalValue,
      'uniqueProducts': uniqueProducts,
      'vendorCount': vendorCount,
      'savedItemsCount': _savedItems.length,
      'isGuestCheckout': _isGuestCheckout,
      'cartSessionId': _cartSessionId,
    };
  }
}
