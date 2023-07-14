class GroupUserAcces{
  int? id;
  String? groupName;
  List<UserAccess>? listAccess;

  GroupUserAcces({this.id, this.groupName, this.listAccess});
}



class UserAccess{
  int? id;
  String? accesName;
  AccesType? accesType;
  String? accesKod;

  UserAccess({this.id, this.accesName, this.accesType,this.accesKod});
}
enum AccesType {
  notAccess,
  hasAccess,
  fullAccess,
  readerAccess,
  controlAccess, }