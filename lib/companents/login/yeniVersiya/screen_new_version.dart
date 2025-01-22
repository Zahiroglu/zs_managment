import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenNewVersion extends StatefulWidget {
  final String bildiris;
 const ScreenNewVersion({required this.bildiris,super.key});

  @override
  State<ScreenNewVersion> createState() => _ScreenNewVersionState();
}

class _ScreenNewVersionState extends State<ScreenNewVersion> {
  final Uri playStoreUrl =
  Uri.parse('https://play.google.com/store/apps/details?id=com.example.zs_managment');

  // Apple App Store linki
  final Uri appStoreUrl =
  Uri.parse('https://apps.apple.com/app/id123456789');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Expanded(child: Lottie.asset("lottie/yeniVersion.json")),
          Expanded(child: Column(children: [
            CustomText(labeltext: "newVersion".tr,fontWeight: FontWeight.bold,fontsize: 24,),
            const SizedBox(height: 10,),
            CustomText(labeltext: widget.bildiris,fontsize: 18,textAlign: TextAlign.center,maxline: 2,),
            const SizedBox(height: 20,),
            CustomElevetedButton(
              elevation: 10,
              height: 45,
              textColor: Colors.white,
              textsize: 24,
              icon: Icons.refresh,
                width: MediaQuery.of(context).size.width/2,
                surfaceColor: Colors.blue.withOpacity(0.7),
                cllback: (){
                  _openStore(playStoreUrl);
                }, label: "refresh".tr)
          ],))
        ],),
      ),
    );
  }

  // Linki açan metod
  Future<void> _openStore(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Link açıla bilmir: $url';
    }
  }}
