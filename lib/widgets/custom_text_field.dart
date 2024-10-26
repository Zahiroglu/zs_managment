import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {required this.controller,
      required this.inputType,
      this.icon,
      this.suffixIcon,
      this.onTextChange,
      this.onTopVisible,
      this.onSubmit,
      this.maxLines=1,
      this.containerHeight = 60,
      required this.hindtext,
      required this.fontsize,
      this.valdateText,
      this.obscureText=false,
      this.updizayn = true,
      this.align=TextAlign.start,
      this.isvalid,
      this.readOnly=false,
        this.isImportant=false,
        this.hintTextColor=Colors.grey,
        this.textColor,
        this.borderColor=Colors.grey,
        this.hasBourder=true,
        this.hasLabel=false,
      Key? key})
      : super(key: key);
  TextEditingController controller;
  TextInputType inputType;
  IconData? icon;
  IconData? suffixIcon;
  String hindtext;
  double fontsize;
  String? valdateText;
  bool? isvalid;
  bool readOnly=false;
  bool? hasBourder;
  bool obscureText=false;
  double? containerHeight;
  bool updizayn;
  Function(String txt)? onTextChange;
  Function? onTopVisible;
  Function(String txt)? onSubmit;
  TextAlign align;
  Color hintTextColor;
  Color? textColor;
  Color? borderColor;
  bool isImportant=false;
  bool hasLabel=false;
  int maxLines;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  var maskFormatter = MaskTextInputFormatter(
      mask: '+994 (##) ###-##-##',
      filter: { "#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return widget.isImportant ? Stack(
            children: [
              Container(
                height: widget.containerHeight,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: TextFormField(
                  maxLines:  widget.maxLines,
                  onFieldSubmitted: (s){
                    if(s.isEmpty) {
                      widget.onSubmit!.call(s);
                    }},
                  inputFormatters: widget.inputType == TextInputType.phone ? <
                      TextInputFormatter>[maskFormatter,
                  ] : [],
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: widget.align,
                  obscureText: widget.obscureText!,
                  validator: (value) =>
                  value!.isEmpty
                      ? widget.isvalid!
                      ? widget.valdateText
                      : null
                      : null,
                  // onSaved: (value) => _email = value,
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  keyboardType: widget.inputType,
                  style: TextStyle(
                    fontSize: widget.fontsize,
                    color: widget.textColor ?? (Get.isDarkMode ? Colors.white : Colors.black),
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.onTextChange?.call(value);
                    });
                  },

                  decoration: InputDecoration(
                    labelText: widget.hasLabel==true?widget.hindtext:"",

                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: widget.updizayn ? 5 : 10),
                    focusColor: widget.borderColor,
                    //add prefix icon

                    suffixIcon: widget.suffixIcon == null
                        ? const SizedBox()
                        : IconButton(
                        onPressed: () {
                          widget.onTopVisible!.call();
                        },
                        icon: Icon(widget.suffixIcon, color: Colors.grey,)),
                    prefixIcon: widget.icon == null
                        ? null : Icon(
                      widget.icon,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:  BorderSide(
                          color: widget.borderColor!, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.white,
                    hintText: widget.isImportant ? widget.hindtext : widget
                        .hindtext,                    //make hint text
                    hintStyle: TextStyle(
                      color: widget.isImportant ? Colors.red : widget.hintTextColor,
                      fontSize: widget.fontsize,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.normal,
                    ),

                    //create lable
                    alignLabelWithHint: false,

                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 10,
                child: CustomText(labeltext: "*",
                  fontsize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,),
              ),
            ],
          ) : Container(
            height: widget.containerHeight,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: TextFormField(
              maxLines: widget.maxLines,
              onFieldSubmitted: (s){
                widget.onSubmit!.call(s);
              },
              readOnly: widget.readOnly,
              textAlignVertical: TextAlignVertical.center,
              textAlign: widget.align,
              obscureText: widget.obscureText,
              validator: (value) =>
              value!.isEmpty
                  ? widget.isvalid!
                  ? widget.valdateText
                  : null
                  : null,
              // onSaved: (value) => _email = value,
              controller: widget.controller,
              keyboardType: widget.inputType,
              style: TextStyle(
                fontSize: widget.fontsize,
                color: widget.textColor,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                setState(() {
                  widget.onTextChange?.call(value);
                });
              },
              decoration:widget.hasBourder!?InputDecoration(
                labelText: widget.hasLabel==true?widget.hindtext:"",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: widget.updizayn ? 5 : 10),
                focusColor: Colors.grey,
                //add prefix icon
                suffixIcon: widget.suffixIcon == null ? SizedBox() : IconButton(
                    onPressed: () {
                      widget.onTopVisible!.call();
                    },
                    icon: Icon(widget.suffixIcon, color: Colors.grey,)),
                prefixIcon: widget.icon == null
                    ? null : Icon(
                  widget.icon,
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white,
                hintText: widget.isImportant ? widget.hindtext + "*" : widget
                    .hindtext,
                //make hint text
                hintStyle: TextStyle(
                  color: widget.isImportant ? Colors.red : widget.hintTextColor,
                  fontSize: widget.fontsize,
                  fontFamily: "verdana_regular",
                  fontWeight: FontWeight.w400,
                ),

                //create lable
                alignLabelWithHint: false,

              ):null,
            ),
          );
        });
  }
}