
import 'dart:convert';

VendorAnalyticsModel vendorAnalyticsModelFromJson(String str) =>
    VendorAnalyticsModel.fromJson(json.decode(str));

String vendorAnalyticsModelToJson(VendorAnalyticsModel data) =>
    json.encode(data.toJson());

class VendorAnalyticsModel {
  bool status;
  String message;
  VendorAnalyticsData data;

  VendorAnalyticsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VendorAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      VendorAnalyticsModel(
        status: json["status"],
        message: json["message"],
        data: VendorAnalyticsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class VendorAnalyticsData {
  SalesMetrics salesMetrics;
  List<ProductPerformance> topProducts;
  List<RevenueData> revenueHistory;
  CustomerMetrics customerMetrics;
  InventoryMetrics inventoryMetrics;

  VendorAnalyticsData({
    required this.salesMetrics,
    required this.topProducts,
    required this.revenueHistory,
    required this.customerMetrics,
    required this.inventoryMetrics,
  });

  factory VendorAnalyticsData.fromJson(Map<String, dynamic> json) =>
      VendorAnalyticsData(
        salesMetrics: SalesMetrics.fromJson(json["salesMetrics"]),
        topProducts: List<ProductPerformance>.from(
            json["topProducts"].map((x) => ProductPerformance.fromJson(x))),
        revenueHistory: List<RevenueData>.from(
            json["revenueHistory"].map((x) => RevenueData.fromJson(x))),
        customerMetrics: CustomerMetrics.fromJson(json["customerMetrics"]),
        inventoryMetrics: InventoryMetrics.fromJson(json["inventoryMetrics"]),
      );

  Map<String, dynamic> toJson() => {
        "salesMetrics": salesMetrics.toJson(),
        "topProducts": List<dynamic>.from(topProducts.map((x) => x.toJson())),
        "revenueHistory": List<dynamic>.from(revenueHistory.map((x) => x.toJson())),
        "customerMetrics": customerMetrics.toJson(),
        "inventoryMetrics": inventoryMetrics.toJson(),
      };
}

class SalesMetrics {
  double totalRevenue;
  int totalOrders;
  double averageOrderValue;
  double revenueGrowth;
  int ordersGrowth;

  SalesMetrics({
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.revenueGrowth,
    required this.ordersGrowth,
  });

  factory SalesMetrics.fromJson(Map<String, dynamic> json) => SalesMetrics(
        totalRevenue: json["totalRevenue"]?.toDouble() ?? 0.0,
        totalOrders: json["totalOrders"] ?? 0,
        averageOrderValue: json["averageOrderValue"]?.toDouble() ?? 0.0,
        revenueGrowth: json["revenueGrowth"]?.toDouble() ?? 0.0,
        ordersGrowth: json["ordersGrowth"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "totalRevenue": totalRevenue,
        "totalOrders": totalOrders,
        "averageOrderValue": averageOrderValue,
        "revenueGrowth": revenueGrowth,
        "ordersGrowth": ordersGrowth,
      };
}

class ProductPerformance {
  String productId;
  String productName;
  int unitsSold;
  double revenue;
  String imageUrl;

  ProductPerformance({
    required this.productId,
    required this.productName,
    required this.unitsSold,
    required this.revenue,
    required this.imageUrl,
  });

  factory ProductPerformance.fromJson(Map<String, dynamic> json) =>
      ProductPerformance(
        productId: json["productId"] ?? "",
        productName: json["productName"] ?? "",
        unitsSold: json["unitsSold"] ?? 0,
        revenue: json["revenue"]?.toDouble() ?? 0.0,
        imageUrl: json["imageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "unitsSold": unitsSold,
        "revenue": revenue,
        "imageUrl": imageUrl,
      };
}

class RevenueData {
  String date;
  double revenue;
  int orders;

  RevenueData({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) => RevenueData(
        date: json["date"] ?? "",
        revenue: json["revenue"]?.toDouble() ?? 0.0,
        orders: json["orders"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "revenue": revenue,
        "orders": orders,
      };
}

class CustomerMetrics {
  int totalCustomers;
  int newCustomers;
  int returningCustomers;
  double customerRetentionRate;

  CustomerMetrics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.returningCustomers,
    required this.customerRetentionRate,
  });

  factory CustomerMetrics.fromJson(Map<String, dynamic> json) =>
      CustomerMetrics(
        totalCustomers: json["totalCustomers"] ?? 0,
        newCustomers: json["newCustomers"] ?? 0,
        returningCustomers: json["returningCustomers"] ?? 0,
        customerRetentionRate: json["customerRetentionRate"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "totalCustomers": totalCustomers,
        "newCustomers": newCustomers,
        "returningCustomers": returningCustomers,
        "customerRetentionRate": customerRetentionRate,
      };
}

class InventoryMetrics {
  int totalProducts;
  int lowStockProducts;
  int outOfStockProducts;
  double inventoryTurnover;

  InventoryMetrics({
    required this.totalProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.inventoryTurnover,
  });

  factory InventoryMetrics.fromJson(Map<String, dynamic> json) =>
      InventoryMetrics(
        totalProducts: json["totalProducts"] ?? 0,
        lowStockProducts: json["lowStockProducts"] ?? 0,
        outOfStockProducts: json["outOfStockProducts"] ?? 0,
        inventoryTurnover: json["inventoryTurnover"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "totalProducts": totalProducts,
        "lowStockProducts": lowStockProducts,
        "outOfStockProducts": outOfStockProducts,
        "inventoryTurnover": inventoryTurnover,
      };
}
