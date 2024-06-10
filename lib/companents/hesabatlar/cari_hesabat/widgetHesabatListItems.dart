import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class WidgetHesabatListItemsCari extends StatefulWidget {
  BuildContext context;
  ModelCariHesabatlar modelCariHesabatlar;
  String ckod;
  String cAd;

  WidgetHesabatListItemsCari(
      {required this.modelCariHesabatlar, required this.context,required this.ckod,required this.cAd, super.key});

  @override
  State<WidgetHesabatListItemsCari> createState() => _WidgetHesabatListItemsCariState();
}

class _WidgetHesabatListItemsCariState extends State<WidgetHesabatListItemsCari> {
  TextEditingController ctFistDay = TextEditingController();
  TextEditingController ctLastDay = TextEditingController();

  @override
  void initState() {
    ctFistDay.text = DateTime.now().toString().substring(0, 10);
    ctLastDay.text = DateTime.now().toString().substring(0, 10);
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    ctLastDay.dispose();
    ctFistDay.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          intendByDialog();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: widget.modelCariHesabatlar.color!,
                      offset: const Offset(2, 2),
                      spreadRadius: 0.1,
                      blurRadius: 2)
                ],
                border: Border.all(
                    color: widget.modelCariHesabatlar.color!.withOpacity(0.5)),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: widget.modelCariHesabatlar.color!,
                  foregroundColor: Colors.white,
                  child: Icon(widget.modelCariHesabatlar.icon!),
                ),
                SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomText(
                        labeltext: widget.modelCariHesabatlar.label!.tr,
                        maxline: 2,
                        textAlign: TextAlign.center,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  intendByDialog() {
    if (widget.modelCariHesabatlar.needDate!) {
      Get.dialog(_widgetDatePicker());
    } else {}
  }

  Widget _widgetDatePicker() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(widget.context).size.height * 0.3,
            horizontal: MediaQuery.of(widget.context).size.width * 0.1),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                  ctFistDay.text = DateTime.now().toString().substring(0, 10);
                  ctLastDay.text = DateTime.now().toString().substring(0, 10);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(bottom: 0),
                  child: Icon(Icons.clear),
                ),
              ),
            ),
            CustomText(
              labeltext: widget.modelCariHesabatlar.label!,
              fontsize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "Ilkin tarix",
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(true);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctFistDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "Son tarix",
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(false);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctLastDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevetedButton(
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                textColor: Colors.green,
                fontWeight: FontWeight.w700,
                icon: Icons.refresh,
                clicble: true,
                elevation: 10,
                height: 40,
                width: MediaQuery.of(widget.context).size.width * 0.4,
                cllback: () {
                  _intenReqPage();
                },
                label: "Hesabat al")
          ],
        ),
      ),
    );
  }

  void callDatePicker(bool isFistDate) async {
    String day = "01";
    String ay = "01";
    var order = await getDate();
    if (order!.day.toInt() < 10) {
      day = "0${order.day}";
    } else {
      day = order.day.toString();
    }
    if (order.month.toInt() < 10) {
      ay = "0${order.month}";
    } else {
      ay = order.month.toString();
    }
    if (isFistDate) {
      //ctFistDay.text = "$day.$ay.${order.year}";
      ctFistDay.text = "${order.year}-$ay-$day";
    } else {
     // ctLastDay.text = "$day.$ay.${order.year}";
      ctLastDay.text = "${order.year}-$ay-$day";

    }
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
  }

  void _intenReqPage() {
   if(widget.modelCariHesabatlar.isAktiv!){
     Get.back();
     Get.toNamed(widget.modelCariHesabatlar.routName!,arguments: [ctFistDay.text,ctLastDay.text,widget.ckod,widget.cAd]);
   }else{
     Get.dialog(ShowInfoDialog(messaje: "hesbatAktivDeyil".tr, icon: Icons.unpublished, callback: (){
       Get.back();
     }));
   }

  }
}
