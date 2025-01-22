import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:workmanager/workmanager.dart';

class GpsController extends GetxController {
  // GPS məlumatları
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isGpsEnabled = false.obs;
  var isInternetConnected = false.obs;
  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();
    checkInitialStatus();
    startBackgroundService();
    listenToConnectivityChanges();
    startLocationUpdates();
  }

  startBackgroundTask(){
    checkInitialStatus();
    startBackgroundService();
    listenToConnectivityChanges();
    startLocationUpdates();
  }

  // İlkin vəziyyəti yoxla
  Future<void> checkInitialStatus() async {
    isGpsEnabled.value = await Geolocator.isLocationServiceEnabled();
    var connectivityResult = await Connectivity().checkConnectivity();
    isInternetConnected.value =
        connectivityResult != ConnectivityResult.none;
  }

  // GPS məlumatlarını hər dəqiqədən bir götür
  void startLocationUpdates() {
    _locationTimer = Timer.periodic(Duration(minutes: 1), (_) async {
      if (await Geolocator.isLocationServiceEnabled()) {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          latitude.value = position.latitude;
          longitude.value = position.longitude;
          print("Mövqe: ${latitude.value}, ${longitude.value}");
        } catch (e) {
          print("GPS məlumatı alınmadı: $e");
        }
      } else {
        isGpsEnabled.value = false;
      }
    });
  }

  // İnternet və GPS dəyişikliklərini dinlə
  void listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isInternetConnected.value = result != ConnectivityResult.none;
      if (!isInternetConnected.value) {
        print("İnternet bağlantısı yoxdur!");
      }
    });
    Geolocator.getServiceStatusStream().listen((status) {
      isGpsEnabled.value = status == ServiceStatus.enabled;
      if (!isGpsEnabled.value) {
        print("GPS söndürüldü!");
      }
    });
  }

  // Background Service başlat
  void startBackgroundService() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerPeriodicTask(
      "1",
      "fetchLocation",
      frequency: Duration(minutes: 15),
    );
  }

  // Controller məhv olunduqda timer-i dayandır
  @override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }
}

// Background callback üçün dispatcher
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task işləyir...");
    // GPS məlumatını burada əldə edə bilərsiniz.
    return Future.value(true);
  });
}
