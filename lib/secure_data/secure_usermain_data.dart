import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureUserMainData{
  final _storage = const FlutterSecureStorage();

  void SaveMainDataToSecure(token,refreshToken){
    _storage.write(key: "token", value: token,
      aOptions: _getAndroidOptions(),);
    _storage.write(key: "refreshToken", value: refreshToken,
      aOptions: _getAndroidOptions(),);
  }

  Future<String> getToken()async{
    String? token="";
    token=await _storage.read(key: "token");

    return token!;
  }
  Future<String> getRefreshToken()async{
    String? refresh="";
    refresh=await _storage.read(key: "refreshToken");
    return refresh!;
  }



  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );



}