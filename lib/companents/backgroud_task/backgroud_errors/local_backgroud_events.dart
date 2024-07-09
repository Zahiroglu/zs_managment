
import 'package:hive/hive.dart';

import 'model_back_error.dart';
import 'model_user_current_location_reqeust.dart';

class LocalBackgroundEvents {
  late Box backErrors = Hive.box<ModelBackErrors>("backErrors");
  late Box backLocations = Hive.box<ModelUsercCurrentLocationReqeust>("backLocations");

  Future<void> init() async {
    backErrors = await Hive.openBox<ModelBackErrors>("backErrors");
    backLocations = await Hive.openBox<ModelUsercCurrentLocationReqeust>("backLocations");
  }

  Future<void> addBackErrorToBase(ModelBackErrors model) async {
    await backErrors.put("${model.errDate!}|${model.userCode!}", model);
  }

  Future<void> updateSelectedValuea(ModelBackErrors model) async {
    await deleteItem(model);
    await backErrors.put("${model.errDate!}|${model.userCode.toString()}", model);
  }


 List<ModelBackErrors> getAllUnSendedBckError() {
   List<ModelBackErrors> listErrors=[];
   backErrors.toMap().forEach((key, value) {
     if (value.sendingStatus=="0") {
       int count =backErrors.toMap().entries.where((element) => element.value.errDate==value.errDate).toList().length;
      // value.enterCount==count;
       listErrors.add(value);
     }});
   listErrors.forEach((element) {
     print("Back error :"+element.toString());
   });
   print("Back error lenth:"+listErrors.length.toString());

   listErrors.sort((a, b) => a.errDate!.compareTo(b.errDate!));
   return listErrors;
  }


  bool convertDayByLastday(ModelBackErrors element) {
    print("Error zaman :"+element.errDate.toString());
    DateTime? lastDay = DateTime.tryParse(element.errDate.toString());
    return lastDay.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
  }

  Future<void> deleteItem(ModelBackErrors model) async {
    final box = Hive.box<ModelBackErrors>("backErrors");
    final Map<dynamic, ModelBackErrors> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.errDate == model.errDate.toString()) {
        desiredKey = key;
        box.delete(desiredKey);
      }
    });
  }

  Future<void> clearAllGiris() async {
    await backErrors.clear();
  }
  ////Locations field
  Future<void> addBackLocationToBase(ModelUsercCurrentLocationReqeust model) async {
    print("Location date :"+model.locationDate!);
    await backLocations.put(model.locationDate!, model);
  }

  Future<void> updateSelectedLocationValue(ModelUsercCurrentLocationReqeust model) async {
    await deleteItemLocation(model);
  }

  Future<void> deleteItemLocation(ModelUsercCurrentLocationReqeust model) async {
    final box = Hive.box<ModelUsercCurrentLocationReqeust>("backLocations");
    final Map<dynamic, ModelUsercCurrentLocationReqeust> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.locationDate == model.locationDate) {
        desiredKey = key;
        box.delete(desiredKey);
      }
    });
  }

  List<ModelUsercCurrentLocationReqeust> getAllUnSendedLocations() {
    List<ModelUsercCurrentLocationReqeust> listLocations=[];
    backLocations.toMap().forEach((key, value) {
      if (value.sendingStatus=="0") {
        int count =backLocations.toMap().entries.where((element) => element.value.locationDate==value.locationDate).toList().length;
        //value.enterCount==count;
        listLocations.add(value);
      }});
    listLocations.forEach((element) {
      print("Back track :"+element.toString());
    });
    print("Back track leng :"+listLocations.length.toString());

    listLocations.sort((a, b) => a.locationDate!.compareTo(b.locationDate!));
    return listLocations;
  }

}
