
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exeptions.dart';

class ProductsService {


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

  Future getProducts(String filter,int subCategory,String company,int page, {String? token}) async {
    print(filter+"gggggggggggg");
    var response = await dio.get(ServerConstants.Products+'?company=$company&sub_department=$subCategory&limit=6&page=$page&title=$filter',
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }

  Future addProducts(Map data,String token) async {
    var response = await dio.post(ServerConstants.AddProduct,
        data: data,
        options: Options(
          headers:{...apiHeaders,
               'Authorization': token,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }

  Future getCart(String token) async {
    var response = await dio.get(ServerConstants.getCart,
        options: Options(
          headers:{...apiHeaders,
               'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }

  Future updateCart(Map data,String token) async {
    var response = await dio.post(ServerConstants.updateCart,
        data: data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': token,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }
  Future useBalance(Map data,String token) async {
    var response = await dio.post(ServerConstants.useBalance,
        data: data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': token,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }
  Future confirmOrder(int id,String token) async {
    var response = await dio.post(ServerConstants.confirmOrder,
        data: {
      'cart_id':id
        },
        options: Options(
          headers:{...apiHeaders,
            'Authorization': token,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }

  Future<void> addToFav(int? id,String token) async {
    // Json Data
    var _data = {
      "item_id": "$id",

    };
    // Http Request
    var _response = await dio.post(ServerConstants.addProductToFav,
        data: _data,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': token,
            },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      // OK
      // if (!ServerConstants.isValidResponse(
      //     int.parse(_response.data[0]))) {
      //   throw ApiException.fromApi(_response.statusCode!, _response.data);
      // }
      //  print(user!.accessToken);
      //   user!.saveToken(user!.accessToken);
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      //    prefs?.setBool("isLoggedIn", true);

      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....login***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

  Future<void> removeFromFav(int? id,String token) async {
    // Json Data
    var _data = {
      "item_id": "$id",

    };
    // Http Request

    var _response = await dio.post(ServerConstants.deleteProductFromFav,
        data: _data,
        options: Options(
          headers: {...apiHeaders,
            'Authorization':  '$token',},
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      // OK
      // if (!ServerConstants.isValidResponse(
      //     int.parse(_response.data[0]))) {
      //   throw ApiException.fromApi(_response.statusCode!, _response.data);
      // }
      //  print(user!.accessToken);
      //   user!.saveToken(user!.accessToken);
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      //    prefs?.setBool("isLoggedIn", true);

      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....login***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


  Future getFav(String token,int page) async {
    var response = await dio.get(ServerConstants.viewProductFav+'?page=$page',
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data;
    } else {
      throw ApiException.fromApi(response.statusCode!, response.data);
    }
  }
}

