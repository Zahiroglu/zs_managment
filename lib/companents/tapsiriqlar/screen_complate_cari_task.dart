import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/tapsiriqlar/model_task_responce.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenComplateCariTask extends StatefulWidget {
  LoggedUserModel loggedUserModel;
  ModelResponceTask modelResponceTask;

  ScreenComplateCariTask(
      {required this.modelResponceTask,
      required this.loggedUserModel,
      super.key});

  @override
  State<ScreenComplateCariTask> createState() => _ScreenComplateCariTaskState();
}

class _ScreenComplateCariTaskState extends State<ScreenComplateCariTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: "tamsiriqicrasi".tr),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Column(
      children: [
        _customersInfo(context),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: CustomElevetedButton(
                      height: 40,
                      cllback: () {},
                      label:"Tapsirigi icra et",
                      elevation: 10,
                      surfaceColor: Colors.blueAccent.withOpacity(0.5),
                    )),
                const SizedBox(width: 20,),
                Expanded(
                    flex: 5,
                    child: CustomElevetedButton(
                      height: 40,
                      cllback: () {},
                      label:"Tapsirigi imtina et",
                      elevation: 10,
                      surfaceColor: Colors.red.withOpacity(0.5),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  _customersInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: "Tapsiriq basliq",
              fontsize: 16,
              fontWeight: FontWeight.w800),
          const SizedBox(
            height: 5,
          ),
          Card(
            elevation: 10,
            surfaceTintColor: Colors.blue,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Tapsiriq yaradan : ",
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                          labeltext:
                              widget.modelResponceTask.taskCreaterFullName!),
                      CustomText(
                          labeltext: " ( ${widget.modelResponceTask.taskCreatorRole!} ) "),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Tapsiriq yaradilma vaxti : ",
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                          labeltext: widget.modelResponceTask.taskCreateDate!),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 10,
            surfaceTintColor: Colors.black,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          labeltext: widget.modelResponceTask.taskHeader!,
                          fontWeight: FontWeight.w800,
                          fontsize: 18),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                          labeltext: widget.modelResponceTask.taskTitle!,
                          fontsize: 14),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
