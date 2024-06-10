import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';

import 'custom_eleveted_button.dart';
import 'custom_responsize_textview.dart';

class ShowInfoDialog extends StatelessWidget {
  const ShowInfoDialog({
    Key? key,
    required this.messaje,
    required this.icon,
    this.color,
    required this.callback,
  }) : super(key: key);

  final String messaje;
  final IconData icon;
  final Function callback;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration:   BoxDecoration(
              color: Get.isDarkMode?Colors.black:Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          height:MediaQuery.of(context).size.height*0.38,
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color??Colors.red,
                size:50,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Center(
                    child: CustomText(
                      color: Get.isDarkMode?Colors.white:Colors.black,
                      textAlign: TextAlign.center,
                      labeltext: messaje,
                      maxline: 4,
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomElevetedButton(
                    icon: Icons.clear,
                    height: 20,
                    elevation: 10,
                    borderColor: Colors.blueAccent.withOpacity(0.5),
                    surfaceColor: Colors.white,
                    label: "bagla".tr,
                    clicble: true,
                    cllback: (){
                      callback.call();
                      Get.back();
                      //Get.back();
                      //callback!.call();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}