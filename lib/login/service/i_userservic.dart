import 'package:dio/dio.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';

abstract class IuserServive{
  IuserServive(this.dio);
  final Dio dio;

   Future<BaseResponce> loginWithUsername(int dviceTipe, int selectedIndex,String username,String password);


}