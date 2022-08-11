
import 'package:flutter/material.dart';
import 'package:engez/peresentation/widgets/error_pop.dart';


class ServerConstants {
  static bool isValidResponse(int statusCode) {
    return statusCode >= 200 && statusCode <= 302;
  }

  static void showDialog1(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (context) => ErrorPopUp(message: '$s'),
    );
  }



  // static Future<String> getUserToken() async {
  //   print('_getUserToken()');
  //   Data user = Data();
  //   print('UserModel');
  //   String? userToken = await user.getToken;
  //   print(userToken);
  //   // if (userToken == null) throw "User Not Logged In";
  //   return userToken??'';
  // }

  static const bool IS_DEBUG = true; // TODO: Close Debugging in Release.
  static const String API = "https://anjez.today/admin/api";
  static const String Home ='${API}/home';
  static const String REGION ='${API}/cities';
  static const String SIGNUP ='${API}/register';
  static const String LOGIN ='${API}/login';
  static const String LOGOUT ='${API}/logout';
  static const String TERMS ='${API}/terms';
  static const String UPDATEPROFILE ='${API}/updateProfile';
  static const String GETORDERS ='${API}/getOrders';
  static const String Splash = "${API}/intro";
  static const String SubDepartment ='${API}/department';
  static const String Products ='${API}/products';
  static const String AddProduct ='${API}/addCart';
  static const String getCart ='${API}/getCart';
  static const String updateCart ='${API}/cartUpdate';
  static const String useBalance ='${API}/useBalance';
  static const String deleteOrder ='${API}/deleteOrder';
  static const String orderEdit ='${API}/orderEdit';

  static const String addProductToFav ='${API}/addProductToFav';
  static const String deleteProductFromFav ='${API}/deleteProductFromFav';
  static const String viewProductFav ='${API}/viewProductFav';

  static const String confirmOrder ='${API}/confirmOrder';
  static const String Offer ='${API}/offer_details';
  static const String about ='${API}/about';
  static const String notify ='${API}/notificationsapi';


  static const String sendPhone = "${API}/user/resetPassword";
  static const String forgot = "${API}/user/resetPasswordConfirm";
  static const String popup = "${API}/popup";












}
