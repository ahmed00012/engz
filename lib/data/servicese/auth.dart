

import 'package:engez/data/models/forget_pass.dart';
import 'package:engez/data/models/terms.dart';
import 'package:engez/data/models/user.dart';
import 'package:engez/data/servicese/server_constants.dart';

import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../local_storage.dart';
import 'api_exeptions.dart';



class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  static UserModel? user;
  static TermsModel ? termsModel;
  static PassCodeModel ? pass;


  var dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  //
  static Map<String, String> apiHeaders = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Content-Language": "ar",
  };

  Future<UserModel?> signUp(String name,
      String phone,
      String password,
      String storeName,
      String storeAddress,
      String deviceId,
      int id,
      double lat,
      double lng) async {
    // Json Data
    var _data = {
      "mobile": "$phone",
      "password": "$password",
      "name": "$name",
      "terms": "1",
      "firebaseToken": "$deviceId",
      "shop_name": '$storeName',
      "shop_address": '$storeAddress',
      "city_id": '$id',
      "lat":"$lat",
      "long":"$lng"
    };
    print('sign up start');
    // Http Request

    var _response = await dio.post(ServerConstants.SIGNUP,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      //  return UserModel.fromJson(_response.body)
      user = UserModel.fromJson(_response.data);
      return user;
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....Signup***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


Future<UserModel?> login(
    String phone, String password, String deviceId) async {
  var _data = {
    "mobile": "$phone",
    "password": "$password",
    "firebaseToken": "$deviceId",
  };
  print('login start');
  // Http Request
  var _response = await dio.post(ServerConstants.LOGIN,
      data: _data,
      options: Options(
        headers: {...apiHeaders
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ));


  print("${_response.data}");

  if (ServerConstants.isValidResponse(_response.statusCode!)) {
    user = UserModel.fromJson(_response.data);
    return user;
  } else {
    throw ApiException.fromApi(_response.statusCode!, _response.data);
  }
}

  Future<void> logOut() async {
    // Json Data
    String token = LocalStorage.getData(key: 'token');
    var _response = await dio.post(ServerConstants.LOGOUT,
        options: Options(
          headers: {
            ...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
LocalStorage.saveData(key: 'name', value: '');
LocalStorage.saveData(key: 'mobile', value: '');
LocalStorage.saveData(key: 'city_minDelivery', value: 0);

    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....logout***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }
  Future<TermsModel?> terms() async {
    // Json Data
    var _response = await dio.get(ServerConstants.TERMS,
        options: Options(
          headers: {
            ...apiHeaders,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      termsModel = TermsModel.fromJson(_response.data);
      return termsModel;
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....terms***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

// Future<UserModel?> getProfile() async {
//
//   String token = await ServerConstants.getUserToken();
//   var _response = await dio.get(ServerConstants.GetProfile,
//       options: Options(
//         headers: {...apiHeaders,
//           'Authorization': '$token',
//         },
//         validateStatus: (status) {
//           return status! < 500;
//         },
//       ));
//
//   print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
//   print("${_response.data}");
//
//   if (ServerConstants.isValidResponse(_response.statusCode!)) {
//
//     user = UserModel.fromJson(_response.data);
//     return user;
//
//     //  return UserModel.fromJson(_response.body);
//   } else {
//     // DioErrorType type;
//     // No Success
//     print(
//         'ApiException....getProfile***********************************************************');
//
//     // print(_response.request.uri.data);
//     print('...................................................');
//
//     throw ApiException.fromApi(_response.statusCode!, _response.data);
//   }
// }




Future<UserModel?> updateProfile(
    String phone,
    String name,
    String storeName,
    String storeAddress,
    int id

    ) async {
  // Json Data
  var _data = {
    "mobile": "$phone",
    "name": "$name",
    "shop_name": '$storeName',
    "shop_address": '$storeAddress',
    "city_id": '$id',
  };
  print('sign up start');
  // Http Request
  String token = LocalStorage.getData(key: 'token');
  var _response = await dio.post(ServerConstants.UPDATEPROFILE,
      data: _data,
      options: Options(
        headers: {
          ...apiHeaders,
          'Authorization': '$token',
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ));

  print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
  print("${_response.data}");

  if (ServerConstants.isValidResponse(_response.statusCode!)) {
    //  return UserModel.fromJson(_response.body);
    user = UserModel.fromJson(_response.data);
    return user;
  } else {
    // DioErrorType type;
    // No Success
    print(
        'ApiException....update profile***********************************************************');

    // print(_response.request.uri.data);
    print('...................................................');

    throw ApiException.fromApi(_response.statusCode!, _response.data);
  }
}

  Future<PassCodeModel?> sendPhone(
      String phone) async {
    // Json Data
    var _data = {
      "mobile": "$phone",
    };

    // Http Request
    var _response = await dio.post(ServerConstants.sendPhone,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      //  return UserModel.fromJson(_response.body);
      pass = PassCodeModel.fromJson(_response.data);
      LocalStorage.saveData(key: 'code', value: _response.data['data']);
      return pass;
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....sendPhone***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

  Future<void> forgotPass(
      String password, String conPassword, String token) async {
    // Json Data
    var _data = {
      "password_confirmation": "$conPassword",
      "password": "$password",
      "token": "$token",

    };
    print('login start');
    // Http Request
    var _response = await dio.post(ServerConstants.forgot,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....sendPhone***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


}
