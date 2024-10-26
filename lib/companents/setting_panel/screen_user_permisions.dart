import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '../login/models/model_userspormitions.dart';

class ScreenUserPermisions extends StatefulWidget {
  ScreenUserPermisions({super.key, required this.listPermisions});
  List<ModelUserPermissions> listPermisions = [];

  @override
  State<ScreenUserPermisions> createState() => _ScreenUserPermisionsState();
}

class _ScreenUserPermisionsState extends State<ScreenUserPermisions> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index=0;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);

    // Adding a listener to detect when the index changes
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        index=controller.index;
        // Handle tab change
        print("Current Tab Index: ${controller.index}");
        // You can perform actions here based on the new index
        setState(() {
          // Optionally trigger UI updates if needed
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the TabController to avoid memory leaks
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(labeltext: "icazeler".tr, fontsize: 18),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          TabBar(
            controller: controller, // Link TabController
            tabs: [
              Tab(
                height: 30,
                child: CustomText(labeltext: "pages".tr),
              ),
              Tab(
                height: 30,
                child: CustomText(labeltext: "downloads".tr),
              ),
              Tab(
                height: 30,
                child: CustomText(labeltext: "otherPer".tr),
              ),
              Tab(
                height: 30,
                child: CustomText(labeltext: "hesabatlar".tr),
              ),
            ],
          ),
          SizedBox(height: 5), // Spacing between TabBar and ListView

          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                // Filtered list based on the current tab index (0 for Səhifələr, 1 for Endirmələr)
                ListView.builder(
                  itemCount: widget.listPermisions.where((e) => e.category == 1).length,
                  itemBuilder: (context, index) {
                    var item = widget.listPermisions.where((e) => e.category == 1).toList()[index];
                    return widgetItemPermition(item);                  },
                ),
                ListView.builder(
                  itemCount: widget.listPermisions.where((e) => e.category == 2).length,
                  itemBuilder: (context, index) {
                    var item = widget.listPermisions.where((e) => e.category == 2).toList()[index];
                    return widgetItemPermition(item);
                  },
                ),
                ListView.builder(
                  itemCount: widget.listPermisions.where((e) => e.category == 0).length,
                  itemBuilder: (context, index) {
                    var item = widget.listPermisions.where((e) => e.category == 0).toList()[index];
                    return widgetItemPermition(item);
                  },
                ),
                ListView.builder(
                  itemCount: widget.listPermisions.where((e) => e.category == 3).length,
                  itemBuilder: (context, index) {
                    var item = widget.listPermisions.where((e) => e.category == 3).toList()[index];
                    return widgetItemPermition(item);
                  },
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget widgetItemPermition(ModelUserPermissions item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    labeltext: item.name ?? '',
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    maxline: 2,
                  ),
                  CustomText(
                    labeltext: item.valName ?? '',
                    fontsize: 14,
                    fontWeight: FontWeight.normal,
                    maxline: 5,
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.verified_user_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
