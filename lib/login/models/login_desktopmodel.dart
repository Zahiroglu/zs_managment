class UserModela{
 // String accessToken;
 // String refreshToken;
  String? adsoyad;
  int? vezifeId;
  String? vezifeAdi;
  String? sirketAdi;
  bool? hassAcces;


  UserModela({this.adsoyad, this.vezifeId, this.vezifeAdi, this.sirketAdi,this.hassAcces});


  UserModela.fromJson(Map<String,dynamic> json){
    adsoyad:json['assoyad'];
    vezifeId:json['vezifeId'];
    vezifeAdi:json['vezifeAdi'];
    sirketAdi:json['sirketAdi'];
    hassAcces:json['hassAcces'];
  }


  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=<String,dynamic>{};
    data['adsoyad']=adsoyad;
    data['vezifeId']=vezifeId;
    data['vezifeAdi']=vezifeAdi;
    data['sirketAdi']=sirketAdi;
    data['hassAcces']=hassAcces;
    return data;
  }

  @override
  String toString() {
    return 'UserModela{adsoyad: $adsoyad, vezifeId: $vezifeId, vezifeAdi: $vezifeAdi, sirketAdi: $sirketAdi}';
  }
  List<UserModela> getLoggedUsers(){
    return [
      UserModela(adsoyad: "Samir Selimov",vezifeId:1,vezifeAdi: "Admin",sirketAdi: "Bolluq ltd mmc",hassAcces: true),
    ];
  }
}