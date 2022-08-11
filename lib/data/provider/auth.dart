

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:engez/data/models/user.dart';
import 'package:engez/data/servicese/auth.dart';

import '../local_storage.dart';


class AuthProvider with ChangeNotifier {

  UserModel? user;


  Future<void> signUp(String name,
      String phone,
      String password,
      int ? terms,
      String storeName,
      String storeAddress,
      String deviceId,
      int id,
      double lat,
      double lng) async {
    await AuthService.instance.signUp(
      name,
        phone,
        password,
        storeName,
        storeAddress,
        deviceId,
        id,
      lat,
      lng
    );
    notifyListeners();
  }


  Future<void> login(
      String phone,
      String password,
      String deviceId,

      ) async {
    user = await AuthService.instance.login(phone, password,deviceId);
    notifyListeners();
  }

  Future<void> logout() async {
    LocalStorage.saveData(key: 'counter', value: 0);
   // ProductsController.counter = 0;
    await AuthService.instance.logOut();
    user = null;
    notifyListeners();
  }


}
