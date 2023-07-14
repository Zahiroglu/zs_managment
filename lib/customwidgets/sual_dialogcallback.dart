import 'package:flutter/material.dart';

class ShowSualDialogCallBack extends StatefulWidget {
   ShowSualDialogCallBack({
    Key? key,
    required this.messaje,
    required this.callBack,
  }) : super(key: key);

  final String messaje;
  Function(String value) callBack;

  @override
  State<ShowSualDialogCallBack> createState() => _ShowSualDialogCallBackState();
}

class _ShowSualDialogCallBackState extends State<ShowSualDialogCallBack> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title:  Text("Diqqet"),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(widget.messaje.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(5),
                elevation: 15,
                minimumSize: Size(100, 50),
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();              },
              child: Text("xeyir"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(5),
                elevation: 15,
                minimumSize: Size(100, 50),
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                widget.callBack("ok");
                Navigator.of(context).pop();              },
              child: Text("beli"),
            ),

          ],
        );
  }}