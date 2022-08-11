

import 'package:dio/dio.dart';
import 'package:engez/data/servicese/server_constants.dart';

import 'package:engez/data/models/region.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exeptions.dart';



class RegionService {
  RegionService._();

  static final RegionService instance = RegionService._();
  static RegionModel? region;

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



  Future<RegionModel?> getRegion( ) async {
    var _response = await dio.get(ServerConstants.REGION,
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
      region = RegionModel.fromJson(_response.data);
      return region;

      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....City***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }






}

