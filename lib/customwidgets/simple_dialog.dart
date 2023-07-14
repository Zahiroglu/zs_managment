import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';

class ShowInfoDialog extends StatelessWidget {
  const ShowInfoDialog({
    Key? key,
    required this.messaje,
    required this.icon,
    this.callback,
  }) : super(key: key);

  final String messaje;
  final IconData icon;
  final Function? callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration:   BoxDecoration(
              color: Get.isDarkMode?Colors.black:Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3),
                    offset: const Offset(5, 5),
                  blurRadius: 10
                ),
                BoxShadow(color: Colors.blue.withOpacity(0.3),
                    offset: const Offset(-5, -5),
                  blurRadius: 10
                )
              ]),
          height: ResponsiveBuilder.isMobile(context)?MediaQuery.of(context).size.height * 0.38:ResponsiveBuilder.islandspace(context)
              ? MediaQuery.of(context).size.height * 0.3
              : MediaQuery.of(context).size.height * 0.1,
          width: ResponsiveBuilder.isMobile(context)?MediaQuery.of(context).size.width * 0.9:ResponsiveBuilder.islandspace(context)
              ? MediaQuery.of(context).size.width * 0.3
              : MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.red,
                size: MediaQuery.of(context).size.height * 0.08,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                child: Center(
                    child: CustomText(
                      color: Get.isDarkMode?Colors.white:Colors.black,
                      textAlign: TextAlign.center,
                      labeltext: messaje,
                      maxline: 3,
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevetedButton(
                  elevation: 10,
                  borderColor: Colors.blueAccent.withOpacity(0.5),
                  surfaceColor: Colors.white,
                  label: "bagla".tr,
                  cllback: (){
                    Navigator.of(context).pop();
                    callback!.call();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}