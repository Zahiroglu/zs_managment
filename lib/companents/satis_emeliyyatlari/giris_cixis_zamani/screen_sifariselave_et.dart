import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/controller_satis.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

class ScreenSifarisElaveEt extends StatefulWidget {
  ControllerSatis controllerSatis;

  ScreenSifarisElaveEt({required this.controllerSatis, super.key});

  @override
  State<ScreenSifarisElaveEt> createState() => _ScreenSifarisElaveEtState();
}

class _ScreenSifarisElaveEtState extends State<ScreenSifarisElaveEt> {
  TextEditingController ctMiqdar = TextEditingController();
  final List<TextEditingController> _controllers = [];
  bool mustSearch=false;
  TextEditingController ctSearcha=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        //ctSearch.dispose();
        mustSearch=false;
        Get.back(result: true);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              actions: [
                mustSearch?IconButton(onPressed: (){
                  setState(() {
                    mustSearch=false;
                    ctSearcha.text="";
                    widget.controllerSatis.filterMehsul("");

                  });

                }, icon: const Icon(Icons.clear)): IconButton(onPressed: (){
                  setState(() {
                    mustSearch=true;
                  });
                }, icon: const Icon(Icons.search_outlined))
              ],
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              title: !mustSearch?CustomText(labeltext:  widget.controllerSatis.selectedAnaQrup.value.toString()):searchField(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _body(context),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _footer(context)),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget searchField(){
    return  SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller:ctSearcha,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          onChanged: (st){
            widget.controllerSatis.filterMehsul(st);
            setState(() {});
          },
          decoration: const InputDecoration(
              hintText: "Axtar...",
              contentPadding: EdgeInsets.all(0),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.redAccent)),
              border: OutlineInputBorder(
              borderSide:  BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),

        ));
  }


  Widget _body(BuildContext context) {
    return Obx(() => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
              itemCount: widget.controllerSatis.filterlistMehsullar.length,
              itemBuilder: (context, index) {
                _controllers.add(TextEditingController());
                return widgetMehsul(
                    widget.controllerSatis.filterlistMehsullar.elementAt(index),
                    index);
              }),

        ));
  }

  Widget _footer(BuildContext context) {
    ModelAnaQrupAnbar modelAnaQrupAnbar=widget.controllerSatis.selectedAnaQrupModel;
    int index= widget.controllerSatis.listAnaQruplar.indexOf(widget.controllerSatis.selectedAnaQrupModel);
    print("Index :"+index.toString());
    print("modelAnaQrupAnbar :"+modelAnaQrupAnbar.toString());
    return Obx(() => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.14,
          child: DecoratedBox(
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(-2, 0),
                      color: Colors.grey,
                      spreadRadius: 0.1,
                      blurRadius: 5)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Total satis : ",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        labeltext:
                            widget.controllerSatis.listAnaQruplar.indexOf(widget.controllerSatis.selectedAnaQrupModel)!=0?
                            "${prettify(widget.controllerSatis.listSifarisler.where((element) => element.anaQrup == widget.controllerSatis.selectedAnaQrup.value).fold(0.0, (sum, item) => sum + item.netSatis!))} ₼"
                               : "${prettify(widget.controllerSatis.listSifarisler.fold(0.0, (sum, item) => sum + item.netSatis!))} ₼",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Total endirim : ",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        labeltext:
                        widget.controllerSatis.listAnaQruplar.indexOf(widget.controllerSatis.selectedAnaQrupModel)!=0?
                        "${prettify(widget.controllerSatis.listSifarisler.where((element) => element.anaQrup == widget.controllerSatis.selectedAnaQrup.value).fold(0.0, (sum, item) => sum + item.endirimMebleg!))} ₼"
                            : "${prettify(widget.controllerSatis.listSifarisler.fold(0.0, (sum, item) => sum + item.endirimMebleg!))} ₼",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Satis brut : ",
                        fontsize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      CustomText(
                        labeltext:
                        widget.controllerSatis.listAnaQruplar.indexOf(widget.controllerSatis.selectedAnaQrupModel)!=0?
                        "${prettify(widget.controllerSatis.listSifarisler.where((element) => element.anaQrup == widget.controllerSatis.selectedAnaQrup.value).fold(0.0, (sum, item) => sum + item.netSatis!) - widget.controllerSatis.listSifarisler.where((element) => element.anaQrup == widget.controllerSatis.selectedAnaQrup.value).fold(0.0, (sum, item) => sum + item.endirimMebleg!))} ₼"
                            : "${prettify(widget.controllerSatis.listSifarisler.fold(0.0, (sum, item) => sum + item.netSatis!)-widget.controllerSatis.listSifarisler.fold(0.0, (sum, item) => sum + item.endirimMebleg!))} ₼",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget widgetMehsul(ModelAnbarRapor element, index) {
    if (widget.controllerSatis.listSifarisler
        .any((el) => el.stockKod == element.stokkod)) {
      ctMiqdar.text = (widget.controllerSatis.listSifarisler
              .where((p) => p.stockKod == element.stokkod)
              .first
              .miqdar)
          .toString();
    } else {
      ctMiqdar.text = "0";
    }
    return itemsMuhsul(element, index);
  }

  String prettify(double d) {
    return d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  Widget itemsMuhsul(ModelAnbarRapor element, int index) {
    if (widget.controllerSatis.listSifarisler.any((el) => el.stockKod == element.stokkod)) {
      _controllers.elementAt(index).text = (widget
              .controllerSatis.listSifarisler
              .where((p) => p.stockKod == element.stokkod)
              .first
              .miqdar)
          .toString();
    } else {
      _controllers.elementAt(index).text = "0";
    }
    return Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: CustomText(
                              textAlign: TextAlign.center,
                              labeltext: "NO PHOTO",
                              maxline: 2,
                            ),
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                            labeltext: element.stokkod.toString(),
                            fontWeight: FontWeight.w700),
                        const SizedBox(
                          height: 2,
                        ),
                        CustomText(
                          labeltext: element.stokadi.toString(),
                          fontWeight: FontWeight.w600,
                          maxline: 2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(color: Colors.black)),
                              padding: const EdgeInsets.all(3),
                              child: CustomText(labeltext: element.vahidbir!),
                            ),
                            Container(
                              width: 200,
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _sifarisSil(element);
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                      ),
                                      padding: const EdgeInsets.all(0)),
                                  SizedBox(
                                      height: 40,
                                      width: 90,
                                      child: TextField(
                                        controller:
                                            _controllers.elementAt(index),
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        onSubmitted: (s) {
                                          _onsubmit(s, element, index);
                                        },
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(0),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.redAccent))),
                                      )),
                                  IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        _sifarisElaveEt(element);
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Colors.blue,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: CustomText(
                labeltext:
                    "${prettify(double.parse(element.satisqiymeti ?? "0"))} ₼",
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontsize: 16,
              ))
        ],
      ),
    );
  }

  void _sifarisElaveEt(ModelAnbarRapor element) {
    int miqdar = 0;
    if (widget.controllerSatis.listSifarisler.any((el) => el.stockKod == element.stokkod)) {
      miqdar = widget.controllerSatis.listSifarisler.where((p) => p.stockKod == element.stokkod).first.miqdar!;
    }
    miqdar = miqdar + 1;
    widget.controllerSatis.addSatisToList(element, miqdar);
    setState(() {});
  }

  void _sifarisSil(ModelAnbarRapor element) {
    int miqdar = 0;
    if (widget.controllerSatis.listSifarisler
        .any((el) => el.stockKod == element.stokkod)) {
      miqdar = widget.controllerSatis.listSifarisler
          .where((p) => p.stockKod == element.stokkod)
          .first
          .miqdar!;
    }
    miqdar = miqdar - 1;
    widget.controllerSatis.remuveSatisToList(element, miqdar);
    setState(() {});
  }

  void _onsubmit(String s, ModelAnbarRapor element, int index) {
    if (widget.controllerSatis.listSifarisler.any((el) => el.stockKod == element.stokkod)) {
      if (widget.controllerSatis.listSifarisler
              .where((p) => p.stockKod == element.stokkod)
              .first
              .miqdar! <
          int.parse(_controllers.elementAt(index).text.toString())) {
        widget.controllerSatis.addSatisToList(
            element, int.parse(_controllers.elementAt(index).text.toString()));
      } else {
        widget.controllerSatis.remuveSatisToList(
            element, int.parse(_controllers.elementAt(index).text.toString()));
      }
    } else {
      widget.controllerSatis.addSatisToList(
          element, int.parse(_controllers.elementAt(index).text.toString()));
    }
    setState(() {});
  }
}
