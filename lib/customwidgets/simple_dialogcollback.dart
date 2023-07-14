import 'package:flutter/material.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';


class ShowInfoDialogWithCallBack extends StatelessWidget {
  ShowInfoDialogWithCallBack({
    Key? key,
    required this.messaje,
    required this.icon,
     required this.callback,
  }) : super(key: key);

  final String messaje;
  final IconData icon;
  final Function(String value) callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(color: Colors.black, offset: Offset(2, 5))
              ]),
          height: ResponsiveBuilder.isMobile(context)?MediaQuery.of(context).size.height * 0.38:ResponsiveBuilder.islandspace(context)
              ? MediaQuery.of(context).size.height * 0.4
              : MediaQuery.of(context).size.height * 0.3,
          width: ResponsiveBuilder.isMobile(context)?MediaQuery.of(context).size.width * 0.9:ResponsiveBuilder.islandspace(context)
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: MediaQuery.of(context).size.height * 0.08,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                      messaje,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.white,
                      elevation: 5,
                      minimumSize: const Size(200, 50)),
                  onPressed: () {
                    callback("ok");
                    Navigator.of(context).pop();
                  },
                  child:  Text("Bagla"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}