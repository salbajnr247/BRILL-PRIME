
import 'package:flutter/foundation.dart';
import '../models/commodities_model.dart';
import '../services/api_client.dart';

class BulkManagementProvider extends ChangeNotifier {
  List<CommodityData> _selectedItems = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _selectAll = false;

  List<CommodityData> get selectedItems => _selectedItems;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get selectAll => _selectAll;
  int get selectedCount => _selectedItems.length;

  void toggleItemSelection(CommodityData item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  void toggleSelectAll(List<CommodityData> allItems) {
    _selectAll = !_selectAll;
    if (_selectAll) {
      _selectedItems = List.from(allItems);
    } else {
      _selectedItems.clear();
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    _selectAll = false;
    notifyListeners();
  }

  bool isItemSelected(CommodityData item) {
    return _selectedItems.contains(item);
  }

  Future<bool> bulkUpdatePrices(double newPrice) async {
    if (_selectedItems.isEmpty) return false;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final itemIds = _selectedItems.map((item) => item.id).toList();
      final response = await ApiClient().postRequest(
        'commodities/bulk-update-prices',
        body: {
          'item_ids': itemIds,
          'new_price': newPrice,
        },
        requestName: 'bulkUpdatePrices',
      );

      _isLoading = false;
      if (response.$1) {
        clearSelection();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkUpdateStock(int newStock) async {
    if (_selectedItems.isEmpty) return false;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final itemIds = _selectedItems.map((item) => item.id).toList();
      final response = await ApiClient().postRequest(
        'commodities/bulk-update-stock',
        body: {
          'item_ids': itemIds,
          'new_stock': newStock,
        },
        requestName: 'bulkUpdateStock',
      );

      _isLoading = false;
      if (response.$1) {
        clearSelection();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkDelete() async {
    if (_selectedItems.isEmpty) return false;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final itemIds = _selectedItems.map((item) => item.id).toList();
      final response = await ApiClient().deleteRequest(
        'commodities/bulk-delete',
        body: {'item_ids': itemIds},
        requestName: 'bulkDelete',
      );

      _isLoading = false;
      if (response.$1) {
        clearSelection();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkToggleStatus(bool isActive) async {
    if (_selectedItems.isEmpty) return false;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final itemIds = _selectedItems.map((item) => item.id).toList();
      final response = await ApiClient().patchRequest(
        'commodities/bulk-toggle-status',
        body: {
          'item_ids': itemIds,
          'is_active': isActive,
        },
        requestName: 'bulkToggleStatus',
      );

      _isLoading = false;
      if (response.$1) {
        clearSelection();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
