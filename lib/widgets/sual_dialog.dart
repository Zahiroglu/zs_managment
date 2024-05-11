import 'package:flutter/material.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ShowSualDialog extends StatefulWidget {
   ShowSualDialog({
    Key? key,
    required this.messaje,
    required this.callBack,
  }) : super(key: key);

  final String messaje;
  Function(bool) callBack;

  @override
  State<ShowSualDialog> createState() => _ShowSualDialogState();
}

class _ShowSualDialogState extends State<ShowSualDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title:  Text("Diqqet",style: TextStyle(fontWeight: FontWeight.w600)),
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
                foregroundColor: Colors.black, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                elevation: 15,
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();              },
              child: Text("Xeyir"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, padding: const EdgeInsets.all(5),
                elevation: 15,
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                widget.callBack(true);
                print("Beli butonu basildi");
                //Navigator.of(context).pop();
                },
              child: Text("Beli"),
            ),

          ],
        );
  }}