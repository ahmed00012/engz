




import 'dart:developer';

import 'package:engez/data/models/home.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../local_storage.dart';
import 'api_exeptions.dart';

class HomeService {
  HomeService._();

  static final HomeService instance = HomeService._();
  static HomeModel? home;


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

  Future<HomeModel?> getHome(String token) async {
    var _response = await dio.get(ServerConstants.Home,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(_response.statusCode!)) {
  //    LocalStorage.saveData(key: 'city_minDelivery',value: int.parse(_response.data['min_order']));
      home = HomeModel.fromJson(_response.data);
      return home;
    } else {
      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


  Future getPopup() async {
    var _response = await dio.get(ServerConstants.popup,);

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return  Popup.fromJson(_response.data['popup']);
    } else {
      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


}

