
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/commodities_model.dart';
import '../models/vendor_model.dart';
import '../services/api_client.dart';

class SearchFilter {
  final String category;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final double? rating;
  final String? sortBy;
  final bool? inStock;

  SearchFilter({
    this.category = '',
    this.minPrice,
    this.maxPrice,
    this.location,
    this.rating,
    this.sortBy,
    this.inStock,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'location': location,
    'rating': rating,
    'sortBy': sortBy,
    'inStock': inStock,
  };

  factory SearchFilter.fromJson(Map<String, dynamic> json) => SearchFilter(
    category: json['category'] ?? '',
    minPrice: json['minPrice']?.toDouble(),
    maxPrice: json['maxPrice']?.toDouble(),
    location: json['location'],
    rating: json['rating']?.toDouble(),
    sortBy: json['sortBy'],
    inStock: json['inStock'],
  );
}

class SavedSearch {
  final String id;
  final String query;
  final SearchFilter filter;
  final DateTime createdAt;
  final String name;

  SavedSearch({
    required this.id,
    required this.query,
    required this.filter,
    required this.createdAt,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'query': query,
    'filter': filter.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'name': name,
  };

  factory SavedSearch.fromJson(Map<String, dynamic> json) => SavedSearch(
    id: json['id'],
    query: json['query'],
    filter: SearchFilter.fromJson(json['filter']),
    createdAt: DateTime.parse(json['createdAt']),
    name: json['name'],
  );
}

class SearchProvider extends ChangeNotifier {
  List<CommodityData> productResults = [];
  List<Vendor> vendorResults = [];
  List<CommodityData> recommendedProducts = [];
  List<CommodityData> trendingProducts = [];
  List<SavedSearch> savedSearches = [];
  List<String> searchHistory = [];
  
  bool loading = false;
  String errorMessage = '';
  SearchFilter currentFilter = SearchFilter();

  SearchProvider() {
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load search history
      final historyData = prefs.getStringList('search_history') ?? [];
      searchHistory = historyData;
      
      // Load saved searches
      final savedData = prefs.getString('saved_searches');
      if (savedData != null) {
        final List<dynamic> decodedData = json.decode(savedData);
        savedSearches = decodedData.map((item) => SavedSearch.fromJson(item)).toList();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved search data: $e');
    }
  }

  Future<void> _saveSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', searchHistory);
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  Future<void> _saveSavedSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searchData = json.encode(savedSearches.map((item) => item.toJson()).toList());
      await prefs.setString('saved_searches', searchData);
    } catch (e) {
      debugPrint('Error saving saved searches: $e');
    }
  }

  void addToSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    
    searchHistory.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    searchHistory.insert(0, query);
    
    if (searchHistory.length > 20) {
      searchHistory = searchHistory.take(20).toList();
    }
    
    _saveSearchHistory();
    notifyListeners();
  }

  void clearSearchHistory() {
    searchHistory.clear();
    _saveSearchHistory();
    notifyListeners();
  }

  void removeFromSearchHistory(String query) {
    searchHistory.remove(query);
    _saveSearchHistory();
    notifyListeners();
  }

  Future<void> saveCurrentSearch(String name, String query) async {
    final savedSearch = SavedSearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      query: query,
      filter: currentFilter,
      createdAt: DateTime.now(),
      name: name,
    );
    
    savedSearches.insert(0, savedSearch);
    await _saveSavedSearches();
    notifyListeners();
  }

  void removeSavedSearch(String id) {
    savedSearches.removeWhere((search) => search.id == id);
    _saveSavedSearches();
    notifyListeners();
  }

  void updateFilter(SearchFilter filter) {
    currentFilter = filter;
    notifyListeners();
  }

  Future<void> searchProducts({
    required BuildContext context,
    String query = '',
    SearchFilter? filter,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();

    try {
      if (query.isNotEmpty) {
        addToSearchHistory(query);
      }

      final searchFilter = filter ?? currentFilter;
      String endpoint = 'products?search=$query';
      
      if (searchFilter.category.isNotEmpty) {
        endpoint += '&category=${searchFilter.category}';
      }
      if (searchFilter.minPrice != null) {
        endpoint += '&min_price=${searchFilter.minPrice}';
      }
      if (searchFilter.maxPrice != null) {
        endpoint += '&max_price=${searchFilter.maxPrice}';
      }
      if (searchFilter.location != null) {
        endpoint += '&location=${searchFilter.location}';
      }
      if (searchFilter.rating != null) {
        endpoint += '&min_rating=${searchFilter.rating}';
      }
      if (searchFilter.sortBy != null) {
        endpoint += '&sort=${searchFilter.sortBy}';
      }
      if (searchFilter.inStock != null) {
        endpoint += '&in_stock=${searchFilter.inStock}';
      }

      final response = await ApiClient().getRequest(
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
    SearchFilter? filter,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();

    try {
      if (query.isNotEmpty) {
        addToSearchHistory(query);
      }

      final searchFilter = filter ?? currentFilter;
      String endpoint = 'vendors?search=$query';
      
      if (searchFilter.location != null) {
        endpoint += '&location=${searchFilter.location}';
      }
      if (searchFilter.rating != null) {
        endpoint += '&min_rating=${searchFilter.rating}';
      }
      if (searchFilter.sortBy != null) {
        endpoint += '&sort=${searchFilter.sortBy}';
      }

      final response = await ApiClient().getRequest(
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

  Future<void> fetchRecommendations({required BuildContext context}) async {
    try {
      final response = await ApiClient().getRequest(
        'products/recommendations',
        context: context,
        requestName: 'fetchRecommendations',
        printResponseBody: true,
      );

      if (response.$1) {
        recommendedProducts = commodityModelFromJson(response.$2).data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
    }
  }

  Future<void> fetchTrendingProducts({required BuildContext context}) async {
    try {
      final response = await ApiClient().getRequest(
        'products/trending',
        context: context,
        requestName: 'fetchTrendingProducts',
        printResponseBody: true,
      );

      if (response.$1) {
        trendingProducts = commodityModelFromJson(response.$2).data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching trending products: $e');
    }
  }

  void clearResults() {
    productResults.clear();
    vendorResults.clear();
    notifyListeners();
  }
}
