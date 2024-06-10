
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_cesid_hesabati/model_caricesid.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/double_round_helper.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../../../dio_config/api_client.dart';
import '../../../../utils/checking_dvice_type.dart';
import '../../../local_bazalar/local_users_services.dart';
import '../../../login/models/logged_usermodel.dart';

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
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices localUserServices = LocalUserServices();
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  void initState() {
    getDataFromServer();
    // TODO: implement initState
    super.initState();
  }

  getDataFromServer() async {
    localUserServices.init();
    setState(() {
      isLoading = true;
    });
    listData = await getDataFromServerUmumiCariler(widget.tarixIlk, widget.tarixSon,widget.cariKod);
    setState(() {
      isLoading = false;
    });
  }

  Future<List<ModelCariCesid>> getDataFromServerUmumiCariler(String tarixIlk, String tarixSon,String ckod) async {
    listData.clear();

    List<ModelCariCesid> listProducts = [];
    languageIndex = await getLanguageIndex();
    var data={
      "Code": ckod,
      "fromDate": tarixIlk,
      "toDate": tarixSon
    };
    int dviceType = checkDviceType.getDviceType();
    loggedUserModel=localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio().post(
          "${loggedUserModel.baseUrl}/api/v1/Report/warehouse-operation-by-customer",
          data:data,
          options: Options(
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer $accesToken"
            },

            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 200) {
          var dataModel = json.encode(response.data['result']);
          List listuser = jsonDecode(dataModel);
          for (var i in listuser) {
            ModelCariCesid model=ModelCariCesid.fromJson(i);
            listProducts.add(model);
            if(!listTarixler.contains(model.tarix)){
              listTarixler.add(model.tarix);
            }
            if(!listCesidSayi.contains(model.stockKod)){
              listCesidSayi.add(model.stockKod);
            }
          }
        } else {
          exeptionHandler.handleExeption(response);
        }

      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    return listProducts;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
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
                labeltext: isLoading||listData.isEmpty?"":listData.first.cariAd,
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
    return listData.isEmpty?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NoDataFound(title: "melumattapilmadi".tr,),
      ],
    ):Column(
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
