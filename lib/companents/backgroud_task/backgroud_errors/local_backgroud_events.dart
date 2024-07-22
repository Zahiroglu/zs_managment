
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
    print("print : gonderilmeyen Xeta elave edildi : "+model.toString());
    await backErrors.put("${model.errDate!}", model);
  }

  Future<void> deleteItemErrors(ModelBackErrors model) async {
    final box = Hive.box<ModelBackErrors>("backErrors");
    final Map<dynamic, ModelBackErrors> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (key.toString() == model.errDate.toString()) {
        desiredKey = key;
        box.delete(desiredKey);
        print("print : gonderilmeyen Xeta silindi : "+model.toString());

      }
    });
  }

 List<ModelBackErrors> getAllUnSendedBckError() {
   List<ModelBackErrors> listErrors=[];
   backErrors.toMap().forEach((key, value) {
     if (value.sendingStatus=="0") {
       listErrors.add(value);
     }});
   listErrors.sort((a, b) => a.errDate!.compareTo(b.errDate!));
   return listErrors;
  }


  bool convertDayByLastday(ModelBackErrors element) {
    print("Error zaman :"+element.errDate.toString());
    DateTime? lastDay = DateTime.tryParse(element.errDate.toString());
    return lastDay.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
  }

  Future<void> clearAllGiris() async {
    await backErrors.clear();
  }
  ////Locations field
  Future<void> addBackLocationToBase(ModelUsercCurrentLocationReqeust model) async {
    print("print : gonderilmeyen konum elave edildi : "+model.toString());
    await backLocations.put(model.locationDate!, model);
  }

  Future<void> deleteItemLocation(ModelUsercCurrentLocationReqeust model) async {
    final box = Hive.box<ModelUsercCurrentLocationReqeust>("backLocations");
    final Map<dynamic, ModelUsercCurrentLocationReqeust> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (key.toString() == model.locationDate.toString()) {
        desiredKey = key;
        box.delete(desiredKey);
        print("print :  gonderilmeyen konum silindi: "+model.toString());

      }
    });
  }

  List<ModelUsercCurrentLocationReqeust> getAllUnSendedLocations() {
    List<ModelUsercCurrentLocationReqeust> listLocations=[];
    backLocations.toMap().forEach((key, value) {
      if (value.sendingStatus=="0") {
        listLocations.add(value);
      }});
    listLocations.sort((a, b) => a.locationDate!.compareTo(b.locationDate!));
    return listLocations;
  }

}
