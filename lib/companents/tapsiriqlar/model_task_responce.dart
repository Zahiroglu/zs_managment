import 'dart:convert';

class ModelResponceTask {
  int? taskId;
  int? taskCreatorId;
  String? taskCreaterFullName;
  String? taskCreatorRole;
  String? taskCreateDate;
  String? taskCariCode;
  String? taskCariName;
  String? taskHeader;
  String? taskTitle;
  bool? taskIsImportand;
  bool? taskIsPeriodik;
  bool? taskNeedPhoto;
  int? taskPhotoCount;
  bool? taskIsComplated;

  ModelResponceTask({
    this.taskId,
    this.taskCreatorId,
    this.taskCreaterFullName,
    this.taskCreatorRole,
    this.taskCreateDate,
    this.taskCariCode,
    this.taskCariName,
    this.taskHeader,
    this.taskTitle,
    this.taskIsImportand,
    this.taskIsPeriodik,
    this.taskNeedPhoto,
    this.taskPhotoCount,
    this.taskIsComplated,
  });

  factory ModelResponceTask.fromRawJson(String str) => ModelResponceTask.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelResponceTask.fromJson(Map<String, dynamic> json) => ModelResponceTask(
    taskId: json["taskId"],
    taskCreatorId: json["taskCreatorId"],
    taskCreaterFullName: json["taskCreaterFullName"],
    taskCreatorRole: json["taskCreatorRole"],
    taskCreateDate: json["taskCreateDate"],
    taskCariCode: json["taskCariCode"],
    taskCariName: json["taskCariName"],
    taskHeader: json["taskHeader"],
    taskTitle: json["taskTitle"],
    taskIsImportand: json["taskIsImportand"],
    taskIsPeriodik: json["taskIsPeriodik"],
    taskNeedPhoto: json["taskNeedPhoto"],
    taskPhotoCount: json["taskPhotoCount"],
  );

  Map<String, dynamic> toJson() => {
    "taskId": taskId,
    "taskCreatorId": taskCreatorId,
    "taskCreaterFullName": taskCreaterFullName,
    "taskCreatorRole": taskCreatorRole,
    "taskCreateDate": taskCreateDate,
    "taskCariCode": taskCariCode,
    "taskCariName": taskCariName,
    "taskHeader": taskHeader,
    "taskTitle": taskTitle,
    "taskIsImportand": taskIsImportand,
    "taskIsPeriodik": taskIsPeriodik,
    "taskNeedPhoto": taskNeedPhoto,
    "taskPhotoCount": taskPhotoCount,
  };

  List<ModelResponceTask> getListOfTask(){
    List<ModelResponceTask> listofTask=[];
    listofTask.add(ModelResponceTask(
     taskId: 1,
     taskCariCode: "01586",
     taskCariName: "Melissa m-t xirdalan",
     taskCreateDate: "2024-04-25",
     taskCreaterFullName: "Samir Selimov",
     taskCreatorId: 15,
     taskCreatorRole: "Supervaizer",
     taskHeader: "Fiyonk Tesil",
     taskTitle: "Fiyon tesili dolum et ve sekil cek",
     taskIsImportand: true,
     taskIsPeriodik: true,
     taskNeedPhoto: true,
     taskPhotoCount: 2,
      taskIsComplated: false,
   ));
    listofTask.add(ModelResponceTask(
     taskId: 2,
     taskCariCode: "01586",
     taskCariName: "Melissa m-t xirdalan",
     taskCreateDate: "2024-04-25",
     taskCreaterFullName: "Samir Selimov",
     taskCreatorId: 15,
     taskCreatorRole: "Supervaizer",
     taskHeader: "Anakom vitrini",
     taskTitle: "20 % yerimizi temin et ve sekil cek",
     taskIsImportand: true,
     taskIsPeriodik: true,
     taskNeedPhoto: true,
     taskPhotoCount: 3,
      taskIsComplated: true,
   ));
    listofTask.add(ModelResponceTask(
     taskId: 2,
     taskCariCode: "01586",
     taskCariName: "Melissa m-t xirdalan",
     taskCreateDate: "2024-04-25",
     taskCreaterFullName: "Samir Selimov",
     taskCreatorId: 15,
     taskCreatorRole: "Supervaizer",
     taskHeader: "Sirniyyat gozleri",
     taskTitle: "Sirniyyat gozlerini cek ve sayini yaz",
     taskIsImportand: true,
     taskIsPeriodik: true,
     taskNeedPhoto: false,
     taskPhotoCount: 0,
     taskIsComplated: false,
   ));


    return listofTask;
  }

}
