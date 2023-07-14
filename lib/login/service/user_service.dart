import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/login_desktopmodel.dart';
import 'package:zs_managment/login/models/model_company.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/login/service/i_userservic.dart';
import 'package:dio/dio.dart';
import 'package:zs_managment/secure_data/secure_usermain_data.dart';

class UserServis extends IuserServive {
  UserServis(super.dio);

  final SecureUserMainData _secureStorig = SecureUserMainData();
  SharedManager sharedManager = SharedManager();

  @override
  Future<BaseResponce> loginWithUsername(int dviceTipe, int languageIndex, String username, String pasword) async {
    await sharedManager.init();
    final response = await dio.post('https://db5e-62-212-234-9.ngrok-free.app/api/v1/User/login-with-username/',
        //data: {'username': 'abas_jafar', 'password': 'abas123'},
        data: {'username': username, 'password': pasword},
        options: Options(
         // receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceTipe,
            'abs': '123456'
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),);
    BaseResponce baseResponce = BaseResponce.fromJson(response.data);
    if (baseResponce.code == 200) {
      TokenModel modelToken = TokenModel.fromJson(baseResponce.result['token']);
      UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
      CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['user']);
      print("BaseResponce :" + baseResponce.result.toString());
      print("modelToken :" + modelToken.toString());
      print("modelUser :" + modelUser.toString());
      print("modelCompany :" + modelCompany.toString());
      LoggedUserModel modelLogged = LoggedUserModel(isLogged: true, companyModel: modelCompany,
          tokenModel: modelToken,
          userModel: modelUser);
      sharedManager.saveUser("keyUser", modelLogged);
      getAllUsers(languageIndex, dviceTipe);
    }
    return baseResponce;
  }

  Future callStorige() async {
    String token = await _secureStorig.getToken();
    print("--Token :" + token);
  }

  Future<BaseResponce> getAllUsers(int langIndex, int dviceType) async {
    TokenModel tokenModel = await sharedManager.getTokens();
    String accesToken = tokenModel.accessToken.toString();
    final response =
        await dio.get('https://db5e-62-212-234-9.ngrok-free.app/api/v1/User',
            data: {'username': 'abas_jafar', 'password': 'abas123'},
            options: Options(
              headers: {
                'Lang': langIndex,
                'Device': dviceType,
                'abs': '123456',
                'Authorization': 'Bearer $accesToken',
              },
              validateStatus: (_) => true,
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
            ));
    BaseResponce baseResponce = BaseResponce.fromJson(response.data);
    if(response.statusCode==401){
      getRefreshToken(tokenModel.refreshToken.toString())
          .then((value) => {getAllUsers(langIndex, dviceType)});
    }else{
      print("Data :"+baseResponce.result.toString());
      return BaseResponce();
    }
  return BaseResponce();
  }

  Future<BaseResponce> getRefreshToken(String refreshToken) async {
    BaseResponce baseResponce;
    final response =
        await dio.get('https://db5e-62-212-234-9.ngrok-free.app/api/v1/User',
            data: {'username': 'abas_jafar', 'password': 'abas123'},
            options: Options(
              headers: {
                //'Lang': langIndex,
                //'Device': dviceType,
                'abs': '123456',
                //'Authorization': 'Bearer $accesToken',
              },
              validateStatus: (_) => true,
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
            ));
    baseResponce = response.data;

    return baseResponce;
  }
}
