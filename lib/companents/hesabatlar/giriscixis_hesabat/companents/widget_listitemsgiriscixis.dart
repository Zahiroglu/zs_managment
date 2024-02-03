import 'package:flutter/material.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WigetListItemsGirisCixis extends StatelessWidget {
  ModelGirisCixis model;

   WigetListItemsGirisCixis({required this.model,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.rutgunu == "Sef" ? Colors.red : Colors.green,
          margin:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                          labeltext: model.cariad!,
                          fontsize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          overflow: TextOverflow.ellipsis,
                          maxline: 2,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                    CustomText(labeltext: "Giris vaxti :"),
                    SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.girisvaxt!.substring(11, 19)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    CustomText(labeltext: "Cixis vaxti :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.cixisvaxt!.substring(11, 19)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "Vaxt :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.girisvaxt!, model.cixisvaxt!)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: "${model.girisvaxt!.substring(0, 11)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext: model.rutgunu == "Sef" ? "Rutdan kenar" : "Rut gunu",
                color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
              ),
            ))
      ],
    );
  }
  String carculateTimeDistace(String? girisvaxt, String? cixisvaxt) {
    Duration difference =
    DateTime.parse(cixisvaxt!).difference(DateTime.parse(girisvaxt!));
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

}
