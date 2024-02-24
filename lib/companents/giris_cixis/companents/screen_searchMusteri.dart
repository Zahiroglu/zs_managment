import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_text_field.dart';
import '../../base_downloads/models/model_cariler.dart';

class ScreenSearchMusteri extends StatefulWidget {
  List<ModelCariler> listCariler;

  ScreenSearchMusteri({required this.listCariler, super.key});

  @override
  State<ScreenSearchMusteri> createState() => _ScreenSearchMusteriState();
}

class _ScreenSearchMusteriState extends State<ScreenSearchMusteri> {
  TextEditingController ctAxtar = TextEditingController();
  ModelCariler expandedItem = ModelCariler();
  final ScrollController _controller = ScrollController();
  List<ModelCariler> filteredList = [];

  @override
  void initState() {
    if(widget.listCariler.first.mesafe!="s") {widget.listCariler.sort((a, b) => a.mesafeInt!.compareTo(b.mesafeInt!));}
    filteredList =widget.listCariler.getRange(0, widget.listCariler.length).toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              widgetHeader(),
              Expanded(
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: _controller,
                    itemCount: filteredList.length,
                    itemBuilder: (c, index) {
                      return widgetCustomers(filteredList.elementAt(index));
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                }),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: CustomTextField(
                onTextChange: (s) {
                  findUserBayName(s);
                },
                fontsize: 14,
                controller: ctAxtar,
                updizayn: false,
                isImportant: false,
                inputType: TextInputType.text,
                hindtext: 'axtar'.tr,
                containerHeight: 50,
                obscureText: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetCustomers(ModelCariler e) {
    return InkWell(
      onTap: () {
        Get.back(result: e);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    labeltext: e.name!,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    labeltext: e.code!,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontsize: 12,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Divider(height: 1, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomText(
                      fontsize: 12,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      labeltext: "${e.ownerPerson}",
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.social_distance, color: Colors.green),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        labeltext: e.mesafe!,
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    labeltext: " ₼ ",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontsize: 20,
                  ),
                  CustomText(
                    labeltext: " ${e.debt}",
                    color: e.debt.toString().isNotEmpty
                        ? Colors.red
                        : Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  const Spacer(),
                  expandedItem.code == e.code
                      ? const SizedBox()
                      : IconButton(
                          padding: const EdgeInsets.all(0),
                          constraints:
                              const BoxConstraints(maxHeight: 25, maxWidth: 25),
                          onPressed: () {
                            setState(() {
                              expandedItem = e;
                            });
                          },
                          icon: const Icon(Icons.expand_more))
                ],
              ),
              expandedItem.code == e.code
                  ? widgetMoreDataForItems(e)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Container widgetRutGunuItems(String s) => Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: CustomText(labeltext: s, color: Colors.white, fontsize: 12),
      );

  widgetMoreDataForItems(ModelCariler e) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Divider(
            height: 2,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rut Gunu",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              const SizedBox(
                width: 5,
              ),
              Wrap(
                children: [
                  e.days!.any((a) => a.day==1)
                      ? widgetRutGunuItems("gun1".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==2)
                      ? widgetRutGunuItems("gun2".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==3)
                      ? widgetRutGunuItems("gun3".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==4)
                      ? widgetRutGunuItems("gun4".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==5)
                      ? widgetRutGunuItems("gun5".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==6)
                      ? widgetRutGunuItems("gun6".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==7)
                      ? widgetRutGunuItems("bagli".tr)
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                labeltext: "Tam Unvan",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: ScreenUtil.defaultSize.width / 1.7,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  labeltext: "${e.fullAddress}",
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              IconButton(
                  padding: const EdgeInsets.all(0),
                  constraints:
                      const BoxConstraints(maxHeight: 25, maxWidth: 25),
                  onPressed: () {
                    setState(() {
                      expandedItem = ModelCariler();
                    });
                  },
                  icon: const Icon(Icons.expand_less))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rayon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.district}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Sahe",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.area}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Kateqoriya",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.category}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Telefon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.phone}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Voun",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.tin}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void findUserBayName(String s) {
    if (s.toString().isNotEmpty) {
      filteredList = widget.listCariler
          .where(
              (element) => element.name!.toString().toUpperCase().contains(s.toUpperCase()) || element.code!.toString().toUpperCase().contains(s.toUpperCase()))
          .toList();
    } else {
      filteredList=widget.listCariler;
    }
    setState(() {
    });
  }
}
