import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/language/lang_constants.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/model_language.dart';

class WidgetDilSecimi extends StatelessWidget {
  WidgetDilSecimi({
    Key? key,required this.localizationController
  }) : super(key: key);
  LocalizationController localizationController;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color:localizationController.isDark?Colors.white:Colors.black)
      ),
      child: DropdownButton(
          alignment: Alignment.center,
          hint:Row(
            children: [
              Image.asset(localizationController.getlastLanguage().imageUrl,width: 15,height: 15),
              const SizedBox(width: 5,),
              CustomText(
                  color:localizationController.isDark?Colors.white:Colors.black,
                  labeltext: localizationController.getlastLanguage().countryCode)

            ],
          ),
          underline: SizedBox(),
          elevation: 10,
          icon: Icon(Icons.expand_more_outlined),
          items: LangConstants.languages
              .map<DropdownMenuItem<LanguageModel>>(
                (lang) => DropdownMenuItem(
                    value: lang,
                    child: Row(
                      children: [
                        Image.asset(lang.imageUrl, width: 20, height: 20),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(labeltext: lang.countryCode)
                      ],
                    )),
              )
              .toList(),
          onChanged: (lang){
        int index=LangConstants.languages.indexOf(lang!);
        localizationController.setLanguage(Locale(
          LangConstants.languages[index].languageCode,
          LangConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      }),
    );
  }
}
