import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:zs_managment/login/service/dio_inspector.dart';
import 'package:zs_managment/login/service/users_apicontroller.dart';



class UserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersApiController>(() => UsersApiController());
  }
}