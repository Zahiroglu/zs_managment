import 'package:flutter/material.dart';
import 'package:zs_managment/companents/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class RoutDetailScreenUsers extends StatefulWidget {
  DrawerMenuController drawerMenuController;
  RoutDetailScreenUsers({required this.drawerMenuController,super.key});

  @override
  State<RoutDetailScreenUsers> createState() => _RoutDetailScreenUsersState();
}

class _RoutDetailScreenUsersState extends State<RoutDetailScreenUsers> {
  ControllerRoutDetailUser controllerRoutDetailUser = Get.put(ControllerRoutDetailUser());
  PageController scrollController=PageController();
  @override
  void initState() {

    scrollController.addListener(() {
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    Get.delete<ControllerRoutDetailUser>();
    scrollController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            labeltext: "temsilciler".tr,
            textAlign: TextAlign.center,
            fontsize: 22,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            onPressed: (){
              widget.drawerMenuController.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),

        ),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 0,
              ),
              Obx(
                    () => controllerRoutDetailUser.dataLoading.isFalse
                    ? _body(context)
                    : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _body(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            _widgetTamItems(context,"Exp"),
            const SizedBox(width: 20,),
            _widgetTamItems(context,"Merc"),
            const Spacer(),
          ],
        ),
        _pageView(),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomElevetedButton(
            label: "temsilciSec".tr,
            cllback: () {
              controllerRoutDetailUser.createDialogTogetExpCode(context);
            },
            fontWeight: FontWeight.w800,
            surfaceColor: Colors.white,
            elevation: 5,
            icon: Icons.add,
            borderColor: Colors.blue,
            width: 200,
            height: 35,
          ),
        )
      ],
    );
  }

  Widget _filteredListUsersItems(UserModel element) {
    return InkWell(
      onTap: (){
        controllerRoutDetailUser.temsilciMelumatlariniGetir(element);
      },
      child: Stack(
        children: [
          Card(
              margin: const EdgeInsets.all(10).copyWith(left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(
                        element.gender == 0
                            ? "images/imageman.png"
                            : "images/imagewoman.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: element.name??"Melumat tapilmadi",
                          fontsize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        CustomText(
                          labeltext: element.roleName!,
                          fontsize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
              top: 15,
              right: 35,
              child: CustomText(
                labeltext: element.code!,
                fontsize: 14,
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    );
  }

 Widget _widgetTamItems(BuildContext context, String s) {
    int usercount=0;
    String vezifeAdi="";
    if(s=="Exp"){
      vezifeAdi="expeditor".tr;
      usercount=controllerRoutDetailUser.listUsers.where((p) => p.roleId==17).length;
    }else{
      usercount=controllerRoutDetailUser.listUsers.where((p) => p.roleId==23).length;
      vezifeAdi="merc".tr;

    }
    return InkWell(
      onTap: (){
        setState(() {
          if(s=="Exp"){
            scrollController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          }else{
            scrollController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          }
          controllerRoutDetailUser.fistTabSelected.value=s;
          controllerRoutDetailUser.changeUsers(s);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width*0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:  controllerRoutDetailUser.fistTabSelected.value==s?Colors.green:Colors.white,
          border: Border.all(color:  controllerRoutDetailUser.fistTabSelected.value==s?Colors.white:Colors.green),
          boxShadow: controllerRoutDetailUser.fistTabSelected.value==s? [
            BoxShadow(
              color:  controllerRoutDetailUser.fistTabSelected.value==s?Colors.black45:Colors.grey,
              offset: Offset(2,2),
              blurRadius: 2,
              spreadRadius: 1
            )
          ]:[]
        ),
        child: Center(child: CustomText(labeltext: "$vezifeAdi ($usercount)",color:  controllerRoutDetailUser.fistTabSelected.value==s?Colors.white:Colors.green,fontWeight:  controllerRoutDetailUser.fistTabSelected.value==s?FontWeight.bold:FontWeight.normal,)),
      ),
    );
 }

  _pageView() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
      child: PageView(
        controller: scrollController,
        onPageChanged: _onPageChange,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.only(bottom: 10),
            child: controllerRoutDetailUser.filteredListUsers.isNotEmpty?ListView.builder(
                shrinkWrap: true,
                itemCount: controllerRoutDetailUser.filteredListUsers.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _filteredListUsersItems(controllerRoutDetailUser.filteredListUsers.elementAt(index));
                }):Center(
              child: CustomText(labeltext: "mtapilmadi".tr,fontsize: 16),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.only(bottom: 10),
            child: controllerRoutDetailUser.filteredListUsers.isNotEmpty?ListView.builder(
                shrinkWrap: true,
                itemCount: controllerRoutDetailUser.filteredListUsers.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _filteredListUsersItems(controllerRoutDetailUser.filteredListUsers.elementAt(index));
                }):Center(
              child: CustomText(labeltext: "mtapilmadi".tr,fontsize: 16),
            ),
          ),

        ],
      ),
    );
  }



  void _onPageChange(int value) {
    if(value==0){
      controllerRoutDetailUser.fistTabSelected.value="Exp";
      controllerRoutDetailUser.changeUsers("Exp");
    }else{
      controllerRoutDetailUser.fistTabSelected.value="Merc";
      controllerRoutDetailUser.changeUsers("Merc");
    }
    setState(() {
    });
  }
}
