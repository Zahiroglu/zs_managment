import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/custim_interceptor_hidden.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

import '../companents/login/models/model_token.dart';
import 'custim_interceptor.dart';

class ApiClientLive {
  static final ApiClientLive _converter = ApiClientLive._internal();
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  static const String kRequiredHeader = 'Header';
  static const String kAuthorization = 'Authorization';

  factory ApiClientLive() {
    return _converter;
  }

  ApiClientLive._internal();

  Dio dio() {
    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        baseUrl: AppConstands.baseUrlsMain,
        persistentConnection:false,
      ),
    );
    dio.interceptors.clear();
    dio.interceptors.add(CustomInterceptorHidden(dio,true));
    return dio;
  }

}