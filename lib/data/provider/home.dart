
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/home.dart';
import 'package:engez/data/provider/fav.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/data/servicese/home.dart';
import 'package:engez/data/servicese/products_service.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../constant.dart';
import '../local_storage.dart';

final homeFuture =
ChangeNotifierProvider.autoDispose.family<HomeProvider,bool>((ref,fromNav) => HomeProvider(fromNav));
class HomeProvider extends ChangeNotifier{
  String token='';
  HomeProvider(this.fromNav){
    count ++;
    token = LocalStorage.getData(key: "token")??'';
    getHome();
    if(fromNav == true)
    getPopup();
    _timer = new Timer(const Duration(seconds: 60), () {
      show = false;
      //notifyListeners();
    });

  }
  bool fromNav = false;
  int count =0;
  Timer ?_timer;
  HomeModel home = new HomeModel();
static  bool show =true;
bool load = true;
 bool isLoad =true;
  int current=0;
  Popup popup = Popup();
  ProductsService productsService = ProductsService();



  void getHome()async{
   var data= await HomeService.instance.getHome(LocalStorage.getData(key: 'token')??'');
   isLoad =false;
   home = data!;


  //ProductsController.counter = home.cartCount!;

   notifyListeners();
  }
void refresh(){
    notifyListeners();
}
  void getPopup()async{
    var data= await HomeService.instance.getPopup();
    popup=data;
 //   show = true;
    load = false;
    notifyListeners();
  }
  closePopUp(){
    show = false;
    notifyListeners();
  }

  void updateCart(int id, int actionType) async {
    var data = productsService.updateCart(
        {'click_type': actionType, 'product_id': id},
        LocalStorage.getData(key: 'token'));
    notifyListeners();
  }
  void addProductInitial(int id) {
    LocalStorage.saveData(
        key: 'counter', value: LocalStorage.getData(key: 'counter') + 1);
    updateCart(id, 1);
    FavProvider.productsId.add(id);
    //quantities.add(1);
    home.products!.forEach((element) {
      if (element.id == id) {
        ProductsController.total =     ProductsController.total! + element.price!;
      }
    });
    displayToastMessage("تم اضافة المنتج الي السلة");
    notifyListeners();
  }
  void displayToastMessage(var toastMessage) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background:  Color(0xff20bf55));
  }
  AnimatedContainer buildDot({int ?index}) {
// print(current);
// print(index);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 4,
      width: current == index ? 22 : 22,
      decoration: BoxDecoration(
        color: current == index ? dark : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),

    );

  }

}