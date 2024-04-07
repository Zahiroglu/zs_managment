import 'package:flutter/material.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../login/services/api_services/users_controller_mobile.dart';

class WidgetRutPerformans extends StatelessWidget {
  ModelRutPerform modelRutPerform;
   WidgetRutPerformans({required this.modelRutPerform,super.key});

  @override
  Widget build(BuildContext context) {
    return modelRutPerform.snSayi!=null?Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: InkWell(
        onTap: () async {
          await Get.toNamed(RouteHelper.mobileGirisCixisHesabGunluk,arguments: modelRutPerform);

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5,bottom: 5),
              child: CustomText(
                labeltext: "Gunluk Giris-Cixislar",
                fontWeight: FontWeight.bold,
                fontsize: 18,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widgetSimpleTextInfo("${"umumiMusteri".tr} : ",modelRutPerform.snSayi.toString()),
                            widgetSimpleTextInfo("${"cariRut".tr} : ",modelRutPerform.rutSayi.toString()),
                            widgetSimpleTextInfo("${"duzZiyaret".tr} : ",modelRutPerform.duzgunZiya.toString()),
                            widgetSimpleTextInfo("${"sefZiyaret".tr} : ",modelRutPerform.rutkenarZiya.toString()),
                            widgetSimpleTextInfo("ziyaretUmumiSayi".tr+" : ",modelRutPerform.listGirisCixislar!.length.toString()),
                            widgetSimpleTextInfo("ziyaretEdilmeyen".tr+" : ",modelRutPerform.ziyaretEdilmeyen.toString()),
                            widgetSimpleTextInfo("marketlerdeISvaxti".tr+" : ",modelRutPerform.snlerdeQalma.toString()),
                            widgetSimpleTextInfo("erazideIsVaxti".tr+" : ",modelRutPerform.umumiIsvaxti.toString()),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            chartWidget(),
                            CustomText(labeltext: "Ziyaret Diagrami", fontsize: 10),
                          ],
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    ):const SizedBox();
  }

  Widget chartWidget(){
    final List<ChartData> chartData = [
      ChartData("rutgunu".tr, modelRutPerform.rutSayi!-modelRutPerform.duzgunZiya!,Colors.red),
      ChartData('ziyaretSayi'.tr, modelRutPerform.duzgunZiya!,Colors.green),
    ];
    return SimpleChart(listCharts: chartData,height: 120,width: 150,);
  }

  Widget widgetSimpleTextInfo(String lable,String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 150,
            child: CustomText(labeltext: lable,fontWeight: FontWeight.normal)),
        Expanded(child: CustomText(labeltext: value)),
      ],
    );
  }

  void _stopTodayWork() {}

}
