





import 'package:engez/data/models/order.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../local_storage.dart';
import 'api_exeptions.dart';

class OrdersService {
  OrdersService._();

  static final OrdersService instance = OrdersService._();
  static OrderModel? order;


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

  Future<OrderModel?> getorders(int page,int status) async {
    // Json Data
    // String token = await ServerConstants.getUserToken();
    // if(token == null)
    //   token= '';
    String token = LocalStorage.getData(key: 'token');
    var _response = await dio.get('${ServerConstants.GETORDERS}?page=$page&status_id=$status',
        options: Options(
          headers:{...apiHeaders,
               'Authorization': '$token',
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

      order = OrderModel.fromJson(_response.data);
      return order;
      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....orders***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }
  Future delete(Map data,String token) async {
    var response = await dio.post(ServerConstants.deleteOrder,
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
  Future editOrder(Map data,String token) async {
    var response = await dio.post(ServerConstants.orderEdit,
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


}

