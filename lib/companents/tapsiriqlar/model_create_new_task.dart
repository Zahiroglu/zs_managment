import 'dart:convert';

class ModelCreateNewTask {
  String taskHeader;
  String taskTitle;
  String taskCreateDate;
  String taskCreatorId;
  String taskCariCode;
  String taskForUserId;
  String taskForRole;
  bool replayTask;
  bool tasiIsImportand;
  bool taskNeedPhoto;
  String taskPhotoCount;

  ModelCreateNewTask({
    required this.taskHeader,
    required this.taskTitle,
    required this.taskCreateDate,
    required this.taskCreatorId,
    required this.taskCariCode,
    required this.taskForUserId,
    required this.taskForRole,
    required this.replayTask,
    required this.taskNeedPhoto,
    required this.taskPhotoCount,
    required this.tasiIsImportand,
  });

  factory ModelCreateNewTask.fromRawJson(String str) => ModelCreateNewTask.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCreateNewTask.fromJson(Map<String, dynamic> json) => ModelCreateNewTask(
    taskHeader: json["taskHeader"],
    taskTitle: json["taskTitle"],
    taskCreateDate: json["taskCreateDate"],
    taskCreatorId: json["taskCreatorId"],
    taskCariCode: json["taskCariCode"],
    taskForUserId: json["taskForUserId"],
    taskForRole: json["taskForRole"],
    replayTask: json["replayTask"],
    taskNeedPhoto: json["taskNeedPhoto"],
    taskPhotoCount: json["taskPhotoCount"],
    tasiIsImportand: json["tasiIsImportand"],
  );

  Map<String, dynamic> toJson() => {
    "taskHeader": taskHeader,
    "taskTitle": taskTitle,
    "taskCreateDate": taskCreateDate,
    "taskCreatorId": taskCreatorId,
    "taskCariCode": taskCariCode,
    "taskForUserId": taskForUserId,
    "taskForRole": taskForRole,
    "replayTask": replayTask,
    "taskNeedPhoto": taskNeedPhoto,
    "taskPhotoCount": taskPhotoCount,
    "tasiIsImportand": tasiIsImportand,
  };
}
