import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/simple_user_request.dart';

class GirisCixisRequest {
  List<SimpleUserModel>? rollar;
  String? userCode;
  String startDate;
  String endDate;

  GirisCixisRequest({
    this.rollar,
    this.userCode,
    required this.startDate,
    required this.endDate,
  });

  // Convert the Dart object to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'rollar': rollar,
      'userCode': userCode,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  // Create a Dart object from JSON (optional, for responses)
  factory GirisCixisRequest.fromJson(Map<String, dynamic> json) {
    return GirisCixisRequest(
      rollar: List<SimpleUserModel>.from(json['Rollar'] ?? []),
      userCode: json['UserCode'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
    );
  }
}
