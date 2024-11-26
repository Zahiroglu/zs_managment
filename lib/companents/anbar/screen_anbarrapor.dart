import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import 'model_anbarrapor.dart';

class ScreanAnbarRapor extends StatefulWidget {
  List<ModelAnbarRapor> listMehsullar;

  ScreanAnbarRapor({Key? key, required this.listMehsullar}) : super(key: key);

  @override
  _ScreanAnbarRaporState createState() => _ScreanAnbarRaporState();
}

class _ScreanAnbarRaporState extends State<ScreanAnbarRapor> {
  List<String> listFiler = [];
  bool hamisisecildi = true;
  String? selectedMenu;

  @override
  void initState() {
    listFiler = ['Hamisi','Stockda olanlar', 'Stock outlar'];
    selectedMenu=listFiler.elementAt(0);
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: CustomText(labeltext: widget.listMehsullar.first.anaqrup!),
            centerTitle: true,
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
                  (int index) => MenuItemButton(
                    onPressed: () => setState(() => selectedMenu = listFiler[index]),
                    //child: CustomText(labeltext: listFiler.elementAt(index).toString()),
                    child: Text(listFiler.elementAt(index)),
                  ),
                ),
              ),
            ],
          ),
          body: _body(context),
        ),
      ),
    );
  }

  String prettify(double d) {
    return d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.86,
          child: ListView(
            children: widget.listMehsullar
                .map((element) => _customItems(element))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _customItems(ModelAnbarRapor element) {
    print("element.satisqiymeti :"+element.satisqiymeti.toString());
    bool stockOut = double.parse(element.qaliq.toString()) <= 0 ? true : false;
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: stockOut ? Colors.red : Colors.green),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          labeltext: "Stock Kod : ",
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                          height: 2, color: Colors.black, thickness: 1),
                      const SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                          height: element.stokadi!.length > 37 ? 38 : 20,
                          child: element.stokadi!.length > 37
                              ? Center(
                                  child: CustomText(
                                      labeltext: "Stock Ad : ",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600))
                              : CustomText(
                                  labeltext: "Stock Ad : ",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 3,
                      ),
                      const Divider(
                          height: 2, color: Colors.black, thickness: 1),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomText(
                          labeltext: "Qaliq : ",
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              labeltext: element.stokkod!,
                              fontWeight: FontWeight.normal),
                          CustomText(
                              color: Colors.blue,
                              labeltext:
                                  "${prettify(double.parse(element.satisqiymeti!.isNotEmpty?element.satisqiymeti.toString() :"0"))} ₼",
                              fontWeight: FontWeight.bold,
                              fontsize: 16),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: element.stokadi!.length > 37 ? 38 : 18,
                          child: CustomText(
                            labeltext: element.stokadi!,
                            fontWeight: FontWeight.normal,
                            maxline: 2,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                          labeltext: element.qaliq! + " " + element.vahidbir!,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
