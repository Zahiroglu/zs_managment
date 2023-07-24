import 'package:dio/dio.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/service/shared_manager.dart';

class DioInspector extends Interceptor{
  String baseEndpoint="https://a2f6-85-132-97-2.ngrok-free.app/api/";


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    print("Dio inspector qosuldu");
    SharedManager sharedManager=SharedManager();
    await sharedManager.init();
    TokenModel tokenModel=await sharedManager.getTokens();
    String accesToken=tokenModel.accessToken??"";
    if(accesToken.isNotEmpty){
      options.headers['Authorization']='Bearer $accesToken';
    }
    options.headers['Content-Type']='application/json';
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async{
    print("onError STATUS CODE  "+err.response.toString());
     if(err.response!.statusCode!=null){
       if (err.response!.statusCode == 401) {
         print("RESPONCE STATUS CODE 401 ");
         await refreshToken();
         return handler.resolve(await _retry(err.requestOptions));
       }else{

       }
      print("Xeta bas verdi");
      return handler.reject(DioError(requestOptions: RequestOptions()));
    }
    // TODO: implement onError
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    Dio dio=Dio();
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshToken() async {
    SharedManager sharedManager=SharedManager();
    await sharedManager.init();
    TokenModel modelToken=await sharedManager.getTokens();
    String refreshToken=modelToken.refreshToken!;
    Dio dio=Dio();
    final response = await dio.post(
      "${baseEndpoint}v1/User/login-with-username",
      data: {'username': 'abas_jafar', 'password': 'abas123'},
      //  data: {'username': ctUsername.text, 'password': ctPassword.text},
      options: Options(
        // receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Lang': 0,
          'Device': 1,
          'abs': '123456'
        },
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
      print("Base responce :"+response.toString());
    if (response.statusCode == 201) {
      // successfully got the new access token
    print("senol nese seflik var");
    } else {
      // refresh token is wrong so log out user.
      print("ahaaa tokeni yeniledim");

    }
  }

}