import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_cesid_hesabati/model_caricesid.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/double_round_helper.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenCariCesidHesabatiMal extends StatefulWidget {
  List<ModelCariCesid> listCesidler;

  ScreenCariCesidHesabatiMal({required this.listCesidler, super.key});

  @override
  State<ScreenCariCesidHesabatiMal> createState() =>
      _ScreenCariCesidHesabatiMalState();
}

class _ScreenCariCesidHesabatiMalState
    extends State<ScreenCariCesidHesabatiMal> {
  bool isLoading = false;
  bool dataFounded = false;
  List<ModelCariCesid> listData = [];
  DoubleRoundHelper doubleRound = DoubleRoundHelper();

  @override
  void initState() {
    listData = widget.listCesidler;
    listData.sort((a,b)=>a.anaQrup.compareTo(b.anaQrup));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: CustomText(
            labeltext: isLoading ? "" : listData.first.cariAd,
          ),
          actions: [],
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ))
            : _body(context),
      ),
    ));
  }

  _body(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 15, bottom: 5, right: 15, top: 5),
              color: Colors.black,
              child: _widgetHeader(context),
            )),
        Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              child: _widgetList(context),
            )),
      ],
    );
  }

  _widgetHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
            labeltext: "${"totalCesidSay".tr} : ${listData.length}",
            color: Colors.white,
            fontWeight: FontWeight.w600),
        CustomText(
            labeltext:
                "${"totalMebleg".tr} : ${doubleRound.prettify(listData.fold(0.0, (sum, element) => sum + double.parse(element.netMebleg)))} ${"manatSimbol".tr}",
            color: Colors.white,
            fontWeight: FontWeight.w600)
      ],
    );
  }

  _widgetList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 18,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  return _widgetListItem(listData.elementAt(index));
                }),
          ),
        )
      ],
    );
  }

  _widgetListItem(ModelCariCesid model) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // const SizedBox(
            //   height: 70,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    labeltext: model.anaQrup,
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                    maxline: 2),
                const SizedBox(height: 5,),
                CustomText(
                  overflow: TextOverflow.ellipsis,
                    labeltext: "${model.stockKod} - ${model.stockAd}",
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                    maxline: 2),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        labeltext: "${"miqdar".tr} : ${model.miqdar} ",
                        fontsize: 14,
                        fontWeight: FontWeight.w500,
                        maxline: 2),
                    CustomText(
                        labeltext: "${"temKod".tr} : ${model.expKod} ",
                        fontsize: 14,
                        fontWeight: FontWeight.w500,
                        maxline: 2),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomText(
                  labeltext: doubleRound.prettify(double.parse(model.netMebleg)) +
                      " " +
                      "manatSimbol".tr,
                  color: Colors.blue,
                  fontsize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  _filterList(String data) {
    // listData.forEach((element) {
    //   if (element.hSenedtipi == data) {
    //     listDataFitred.add(element);
    //   }
    // });
    setState(() {});
  }
}
