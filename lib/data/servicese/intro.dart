
import 'package:engez/data/models/intro.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';



class ApiSplash {
  ApiSplash._();

  static final ApiSplash instance = ApiSplash._();
  static IntroModel ? splash;


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

  Future<IntroModel?> getSlider() async {
    // Json Data
    var _response = await dio.get(ServerConstants.Splash,
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

      splash = IntroModel.fromJson(_response.data);
      return splash;
      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....not***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      //throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }



}

