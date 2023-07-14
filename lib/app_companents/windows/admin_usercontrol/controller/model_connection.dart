class ModelConnection{
  ConnectedUserModel? satisMudiri;
  ConnectedUserModel? boldeMudiri;
  ConnectedUserModel? marketingMudiri;
  ConnectedUserModel? maliyyeMufettisi;
  ConnectedUserModel? maliyyeAudit;
  ConnectedUserModel? crmAudit;
  ConnectedUserModel? supervaizer;
  ConnectedUserModel? lojistikMudir;

  ModelConnection({
      this.satisMudiri,
      this.boldeMudiri,
      this.marketingMudiri,
      this.maliyyeMufettisi,
      this.maliyyeAudit,
      this.crmAudit,
      this.supervaizer,
      this.lojistikMudir});
}
class ConnectedUserModel{
  String? userCode;
  String? userName;

  ConnectedUserModel({this.userCode, this.userName});
}
