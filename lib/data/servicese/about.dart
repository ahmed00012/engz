
import 'package:dio/dio.dart';
import 'package:engez/data/models/about.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exeptions.dart';

class AboutService {
  AboutService._();

  static final AboutService instance = AboutService._();
  static AboutModel? about;


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

  Future<AboutModel?> getAbout() async {
    // Json Data
    // String token = await ServerConstants.getUserToken();
    // if(token == null)
    //   token= '';
    var _response = await dio.get(ServerConstants.about,
        options: Options(
          headers:{...apiHeaders,
            //   'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    //  print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      // OK
      // if (!ServerConstants.isValidResponse(
      //     int.parse(_response.data[0]))) {
      //   throw ApiException.fromApi(_response.statusCode!, _response.data);
      // }

      about = AboutModel.fromJson(_response.data);
      return about;
      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....home***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }


}

