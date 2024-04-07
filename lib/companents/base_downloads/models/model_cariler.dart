import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_cariler.g.dart';

@HiveType(typeId: 21)
class ModelCariler {
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? fullAddress;
  @HiveField(4)
  String? ownerPerson;
  @HiveField(5)
  String? phone;
  @HiveField(6)
  String? postalCode;
  @HiveField(7)
  String? area;
  @HiveField(8)
  String? category;
  @HiveField(9)
  String? regionalDirectorCode;
  @HiveField(10)
  String? salesDirectorCode;
  @HiveField(11)
  double? latitude;
  @HiveField(12)
  double? longitude;
  @HiveField(13)
  String? district;
  @HiveField(14)
  String? tin;
  @HiveField(15)
  String? mainCustomer;
  @HiveField(16)
  double? debt;
  @HiveField(17)
  bool? action;
  @HiveField(18)
  List<Day>? days;
  @HiveField(19)
  String? forwarderCode;
  int? ziyaretSayi;
  String? sndeQalmaVaxti;
  String? rutGunu;
  String? mesafe;
  double? mesafeInt;
  String? ziyaret;

  ModelCariler({
    this.code,
    this.name,
    this.fullAddress,
    this.ownerPerson,
    this.phone,
    this.postalCode,
    this.area,
    this.category,
    this.regionalDirectorCode,
    this.salesDirectorCode,
    this.latitude,
    this.longitude,
    this.district,
    this.tin,
    this.mainCustomer,
    this.debt,
    this.action,
    this.days,
    this.ziyaretSayi,
    this.forwarderCode,
    this.rutGunu,
    this.mesafe,
    this.mesafeInt,
  });

  factory ModelCariler.fromRawJson(String str) => ModelCariler.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariler.fromJson(Map<String, dynamic> json) => ModelCariler(
    code: json["code"],
    name: json["name"],
    fullAddress: json["fullAddress"],
    ownerPerson: json["ownerPerson"],
    phone: json["phone"],
    postalCode: json["postalCode"],
    area: json["area"],
    category: json["category"],
    regionalDirectorCode: json["regionalDirectorCode"],
    salesDirectorCode: json["salesDirectorCode"],
    forwarderCode: json["forwarderCode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    district: json["district"],
    tin: json["tin"],
    mainCustomer: json["mainCustomer"],
    debt: json["debt"],
    action: json["action"],
    days: json["days"]==null?null:List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "fullAddress": fullAddress,
    "ownerPerson": ownerPerson,
    "phone": phone,
    "postalCode": postalCode,
    "area": area,
    "category": category,
    "regionalDirectorCode": regionalDirectorCode,
    "salesDirectorCode": salesDirectorCode,
    "forwarderCode": forwarderCode,
    "latitude": latitude,
    "longitude": longitude,
    "district": district,
    "tin": tin,
    "mainCustomer": mainCustomer,
    "debt": debt,
    "action": action,
    "days": List<dynamic>.from(days!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelCariler{code: $code, name: $name, fullAddress: $fullAddress, ownerPerson: $ownerPerson, phone: $phone, postalCode: $postalCode, area: $area, category: $category, regionalDirectorCode: $regionalDirectorCode, salesDirectorCode: $salesDirectorCode, latitude: $latitude, longitude: $longitude, district: $district, tin: $tin, mainCustomer: $mainCustomer, debt: $debt, action: $action, days: $days, forwarderCode: $forwarderCode, ziyaretSayi: $ziyaretSayi, sndeQalmaVaxti: $sndeQalmaVaxti, rutGunu: $rutGunu, mesafe: $mesafe, mesafeInt: $mesafeInt, ziyaret: $ziyaret}';
  }
}

@HiveType(typeId: 26)
class Day {
  @HiveField(1)
  int day;
  @HiveField(2)
  int orderNumber;

  Day({
    required this.day,
    required this.orderNumber,
  });

  factory Day.fromRawJson(String str) => Day.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    orderNumber: json["orderNumber"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "orderNumber": orderNumber,
  };

  @override
  String toString() {
    return 'Day{day: $day, orderNumber: $orderNumber}';
  }
}
