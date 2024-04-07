import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../main_screen/controller/drawer_menu_controller.dart';

class ScreenTask extends StatefulWidget {
   DrawerMenuController drawerMenuController;

   ScreenTask({required this.drawerMenuController,super.key});

  @override
  State<ScreenTask> createState() => _ScreenTaskState();
}

class _ScreenTaskState extends State<ScreenTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            widget.drawerMenuController.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(RouteHelper.getCreateNewTask());
          }, icon: Icon(Icons.add_task_outlined,color: Colors.green,))
        ],
        title: CustomText(labeltext: "tasks".tr),
      ),
      body: Placeholder(),
    );
  }
}
