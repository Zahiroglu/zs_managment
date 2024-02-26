import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_hesabati/model_cari_hereket.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_hesabati/model_faktura.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/double_round_helper.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenFaktura extends StatefulWidget {
  String recNom;
  String senedTipi;

  ScreenFaktura({required this.recNom,
    required this.senedTipi,
    super.key});

  @override
  State<ScreenFaktura> createState() => _ScreenFakturaState();
}

class _ScreenFakturaState extends State<ScreenFaktura> {
  bool isLoading = false;
  bool dataFounded = false;
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  List<ModelFaktura> listData = [];
  DoubleRoundHelper doubleRound = DoubleRoundHelper();
  List<String> listFiler = [];

  @override
  void initState() {
    getDataFromServer();
    // TODO: implement initState
    super.initState();
  }

  getDataFromServer() async {
    listData = await getDataFromServerUmumiCariler(
        widget.senedTipi, widget.recNom);
    setState(() {
    });
  }

  Future<List<ModelFaktura>> getDataFromServerUmumiCariler(String senedTipi,
      String recNom) async {
    listData.clear();
    setState(() {
      isLoading = true;
    });
    var envelopeaUmumicariler = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <Faktura xmlns="http://tempuri.org/">
      <recno>$recNom</recno>
    </Faktura>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/Faktura",
          // "Host": "85.132.97.2"
          "Host": soaphost
          //"Accept": "text/xml"
        },
        body: envelopeaUmumicariler);
    var rawXmlResponse = "";
    if (response.statusCode == 200) {
      //  DialogHelper.hideLoading();
      rawXmlResponse = response.body;
      setState(() {
        rawXmlResponse.isNotEmpty ? dataFounded == true : dataFounded = false;
        isLoading = false;
      });
    } else {
      //DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta BAs Verdi",
        icon: Icons.error,
        callback: () {
          DialogHelper.hideLoading();
        },
      ));
    }
    return _parsingCariler(rawXmlResponse);
  }

  Future<List<ModelFaktura>> _parsingCariler(var _response) async {
    listFiler.clear();
    listFiler.add("hamisi".tr);
    List<ModelFaktura> listKodrdinar = [];
    var document = xml.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var sth_tarih = _getValue(item.findElements("sth_tarih"));
      var sth_evrakno_seri = _getValue(item.findElements("sth_evrakno_seri"));
      var sth_evrakno_sira = _getValue(item.findElements("sth_evrakno_sira"));
      var NOR_QAY = _getValue(item.findElements("NOR_QAY"));
      var faktura_yip = _getValue(item.findElements("faktura_yip"));
      var sth_stok_kod = _getValue(item.findElements("sth_stok_kod"));
      var sto_isim = _getValue(item.findElements("sto_isim"));
      var sth_cari_kodu = _getValue(item.findElements("sth_cari_kodu"));
      var cari_unvan1 = _getValue(item.findElements("cari_unvan1"));
      var sth_plasiyer_kodu = _getValue(item.findElements("sth_plasiyer_kodu"));
      var TEMSILCI_ADI = _getValue(item.findElements("TEMSILCI_ADI"));
      var sth_miktar = _getValue(item.findElements("sth_miktar"));
      var NET_MEB = _getValue(item.findElements("NET_MEB"));
      var BRUT_MEB = _getValue(item.findElements("BRUT_MEB"));
      var CEM_ENDIRIM = _getValue(item.findElements("CEM_ENDIRIM"));
      var QIYMET = _getValue(item.findElements("QIYMET"));
      var vahid = _getValue(item.findElements("vahid"));
      String f_tarix = sth_tarih.toString();
      String f_seri = sth_evrakno_seri.toString();
      String f_sira = sth_evrakno_sira.toString();
      String f_qaytarma = NOR_QAY.toString();
      String f_fakturayip = faktura_yip.toString();
      String f_stockod = sth_stok_kod.toString();
      String f_stocismi = sto_isim.toString();
      String f_cariad = cari_unvan1.toString();
      String f_carikod = sth_cari_kodu.toString();
      String f_temsilci = sth_plasiyer_kodu.toString();
      String f_temsilciadi = TEMSILCI_ADI.toString();
      String f_miktar = sth_miktar.toString();
      String f_netmebleg = NET_MEB.toString();
      String f_brutmebleg = BRUT_MEB.toString();
      String f_endirim = CEM_ENDIRIM.toString();
      String f_qiymet = QIYMET.toString();
      String f_vahid = vahid.toString();
      ModelFaktura modelHereketrapor = ModelFaktura(
        fBrutmebleg: f_brutmebleg,
        fCariad:f_cariad,
        fCarikod: f_carikod,
        fEndirim: f_endirim,
        fFakturayip: f_fakturayip,
        fMiktar: f_miktar,
        fNetmebleg: f_netmebleg,
        fQaytarma: f_qaytarma,
        fQiymet: f_qiymet,
        fSeri: f_seri,
        fSira: f_sira,
        fStocismi: f_stocismi,
        fStockod: f_stockod,
        fTarix: f_tarix,
        fTemsilci: f_temsilci,
        fTemsilciadi: f_temsilciadi,
        fVahid: f_vahid
      );
      listKodrdinar.add(modelHereketrapor);
    }).toList();

    return listKodrdinar;
  }

  _getValue(Iterable<xml.XmlElement> items) {
    var textValue;
    items.map((xml.XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
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
                labeltext: isLoading?"":listData.first.fFakturayip,
              ),
              actions: [
              ],
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
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 5, top: 10),
              color: Colors.black,
              child: _widgetHeader(context),
            )),
        Expanded(
            flex: 10,
            child: Container(
              color: Colors.white,
              child: _widgetList(context),
            )),
      ],
    );
  }

  _widgetHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  labeltext:"${"seri".tr} : ${listData.first.fSeri}",
                  color: Colors.white,
                  maxline: 2,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(height: 0.2, color: Colors.white, thickness: 0.2),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  labeltext:"${"sira".tr} : ${listData.first.fSira}",
                  color: Colors.white,
                  maxline: 2,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(height: 0.2, color: Colors.white, thickness: 0.2),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  labeltext: "nIade".tr+" : "+listData.first.fQaytarma,
                  color: Colors.white,
                  maxline: 1,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  labeltext: "${"sTip".tr} : ${listData.first.fFakturayip}",
                  color: Colors.white,
                  maxline: 1,
                )
              ],
            )),
        Container(
          height: double.infinity,
          width: 1,
          color: Colors.white,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomText(
                      labeltext: "${listData.first.fTemsilciadi.replaceAllMapped(RegExp("[-+.^:,1234567890()]"), (match) => "", )} : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:listData.first.fTemsilci,
                      color: Colors.white,
                    ),

                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(height: 1,color: Colors.white,),
                const SizedBox(
                  height: 15,
                ),
               Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   CustomText(
                     labeltext: "${"senedCemi".tr} : ${doubleRound.prettify(listData.fold(0.0,(sum,element) => sum+double.parse(element.fNetmebleg)))} ${"manatSimbol".tr}",
                     color: Colors.white,
                   ),
                   CustomText(
                     labeltext: "${"senedEndirim".tr} : ${doubleRound.prettify(listData.fold(0.0,(sum,element) => sum+double.parse(element.fEndirim)))} ${"manatSimbol".tr}",
                     color: Colors.white,
                   ),
                   CustomText(
                     labeltext: "${"brutCem".tr} : ${doubleRound.prettify(listData.fold(0.0,(sum,element) => sum+double.parse(element.fBrutmebleg)))} ${"manatSimbol".tr}",
                     color: Colors.white,
                   ),
                 ],
               )

              ],
            )),
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

  _widgetListItem(ModelFaktura model) {
    return Card(
      surfaceTintColor: Colors.grey,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(labeltext: model.fStockod),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CustomText(labeltext: model.fMiktar,fontWeight: FontWeight.w500,color: Colors.blueAccent,fontsize: 16),
                ),
              ],
            ),
            CustomText(labeltext: model.fStocismi,maxline: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(labeltext: "${"tekQiymet".tr} : ${doubleRound.prettify(double.parse(model.fQiymet))} ${"manatSimbol".tr}",color: Colors.teal,),
                const SizedBox(width: 5,),
              ],
            ),
            const Divider(height: 1,color: Colors.teal,),
            const SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Column(children: [
                      CustomText(labeltext: "brutMebleg".tr),
                      CustomText(labeltext: "${model.fBrutmebleg} ${"manatSimbol".tr}",fontsize: 16,fontWeight: FontWeight.w600,)

                    ],)),
                Expanded(
                    flex: 5,
                    child: Column(children: [
                      CustomText(labeltext: "endirim".tr),
                      CustomText(labeltext: "${model.fBrutmebleg} ${"manatSimbol".tr}",fontsize: 16,fontWeight: FontWeight.w600,)

                    ],)),
                Expanded(
                    flex: 5,
                    child: Column(children: [
                      CustomText(labeltext: "netSatis".tr,fontWeight: FontWeight.w600,color: Colors.blue,fontsize: 16),
                      CustomText(labeltext: "${model.fNetmebleg} ${"manatSimbol".tr}",fontWeight: FontWeight.w600,fontsize: 16,color: Colors.blue)

                    ],))
              ],
            )

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
