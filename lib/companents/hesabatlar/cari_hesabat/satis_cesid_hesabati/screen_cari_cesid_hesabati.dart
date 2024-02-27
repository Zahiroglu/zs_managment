
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_cesid_hesabati/model_caricesid.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/double_round_helper.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenCariCesidHesabati extends StatefulWidget {
  String tarixIlk;
  String tarixSon;
  String cariKod;
   ScreenCariCesidHesabati({required this.tarixIlk,
     required this.tarixSon,
     required this.cariKod,super.key});

  @override
  State<ScreenCariCesidHesabati> createState() => _ScreenCariCesidHesabatiState();
}

class _ScreenCariCesidHesabatiState extends State<ScreenCariCesidHesabati> {
  bool isLoading = false;
  bool dataFounded = false;
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  List<ModelCariCesid> listData = [];
  List<String> listTarixler=[];
  List<String> listCesidSayi=[];
  DoubleRoundHelper doubleRound = DoubleRoundHelper();
  List<String> listFiler = [];

  @override
  void initState() {
    getDataFromServer();
    // TODO: implement initState
    super.initState();
  }

  getDataFromServer() async {
    listData = await getDataFromServerUmumiCariler(widget.tarixIlk, widget.tarixSon,widget.cariKod);
    setState(() {
    });
  }

  Future<List<ModelCariCesid>> getDataFromServerUmumiCariler(String tarix1,String tarix2,
      String cariKod) async {
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
    <cari_stok_hereket xmlns="http://tempuri.org/">
      <tarix1>$tarix1</tarix1>
      <tarix2>$tarix2</tarix2>
      <cari>$cariKod</cari>
    </cari_stok_hereket>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/cari_stok_hereket",
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

  Future<List<ModelCariCesid>> _parsingCariler(var _response) async {
    listFiler.clear();
    listFiler.add("hamisi".tr);
    List<ModelCariCesid> listKodrdinar = [];
    var document = xml.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var tarix = _getValue(item.findElements("TARIX"));
      var stockKod = _getValue(item.findElements("STOK_KOD"));
      var stockAd = _getValue(item.findElements("STOK_AD"));
      var anaQrup = _getValue(item.findElements("ANA_GRUP"));
      var cariKod = _getValue(item.findElements("CARI_KOD"));
      var cariAd = _getValue(item.findElements("CARI_AD"));
      var expKod = _getValue(item.findElements("TEMSILCI_KOD"));
      var expAd = _getValue(item.findElements("TEMSILCI_AD"));
      var miqdar = _getValue(item.findElements("MIQDAR"));
      var qiymet = _getValue(item.findElements("QIYMET"));
      var mebleg = _getValue(item.findElements("MEBLEG"));
      var endirim1 = _getValue(item.findElements("ENDIRIM1"));
      var endirim2 = _getValue(item.findElements("ENDIRIM2"));
      var netMebleg = _getValue(item.findElements("NET_MEBLEG"));
      if(!listTarixler.contains(tarix)){
        listTarixler.add(tarix);
      }
      if(!listCesidSayi.contains(stockKod)){
        listCesidSayi.add(stockKod);
      }
      ModelCariCesid model=ModelCariCesid(tarix: tarix,
          stockKod: stockKod,
          stockAd: stockAd,
          anaQrup: anaQrup,
          cariKod: cariKod,
          cariAd: cariAd,
          expKod: expKod,
          expAd: expAd,
          miqdar: miqdar,
          qiymet: qiymet,
          mebleg: mebleg,
          endirim1: endirim1,
          endirim2: endirim2,
          netMebleg: netMebleg);
      listKodrdinar.add(model);
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
                labeltext: isLoading?"":listData.first.cariAd,
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
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 15,bottom: 5,right: 15, top: 5),
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
        CustomText(labeltext: "${"totalCesidSay".tr} : ${listCesidSayi.length}",color: Colors.white,fontWeight: FontWeight.w600),
        CustomText(labeltext: "${"totalMebleg".tr} : ${doubleRound.prettify(listData.fold(0.0, (sum, element) => sum+double.parse(element.netMebleg)))} ${"manatSimbol".tr}",color: Colors.white,fontWeight: FontWeight.w600)
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
                itemCount: listTarixler.length,
                itemBuilder: (context, index) {
                  return _widgetListItem(listTarixler.elementAt(index));
                }),
          ),
        )
      ],
    );
  }

  _widgetListItem(String tarix) {
    int say=listData.where((element) => element.tarix==tarix).toList().length;
    double satis=listData.where((element) => element.tarix==tarix).toList().fold(0.0, (sum, element) => sum+double.parse(element.netMebleg));
    return InkWell(
      onTap: (){
        Get.toNamed(RouteHelper.cariSatilanCesidRaporuMal,arguments: [listData.where((element) => element.tarix==tarix).toList()]);

      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                CustomText(labeltext: tarix.substring(0,10),fontsize: 18,fontWeight: FontWeight.w800,),
                CustomText(labeltext: "${"cesidSay".tr} : $say",fontsize: 16,fontWeight: FontWeight.w500,),
              ],),
              Align(
                alignment: Alignment.topRight,
                child: CustomText(labeltext: doubleRound.prettify(satis)+" "+"manatSimbol".tr,color: Colors.blue,fontsize: 16,fontWeight: FontWeight.w700),
              )
            ],
          ),
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
