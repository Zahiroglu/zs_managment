
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';

class LoagindAnimation extends StatelessWidget {
  bool isDark;
  LoagindAnimation({required this.isDark,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
              color: isDark?Colors.white:Colors.black,
              size: 150,
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(labeltext: 'yoxlanir',fontsize: 24,maxline: 2,),
                SizedBox(width: 2,),
                LoadingAnimationWidget.prograssiveDots(
                  color: isDark?Colors.white:Colors.black,
                  size: 15,
                )
              ],
            )
          ],
        ));
  }
}
