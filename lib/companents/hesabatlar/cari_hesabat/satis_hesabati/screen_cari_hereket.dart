import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_hesabati/model_cari_hereket.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/double_round_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenCariHereket extends StatefulWidget {
  String tarixIlk;
  String tarixSon;
  String cariKod;

  ScreenCariHereket({required this.tarixIlk,
    required this.tarixSon,
    required this.cariKod,
    super.key});

  @override
  State<ScreenCariHereket> createState() => _ScreenCariHereketState();
}

class _ScreenCariHereketState extends State<ScreenCariHereket> {
  bool isLoading = false;
  bool dataFounded = false;
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  List<ModelCariHereket> listData = [];
  List<ModelCariHereket> listDataFitred = [];
  DoubleRoundHelper doubleRound = DoubleRoundHelper();
  List<String> listFiler = [];
  bool totalFooterVisible=false;
  String selectedFilter="Hamisi";

  @override
  void initState() {
    getDataFromServer();
    // TODO: implement initState
    super.initState();
  }

  getDataFromServer() async {
    listData = await getDataFromServerUmumiCariler(widget.cariKod, widget.tarixIlk, widget.tarixSon);
  }

  Future<List<ModelCariHereket>> getDataFromServerUmumiCariler(String cari, String tarixIlk, String tarixSon) async {
    print("serviz yeniden ise dusdu");
    listData.clear();
    listDataFitred.clear();
    setState(() {
      isLoading = true;
    });
    var envelopeaUmumicariler = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <Hereket xmlns="http://tempuri.org/">
      <cari>$cari</cari>
      <tarix1>$tarixIlk</tarix1>
      <tarix2>$tarixSon</tarix2>
    </Hereket>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/Hereket",
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

  Future<List<ModelCariHereket>> _parsingCariler(var _response) async {
    listFiler.clear();
    listFiler.add("hamisi".tr);
    List<ModelCariHereket> listKodrdinar = [];
    var document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var tarix = _getValue(item.findElements("HEREKET_TARIXI"));
      var ckod = _getValue(item.findElements("MUSTERI_KODU"));
      var cad = _getValue(item.findElements("MUSTERI_ADI"));
      var expKod = _getValue(item.findElements("TEMSILCI_KODU"));
      var expAd = _getValue(item.findElements("TEMSILCI_ADI"));
      var senedTipi = _getValue(item.findElements("SENED_TIPI"));
      var borcMebleg = _getValue(item.findElements("BORC_MRBLEGI"));
      var alacaqMebleg = _getValue(item.findElements("ALACAQ_MEBLEGI"));
      var borcBalans = _getValue(item.findElements("BORC_BALANSI"));
      var seri = _getValue(item.findElements("SERI"));
      var sira = _getValue(item.findElements("SIRA"));
      var mLimit = _getValue(item.findElements("MUSTERI_LIMIT"));
      var recNom = _getValue(item.findElements("RECno"));
      if(!listFiler.contains(senedTipi)){
        if(senedTipi!="İLKİN QALIQ"){
          listFiler.add(senedTipi);}
        }
      ModelCariHereket modelHereketrapor = ModelCariHereket(
          hLimit: mLimit,
          hAlacaqmeblegi: alacaqMebleg,
          hBorcbalans: borcBalans,
          hBorcmeblegi: borcMebleg,
          hMusteriadi: cad,
          hMusterikodu: ckod,
          hRecno: recNom,
          hSenedtipi: senedTipi,
          hSeri: seri,
          hSira: sira,
          hTarixi: tarix,
          hTemsilciadi: expAd,
          hTemsilcikodu: expKod);
      listKodrdinar.add(modelHereketrapor);
      listDataFitred.add(modelHereketrapor);
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
                labeltext: "Hereket raporu",
              ),
              actions: [
                MenuAnchor(
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.sort),
                      tooltip: 'Show menu',
                    );
                  },
                  menuChildren: List<MenuItemButton>.generate(
                    listFiler.length,
                        (int index) =>
                        MenuItemButton(
                          onPressed: () =>
                              setState(() => _filterList(listFiler[index])),
                          child: Text(listFiler.elementAt(index)),
                        ),
                  ),
                ),
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
        totalFooterVisible?_widgetTotalFooter(context):SizedBox()
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
                  labeltext:
                  "${listData.first.hMusterikodu}-${listData.first
                      .hMusteriadi}",
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
                  labeltext:
                  "${listData.first.hTemsilcikodu}-${listData.first.hTemsilciadi
                      .replaceAllMapped(
                    RegExp("[-+.^:,1234567890()]"),
                        (match) => "",
                  )}",
                  color: Colors.white,
                  maxline: 2,
                ),
                const SizedBox(
                  height: 2,
                ),
                Divider(height: 0.2, color: Colors.white, thickness: 0.2),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  labeltext: "${widget.tarixIlk}-${widget.tarixSon}",
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
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      labeltext: "${"ilkinQaliq".tr} : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:
                      "${doubleRound.prettify(double.parse(
                          listData.first.hBorcmeblegi))} ${"manatSimbol".tr}",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    CustomText(
                      labeltext: "toplamBorc".tr + " : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:
                      "${doubleRound.prettify(listData.fold(
                          0.0, (sum, element) => sum +
                          double.parse(element.hBorcmeblegi)))} ${"manatSimbol"
                          .tr}",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    CustomText(
                      labeltext: "toplamAlacaq".tr + " : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:
                      "${doubleRound.prettify(listData.fold(
                          0.0, (sum, element) => sum + double.parse(
                          element.hAlacaqmeblegi)))} ${"manatSimbol".tr}",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    CustomText(
                      labeltext: "sonQaliq".tr + " : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:
                      "${doubleRound.prettify(double.parse(
                          listData.last.hBorcbalans))} ${"manatSimbol".tr}",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    CustomText(
                      labeltext: "mLimit".tr + " : ",
                      color: Colors.white,
                    ),
                    CustomText(
                      labeltext:
                      "${doubleRound.prettify(
                          double.parse(listData.last.hLimit))} ${"manatSimbol"
                          .tr}",
                      color: Colors.white,
                    ),
                  ],
                ),
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
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: CustomText(
                      labeltext: "tarixS".tr,
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        labeltext: "borcM".tr,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        labeltext: "alacaqM".tr,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        labeltext: "borcB".tr,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 18,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
                itemCount: listDataFitred.length,
                itemBuilder: (context, index) {
                  return _widgetListItem(listDataFitred.elementAt(index));
                }),
          ),
        )
      ],
    );
  }

  _widgetListItem(ModelCariHereket model) {
    Color backColor = Colors.green.withOpacity(0.7);
    switch (model.hSenedtipi) {
      case "İLKİN QALIQ":
        backColor = Colors.green;
        break;
      case "GERİ QAYTARMA":
        backColor = Colors.deepOrange.withOpacity(0.7);
        break;
      case "BANKA DAXİLOLMA" || "KASSA MƏDAXİL":
        backColor = Colors.blueAccent.withOpacity(0.7);
        break;
    }
    return InkWell(
      onTap: (){
        if(model.hSeri.isNotEmpty){
        Get.toNamed(RouteHelper.fackturaHesabati,arguments: [model.hRecno,model.hSenedtipi]);
        }
      },
      child: Card(
        surfaceTintColor: Colors.grey,
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(12)),
                    color: backColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(labeltext: model.hSenedtipi,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      const SizedBox(height: 2,),
                      const Divider(height: 1,
                        color: Colors.black,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,),
                      const SizedBox(height: 2,),
                      CustomText(labeltext: "seri".tr + " : " + model.hSeri,),
                      CustomText(labeltext: "sira".tr + " : " + model.hSira,),
                      CustomText(labeltext: model.hTarixi.substring(0, 10),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,)

                    ],
                  ),
                )),
            Expanded(
              flex: 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(left: 5, top: 10),
                    child: CustomText(
                      labeltext: "${doubleRound.prettify(
                          double.parse(model.hBorcmeblegi))} ${"manatSimbol".tr}",
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(left: 0, top: 10),
                    child: CustomText(
                      labeltext: "${doubleRound.prettify(
                          double.parse(model.hAlacaqmeblegi))} ${"manatSimbol"
                          .tr}",
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(
                        left: 0, top: 10, right: 5),
                    child: CustomText(
                      labeltext: "${doubleRound.prettify(
                          double.parse(model.hBorcbalans))} ${"manatSimbol".tr}",
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.start,
                      fontsize: 14,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _widgetTotalFooter(BuildContext context){
    double summaFilter=0;
    if(selectedFilter=="SATIŞ FAKTURASI"){
      summaFilter=listDataFitred.fold(0.0, (sum, element) => sum+double.parse(element.hBorcmeblegi));
    }else{
      summaFilter=listDataFitred.fold(0.0, (sum, element) => sum+double.parse(element.hAlacaqmeblegi));
    }
    return Padding(
      padding: const EdgeInsets.all(0.0).copyWith(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        CustomText(labeltext: "TOTAL "+selectedFilter+" : ",fontWeight: FontWeight.w700),
        CustomText(labeltext: doubleRound.prettify(summaFilter)+ "manatSimbol".tr,fontWeight: FontWeight.w700),

      ],),
    );
  }

  _filterList(String data) {
    selectedFilter=data;
    listDataFitred.clear();
    setState(() {
      if(data==listFiler.first.toString()){
        totalFooterVisible=false;
       listData.forEach((element) {listDataFitred.add(element);});
      }else {
        totalFooterVisible=true;
        for (var element in listData) {
          if (element.hSenedtipi == data) {
            listDataFitred.add(element);
          }
        }
      }});
  }
}
