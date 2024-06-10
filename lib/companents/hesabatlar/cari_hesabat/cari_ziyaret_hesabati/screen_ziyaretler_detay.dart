import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/widget_giriscixis_item.dart';

import '../../../../widgets/custom_responsize_textview.dart';
import '../../../users_panel/new_user_create/new_user_controller.dart';
import '../../../giris_cixis/models/model_customers_visit.dart';

class ScreenZiyaretlerDetay extends StatefulWidget {
  User selectedUser;
  List<ModelCustuomerVisit> listVisits;


  ScreenZiyaretlerDetay({required this.selectedUser,required this.listVisits ,super.key});

  @override
  State<ScreenZiyaretlerDetay> createState() => _ScreenZiyaretlerDetayState();
}

class _ScreenZiyaretlerDetayState extends State<ScreenZiyaretlerDetay> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState(() {
              widget.listVisits=widget.listVisits.reversed.toList();
            });
          }, icon: Icon(Icons.sort))
        ],
        centerTitle: true,
        title: CustomText(labeltext: widget.selectedUser.fullName!,),
      ),
      body: _body(),
    );
  }

  Stack itemList(ModelCustuomerVisit element) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: element.isRutDay!? Colors.red : Colors.green,
          margin:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                          labeltext: element.customerName!,
                          fontsize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          overflow: TextOverflow.ellipsis,
                          maxline: 2,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                    CustomText(labeltext: "Giris vaxti :"),
                    SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: element.inDate!.toString().substring(11, 19)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    CustomText(labeltext: "Cixis vaxti :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: element.outDate!.toString().substring(11, 19)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "Vaxt :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: element.workTimeInCustomer!),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: "${element.inDate.toString().substring(0, 11)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: element.isRutDay!? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext: element.isRutDay!? "Rutdan kenar" : "Rut gunu",
                color:element.isRutDay!? Colors.red : Colors.green,
              ),
            ))
      ],
    );
  }

 Widget _body() {
    return ListView.builder(
        itemCount: widget.listVisits.length,
        itemBuilder: (c,index){
      return WidgetGirisCixisItem(element:widget.listVisits.elementAt(index));
    });
 }


}
