import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/custim_interceptor_back.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

import '../companents/login/models/model_token.dart';
import 'custim_interceptor.dart';

class ApiClientBack {
  static final ApiClientBack _converter = ApiClientBack._internal();
  static const String kRequiredHeader = 'Header';
  static const String kAuthorization = 'Authorization';

  factory ApiClientBack() {
    return _converter;
  }

  ApiClientBack._internal();

  Dio dio(bool musteShowResult) {
    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),     // Sorğunu göndərmə müddətini 30 saniyə et
        followRedirects: true,       // 3xx yönləndirmələrə icazə ver
        baseUrl: AppConstands.baseUrlsMain,
        persistentConnection:false,
          headers: {
            "Connection": "keep-alive",  // Bağlantını saxla
            "Accept": "application/json",
            "User-Agent": "ZS-CONTROLL",
          }
      ),
    );
    dio.interceptors.clear();
    dio.interceptors.add(CustomInterceptorBack(dio: dio,mustShowResult: musteShowResult));
    return dio;
  }

}