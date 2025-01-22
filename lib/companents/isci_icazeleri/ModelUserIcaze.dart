import 'ModelIcazeRequest.dart';

class ModelUserIcaze {
  int userId;
  String userFullname;
  String roleName;
  int illikIcazeGunluk;
  int ayliqIcazeSaatliq;
  int illikResmiMezuniyyet;
  List<ModelIcazeRequest> listIcazeler;

  ModelUserIcaze({
    required this.userId,
    required this.userFullname,
    required this.roleName,
    required this.illikIcazeGunluk,
    required this.ayliqIcazeSaatliq,
    required this.listIcazeler,
    required this.illikResmiMezuniyyet,
  });

  factory ModelUserIcaze.fromJson(Map<String, dynamic> json) {
    return ModelUserIcaze(
      userId: json['UserId']??0,
      userFullname: json['UserFullname']??"",
      roleName: json['RoleName']??"",
      illikIcazeGunluk: json['IllikIcazeGunluk']??0,
      ayliqIcazeSaatliq: json['AyliqIcazeSaatliq']??0,
      illikResmiMezuniyyet: json['IllikResmiMezuniyyet']??0,
      listIcazeler:json['listIcazeler']!=null? (json['listIcazeler'] as List)
          .map((i) => ModelIcazeRequest.fromJson(i))
          .toList():[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'UserFullname': userFullname,
      'RoleName': roleName,
      'IllikIcazeGunluk': illikIcazeGunluk,
      'AyliqIcazeSaatliq': ayliqIcazeSaatliq,
      'listIcazeler': listIcazeler.map((e) => e.toJson()).toList(),
    };
  }
}