import 'package:flutter/material.dart';
import 'package:zs_managment/companents/backgroud_task/backgroud_errors/model_user_current_location_reqeust.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../backgroud_task/backgroud_errors/local_backgroud_events.dart';

class ScreenUnsendedErrors extends StatefulWidget {
  const ScreenUnsendedErrors({super.key});

  @override
  State<ScreenUnsendedErrors> createState() => _ScreenUnsendedErrorsState();
}

class _ScreenUnsendedErrorsState extends State<ScreenUnsendedErrors> {
  LocalBackgroundEvents backgroundEvents=LocalBackgroundEvents();
  List<ModelUsercCurrentLocationReqeust> listlocations=[];
  bool dataLoading=true;


 @override
  void initState() {
    // TODO: implement initState
   fillAllLocations();
    super.initState();
  }

  fillAllLocations() async {
    await backgroundEvents.init();
    listlocations= backgroundEvents.getAllUnSendedLocations();
    dataLoading=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: dataLoading?Center(child: CircularProgressIndicator(color: Colors.red,),): listlocations.isNotEmpty?ListView.builder(
            itemCount: listlocations.length,
            itemBuilder: (c,index){
              return customVidgetError(listlocations.elementAt(index));
            }):Center(child: CustomText(labeltext: "Hecne yoxdu",),),
      ),
    );
  }

  customVidgetError(ModelUsercCurrentLocationReqeust element) {
   return Column(
     children: [
       CustomText(labeltext: element.locationDate!,fontWeight: FontWeight.bold,),
       Row(children: [
         CustomText(labeltext: "element.pastInputCustomerCode :",fontWeight: FontWeight.normal,),
         CustomText(labeltext: element.pastInputCustomerCode! ,fontWeight: FontWeight.normal,),

       ],),
       Row(children: [
         CustomText(labeltext: "element.userCode :",fontWeight: FontWeight.normal,),
         CustomText(labeltext: element.userCode! ,fontWeight: FontWeight.normal,),

       ],)

     ],
   );
  }
}
