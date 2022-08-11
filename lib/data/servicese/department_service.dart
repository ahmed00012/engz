
import 'package:engez/data/models/home.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exeptions.dart';

class DepartmentService {

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

  Future getSubCategory( int page) async {
    var response = await dio.get(ServerConstants.SubDepartment+'?page=$page&limit=6',
        options: Options(
          headers:{...apiHeaders,
            //   'Authorization': '$token',
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

