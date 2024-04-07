import 'dart:convert';

class ModelComplateTask {
  int? taskId;
  String? taskCreatorId;
  String? taskComplaterId;
  String? taskComplateDate;
  String? taskNote;
  List<dynamic>? taskImages;

  ModelComplateTask({
    this.taskId,
    this.taskCreatorId,
    this.taskComplaterId,
    this.taskComplateDate,
    this.taskNote,
    this.taskImages,
  });

  factory ModelComplateTask.fromRawJson(String str) => ModelComplateTask.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelComplateTask.fromJson(Map<String, dynamic> json) => ModelComplateTask(
    taskId: json["taskId"],
    taskCreatorId: json["taskCreatorId"],
    taskComplaterId: json["taskComplaterId"],
    taskComplateDate: json["taskComplateDate"],
    taskNote: json["taskNote"],
    taskImages: List<dynamic>.from(json["taskImages"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "taskId": taskId,
    "taskCreatorId": taskCreatorId,
    "taskComplaterId": taskComplaterId,
    "taskComplateDate": taskComplateDate,
    "taskNote": taskNote,
    "taskImages": List<dynamic>.from(taskImages!.map((x) => x)),
  };
}
