

import 'package:engez/data/models/offer.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../local_storage.dart';
import 'api_exeptions.dart';

class OfferService {
  OfferService._();

  static final OfferService instance = OfferService._();
  static OfferModel? offer;


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

  Future<OfferModel?> getOffers() async {

    var _response = await dio.get('${ServerConstants.Offer}',
        options: Options(
          headers:{...apiHeaders,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {

      offer = OfferModel.fromJson(_response.data);
      return offer;
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


}

