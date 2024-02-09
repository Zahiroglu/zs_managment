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
  String? forwarderCode;
  @HiveField(4)
  String? fullAddress;
  @HiveField(5)
  String? ownerPerson;
  @HiveField(6)
  String? phone;
  @HiveField(7)
  String? postalCode;
  @HiveField(8)
  String? area;
  @HiveField(9)
  String? category;
  @HiveField(10)
  String? regionalDirectorCode;
  @HiveField(11)
  String? salesDirectorCode;
  @HiveField(12)
  String? latitude;
  @HiveField(13)
  String? longitude;
  @HiveField(14)
  String? district;
  @HiveField(15)
  String? tin;
  @HiveField(16)
  String? mainCustomer;
  @HiveField(17)
  double? debt;
  @HiveField(18)
  int? day1;
  @HiveField(19)
  int? day2;
  @HiveField(20)
  int? day3;
  @HiveField(21)
  int? day4;
  @HiveField(22)
  int? day5;
  @HiveField(23)
  int? day6;
  @HiveField(24)
  int? day7;
  @HiveField(25)
  bool? action;
  @HiveField(26)
  @HiveField(27)
  int? orderNumber;
  String? ziyaret;
  String? rutGunu;
  String? mesafe;
  double? mesafeInt;
  int? ziyaretSayi;
  String? sndeQalmaVaxti;

  ModelCariler({
    this.code,
    this.name,
    this.forwarderCode,
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
    this.day1,
    this.day2,
    this.day3,
    this.day4,
    this.day5,
    this.day6,
    this.day7,
    this.action,
    this.orderNumber,
    this.ziyaret,
    this.mesafe,
    this.ziyaretSayi,
  });

  ModelCariler copyWith({
    String? code,
    String? name,
    String? forwarderCode,
    String? fullAddress,
    String? ownerPerson,
    String? phone,
    String? postalCode,
    String? area,
    String? category,
    String? regionalDirectorCode,
    String? salesDirectorCode,
    String? latitude,
    String? longitude,
    String? district,
    String? tin,
    String? mainCustomer,
    double? debt,
    int? day1,
    int? day2,
    int? day3,
    int? day4,
    int? day5,
    int? day6,
    int? day7,
    bool? action,
    int? orderNumber,
  }) =>
      ModelCariler(
        code: code ?? this.code,
        name: name ?? this.name,
        forwarderCode: forwarderCode ?? this.forwarderCode,
        fullAddress: fullAddress ?? this.fullAddress,
        ownerPerson: ownerPerson ?? this.ownerPerson,
        phone: phone ?? this.phone,
        postalCode: postalCode ?? this.postalCode,
        area: area ?? this.area,
        category: category ?? this.category,
        regionalDirectorCode: regionalDirectorCode ?? this.regionalDirectorCode,
        salesDirectorCode: salesDirectorCode ?? this.salesDirectorCode,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        district: district ?? this.district,
        tin: tin ?? this.tin,
        mainCustomer: mainCustomer ?? this.mainCustomer,
        debt: debt ?? this.debt,
        day1: day1 ?? this.day1,
        day2: day2 ?? this.day2,
        day3: day3 ?? this.day3,
        day4: day4 ?? this.day4,
        day5: day5 ?? this.day5,
        day6: day6 ?? this.day6,
        day7: day7 ?? this.day7,
        action: action ?? this.action,
        orderNumber: orderNumber ?? this.orderNumber,
      );

  factory ModelCariler.fromRawJson(String str) => ModelCariler.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariler.fromJson(Map<String, dynamic> json) => ModelCariler(
    code: json["code"],
    name: json["name"],
    forwarderCode: json["forwarderCode"],
    fullAddress: json["fullAddress"],
    ownerPerson: json["ownerPerson"],
    phone: json["phone"],
    postalCode: json["postalCode"],
    area: json["area"],
    category: json["category"],
    regionalDirectorCode: json["regionalDirectorCode"],
    salesDirectorCode: json["salesDirectorCode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    district: json["district"],
    tin: json["tin"],
    mainCustomer: json["mainCustomer"],
    debt: json["debt"],
    day1: json["day1"],
    day2: json["day2"],
    day3: json["day3"],
    day4: json["day4"],
    day5: json["day5"],
    day6: json["day6"],
    day7: json["day7"],
    action: json["action"],
    orderNumber: json["orderNumber"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "forwarderCode": forwarderCode,
    "fullAddress": fullAddress,
    "ownerPerson": ownerPerson,
    "phone": phone,
    "postalCode": postalCode,
    "area": area,
    "category": category,
    "regionalDirectorCode": regionalDirectorCode,
    "salesDirectorCode": salesDirectorCode,
    "latitude": latitude,
    "longitude": longitude,
    "district": district,
    "tin": tin,
    "mainCustomer": mainCustomer,
    "debt": debt,
    "day1": day1,
    "day2": day2,
    "day3": day3,
    "day4": day4,
    "day5": day5,
    "day6": day6,
    "day7": day7,
    "action": action,
    "orderNumber": orderNumber,
  };

  @override
  String toString() {
    return 'ModelCariler{actions: $action,day1: $day1, day2: $day2, day3: $day3, day4: $day4, day5: $day5, day6: $day6, day7: $day7}';
  }
}
