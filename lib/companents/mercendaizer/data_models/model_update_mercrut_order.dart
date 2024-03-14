import 'dart:convert';

class ModelUpdateMercRutOrder {
  String merchCode;
  int day;
  List<OrderCustomer> orderCustomers;

  ModelUpdateMercRutOrder({
    required this.merchCode,
    required this.day,
    required this.orderCustomers,
  });

  factory ModelUpdateMercRutOrder.fromRawJson(String str) => ModelUpdateMercRutOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUpdateMercRutOrder.fromJson(Map<String, dynamic> json) => ModelUpdateMercRutOrder(
    merchCode: json["merchCode"],
    day: json["day"],
    orderCustomers: List<OrderCustomer>.from(json["customerOrderNumber"].map((x) => OrderCustomer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "merchCode": merchCode,
    "day": day,
    "customerOrderNumber": List<dynamic>.from(orderCustomers.map((x) => x.toJson())),
  };
}

class OrderCustomer {
  String customerCode;
  int orderNumber;

  OrderCustomer({
    required this.customerCode,
    required this.orderNumber,
  });

  factory OrderCustomer.fromRawJson(String str) => OrderCustomer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCustomer.fromJson(Map<String, dynamic> json) => OrderCustomer(
    customerCode: json["customerCode"],
    orderNumber: json["orderNumber"],
  );

  Map<String, dynamic> toJson() => {
    "customerCode": customerCode,
    "orderNumber": orderNumber,
  };
}
