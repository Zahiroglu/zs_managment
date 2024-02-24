import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/sifaris_detallari/controller_sifaris_detal.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';

class ScreenSifarislereBax extends StatefulWidget {
  DrawerMenuController drawerMenuController;
  ScreenSifarislereBax({required this.drawerMenuController,super.key});

  @override
  State<ScreenSifarislereBax> createState() => _ScreenSifarislereBaxState();
}

class _ScreenSifarislereBaxState extends State<ScreenSifarislereBax> {
  bool satisClicked = true;
  bool iadeClicked = false;
  bool kassaClicked = false;
  List<Widget> listPages = [];
  late PageController _controller;
  late int _initialIndex;
  ControllerSifarisDetal controllerSifarisDetal = Get.put(ControllerSifarisDetal());

  @override
  void initState() {
    _initialIndex = (0).floor();
    _controller =
        PageController(initialPage: _initialIndex, viewportFraction: 1);
    _controller.addListener(() {});
    listPages.add(_pageSatis());
    listPages.add(_pageIade());
    listPages.add(_pageKassa());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ControllerSifarisDetal>();
    super.dispose();
  }

  _onPageViewChange(int page) {
    switch (page) {
      case 0:
        setState(() {
          satisClicked = true;
          kassaClicked = false;
          iadeClicked = false;
        });
        break;
      case 1:
        setState(() {
          satisClicked = false;
          kassaClicked = false;
          iadeClicked = true;
        });
        break;
      case 2:
        setState(() {
          satisClicked = false;
          kassaClicked = true;
          iadeClicked = false;
        });
        break;
    }
    _controller.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Material(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  CustomText(
              labeltext: "SATIS",
              fontWeight: FontWeight.bold,
              fontsize: 24,
            ),
            leading: IconButton(
              onPressed: (){
                widget.drawerMenuController.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),

          ),
          body: controllerSifarisDetal.dataLoading.isTrue
              ? Center(
                  child: LoagindAnimation(
                      textData: "Sifarisler axtarilir...",
                      icon: "lottie/locations_search.json",
                      isDark: Get.isDarkMode),
                )
              : SingleChildScrollView(
                child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      _body()],
                  ),
              )),
    ));
  }


  Widget _body() {
    return Column(
      children: [
        _tabBar(),
        _pageView(),
      ],
    );
  }

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.black : Colors.white,
        border: Border.all(color: Get.isDarkMode ? Colors.white : Colors.grey, width: 0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  satisClicked = true;
                  kassaClicked = false;
                  iadeClicked = false;
                  _controller.jumpToPage(0);
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: satisClicked
                        ? Colors.blue
                        : Get.isDarkMode
                            ? Colors.black
                            : Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    border: Border.all(
                        color: satisClicked
                            ? Colors.yellow
                            : Get.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      labeltext: "satis".tr,
                      fontWeight:
                          satisClicked ? FontWeight.bold : FontWeight.normal,
                      color: satisClicked
                          ? Colors.white
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                      fontsize: satisClicked ? 18 : 14,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  satisClicked = false;
                  kassaClicked = false;
                  iadeClicked = true;
                  _controller.jumpToPage(1);
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: iadeClicked
                        ? Colors.blue
                        : Get.isDarkMode
                            ? Colors.black
                            : Colors.white,
                    border: Border.all(
                        color: iadeClicked
                            ? Colors.yellow
                            : Get.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      labeltext: "iade".tr,
                      fontWeight:
                          iadeClicked ? FontWeight.bold : FontWeight.normal,
                      color: iadeClicked
                          ? Colors.white
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                      fontsize: iadeClicked ? 18 : 14,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  _controller.jumpToPage(2);
                  satisClicked = false;
                  kassaClicked = true;
                  iadeClicked = false;
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: kassaClicked
                        ? Colors.blue
                        : Get.isDarkMode
                            ? Colors.black
                            : Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    border: Border.all(
                        color: kassaClicked
                            ? Colors.yellow
                            : Get.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      labeltext: "kassa".tr,
                      fontWeight:
                          kassaClicked ? FontWeight.bold : FontWeight.normal,
                      color: kassaClicked
                          ? Colors.white
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                      fontsize: kassaClicked ? 18 : 14,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _pageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        onPageChanged: _onPageViewChange,
        children: listPages,
      ),
    );
  }

  Widget _pageSatis() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
              controllerSifarisDetal
                      .modelSatisEmeliyyat.value.listSatis!.isNotEmpty
                  ? Expanded(
                      child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: controllerSifarisDetal
                          .listSelectedCariler
                          .map((e) => controllerSifarisDetal.cardSatisItem(e))
                          .toList(),
                    ))
                  : CustomText(labeltext: "Melumat tapilmadi")
            ],
          ),
        ));
  }


  Widget _pageIade() {
    return Column(
      children: [CustomText(labeltext: "Iade")],
    );
  }

  Widget _pageKassa() {
    return Column(
      children: [
        CustomText(
          labeltext: "Kassa",
          color: Colors.red,
        )
      ],
    );
  }
}
