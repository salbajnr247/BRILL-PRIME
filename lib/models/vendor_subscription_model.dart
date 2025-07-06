
import 'dart:convert';

VendorSubscriptionModel vendorSubscriptionModelFromJson(String str) =>
    VendorSubscriptionModel.fromJson(json.decode(str));

String vendorSubscriptionModelToJson(VendorSubscriptionModel data) =>
    json.encode(data.toJson());

class VendorSubscriptionModel {
  bool status;
  String message;
  VendorSubscriptionData data;

  VendorSubscriptionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VendorSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      VendorSubscriptionModel(
        status: json["status"],
        message: json["message"],
        data: VendorSubscriptionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class VendorSubscriptionData {
  SubscriptionPlan currentPlan;
  List<SubscriptionPlan> availablePlans;
  DateTime? nextBillingDate;
  double totalSpent;

  VendorSubscriptionData({
    required this.currentPlan,
    required this.availablePlans,
    this.nextBillingDate,
    required this.totalSpent,
  });

  factory VendorSubscriptionData.fromJson(Map<String, dynamic> json) =>
      VendorSubscriptionData(
        currentPlan: SubscriptionPlan.fromJson(json["currentPlan"]),
        availablePlans: List<SubscriptionPlan>.from(
            json["availablePlans"].map((x) => SubscriptionPlan.fromJson(x))),
        nextBillingDate: json["nextBillingDate"] != null
            ? DateTime.parse(json["nextBillingDate"])
            : null,
        totalSpent: json["totalSpent"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "currentPlan": currentPlan.toJson(),
        "availablePlans": List<dynamic>.from(availablePlans.map((x) => x.toJson())),
        "nextBillingDate": nextBillingDate?.toIso8601String(),
        "totalSpent": totalSpent,
      };
}

class SubscriptionPlan {
  String id;
  String name;
  String description;
  double price;
  String billingCycle;
  List<String> features;
  int maxProducts;
  int maxOrders;
  bool hasAnalytics;
  bool hasPrioritySupport;
  bool isActive;
  String? status;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    required this.features,
    required this.maxProducts,
    required this.maxOrders,
    required this.hasAnalytics,
    required this.hasPrioritySupport,
    required this.isActive,
    this.status,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        price: json["price"]?.toDouble() ?? 0.0,
        billingCycle: json["billingCycle"] ?? "",
        features: List<String>.from(json["features"]?.map((x) => x) ?? []),
        maxProducts: json["maxProducts"] ?? 0,
        maxOrders: json["maxOrders"] ?? 0,
        hasAnalytics: json["hasAnalytics"] ?? false,
        hasPrioritySupport: json["hasPrioritySupport"] ?? false,
        isActive: json["isActive"] ?? false,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "billingCycle": billingCycle,
        "features": List<dynamic>.from(features.map((x) => x)),
        "maxProducts": maxProducts,
        "maxOrders": maxOrders,
        "hasAnalytics": hasAnalytics,
        "hasPrioritySupport": hasPrioritySupport,
        "isActive": isActive,
        "status": status,
      };
}
