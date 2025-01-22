
import 'package:hive/hive.dart';

import 'model_back_error.dart';
import 'model_user_current_location_reqeust.dart';


class LocalBackgroundEvents {
  late Box<ModelBackErrors> backErrors;
  late Box<ModelUsercCurrentLocationReqeust> backLocations;

  // Hive verilənlər bazalarını başlatmaq
  Future<void> init() async {
    backErrors = await Hive.openBox<ModelBackErrors>("backErrors");
    backLocations = await Hive.openBox<ModelUsercCurrentLocationReqeust>("backLocations");
  }

  // Yeni səhv məlumatını baza əlavə etmək
  Future<void> addBackErrorToBase(ModelBackErrors model) async {
    final existingModel = backErrors.get(model.errDate!);
    if (existingModel == null) {
      await backErrors.put("${model.errDate!}", model);
      print("Yeni səhv əlavə edildi: ${model.errDate}");
    } else {
      print("Bu səhv artıq mövcuddur: ${model.errDate}");
    }
  }

  // Silinmiş səhv məlumatını bazadan silmək
  Future<void> deleteItemErrors(ModelBackErrors model) async {
    final box = Hive.box<ModelBackErrors>("backErrors");
    final Map<dynamic, ModelBackErrors> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) async {
      if (key.toString() == model.errDate.toString()) {
        desiredKey = key;
        await box.delete(desiredKey); // Silinmiş məlumatı düzgün silir
        print("Silindi: ${model.errDate}");
      }
    });
  }

  // Göndərilmə statusu "0" olan bütün səhvləri əldə etmək
  List<ModelBackErrors> getAllUnSendedBckError() {
    List<ModelBackErrors> listErrors = [];
    backErrors.toMap().forEach((key, value) {
      if (value.sendingStatus == "0") {
        listErrors.add(value);
      }
    });
    listErrors.sort((a, b) => a.errDate!.compareTo(b.errDate!));
    return listErrors;
  }

  // Bir səhvin tarixini bugünkü günlə müqayisə etmək
  bool convertDayByLastday(ModelBackErrors element) {
    print("Error zaman: " + element.errDate.toString());
    DateTime? lastDay = DateTime.tryParse(element.errDate.toString());
    return lastDay.toString().substring(0, 11) == DateTime.now().toString().substring(0, 11);
  }

  // Bütün səhv məlumatlarını təmizləmək
  Future<void> clearAllGiris() async {
    await backErrors.clear();
    print("Bütün səhv məlumatları təmizlənib.");
  }

  //// Locations - konumla bağlı metodlar

  // Yeni konum məlumatını baza əlavə etmək
  Future<void> addBackLocationToBase(ModelUsercCurrentLocationReqeust model) async {
    final existingLocation = backLocations.get(model.locationDate!);
    if (existingLocation == null) {
      await backLocations.put(model.locationDate!, model);
      print("Yeni konum əlavə edildi: ${model.locationDate}");
    } else {
      print("Bu konum artıq mövcuddur: ${model.locationDate}");
    }
  }

  // Silinmiş konum məlumatını bazadan silmək
  Future<void> deleteItemLocation(ModelUsercCurrentLocationReqeust model) async {
    final box = Hive.box<ModelUsercCurrentLocationReqeust>("backLocations");
    final Map<dynamic, ModelUsercCurrentLocationReqeust> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) async {
      if (key.toString() == model.locationDate.toString()) {
        desiredKey = key;
        await box.delete(desiredKey); // Silinmiş məlumatı düzgün silir
        print("Silindi: ${model.locationDate}");
      }
    });
  }

  // Göndərilmə statusu "0" olan bütün konumları əldə etmək
  List<ModelUsercCurrentLocationReqeust> getAllUnSendedLocations() {
    List<ModelUsercCurrentLocationReqeust> listLocations = [];
    backLocations.toMap().forEach((key, value) {
      if (value.sendingStatus == "0") {
        listLocations.add(value);
      }
    });
    listLocations.sort((a, b) => a.locationDate!.compareTo(b.locationDate!));
    return listLocations;
  }

  // Bütün konum məlumatlarını təmizləmək
  Future<void> clearAllLocations() async {
    await backLocations.clear();
    print("Bütün konum məlumatları təmizlənib.");
  }
}

// class LocalBackgroundEvents {
//   late Box backErrors;
//   late Box backLocations;
//
//   Future<void> init() async {
//     backErrors = await Hive.openBox<ModelBackErrors>("backErrors");
//     backLocations = await Hive.openBox<ModelUsercCurrentLocationReqeust>("backLocations");
//   }
//
//   Future<void> addBackErrorToBase(ModelBackErrors model) async {
//     await backErrors.put("${model.errDate!}", model);
//   }
//
//   Future<void> deleteItemErrors(ModelBackErrors model) async {
//     final box = Hive.box<ModelBackErrors>("backErrors");
//     final Map<dynamic, ModelBackErrors> deliveriesMap = box.toMap();
//     dynamic desiredKey;
//     deliveriesMap.forEach((key, value) {
//       if (key.toString() == model.errDate.toString()) {
//         desiredKey = key;
//         box.delete(desiredKey);
//
//       }
//     });
//   }
//
//  List<ModelBackErrors> getAllUnSendedBckError() {
//    List<ModelBackErrors> listErrors=[];
//    backErrors.toMap().forEach((key, value) {
//      if (value.sendingStatus=="0") {
//        listErrors.add(value);
//      }});
//    listErrors.sort((a, b) => a.errDate!.compareTo(b.errDate!));
//    return listErrors;
//   }
//
//   bool convertDayByLastday(ModelBackErrors element) {
//     print("Error zaman :"+element.errDate.toString());
//     DateTime? lastDay = DateTime.tryParse(element.errDate.toString());
//     return lastDay.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
//   }
//
//   Future<void> clearAllGiris() async {
//     await backErrors.clear();
//   }
//   ////Locations field
//   Future<void> addBackLocationToBase(ModelUsercCurrentLocationReqeust model) async {
//     print("print : gonderilmeyen konum elave edildi : "+model.toString());
//     await backLocations.put(model.locationDate!, model);
//   }
//
//   Future<void> deleteItemLocation(ModelUsercCurrentLocationReqeust model) async {
//     final box = Hive.box<ModelUsercCurrentLocationReqeust>("backLocations");
//     final Map<dynamic, ModelUsercCurrentLocationReqeust> deliveriesMap = box.toMap();
//     dynamic desiredKey;
//     deliveriesMap.forEach((key, value) {
//       if (key.toString() == model.locationDate.toString()) {
//         desiredKey = key;
//         box.delete(desiredKey);
//         print("print :  gonderilmeyen konum silindi: "+model.toString());
//
//       }
//     });
//   }
//
//   List<ModelUsercCurrentLocationReqeust> getAllUnSendedLocations() {
//     List<ModelUsercCurrentLocationReqeust> listLocations=[];
//     backLocations.toMap().forEach((key, value) {
//       if (value.sendingStatus=="0") {
//         listLocations.add(value);
//       }});
//     listLocations.sort((a, b) => a.locationDate!.compareTo(b.locationDate!));
//     return listLocations;
//   }
//
// }
