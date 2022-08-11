

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/data/servicese/products_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../local_storage.dart';

final favFuture =
ChangeNotifierProvider.autoDispose<FavProvider>((ref) => FavProvider());

class FavProvider extends ChangeNotifier{
  FavProvider(){
    token = LocalStorage.getData(key: "token")??'';

    if(token!='')
    getProducts();

  }
  List<ProductModel> productsPaginated = [];

  bool loading =true;
  int orderr =1;
  int page =1;
  RefreshController controller = RefreshController();
  ProductsService productsService = ProductsService();
static  List<int> productsId = [];

  String token ='';
  void getProducts() async {
    // productsPaginated=[];
    // quantities=[];
    // productsId=[];

      loading = true;
      var data = await productsService.getFav( LocalStorage.getData(key: 'token'),page);
   //   LocalStorage.saveData(key: 'counter', value: data['CountCart']);

      if (page <= data['pages_total']) {

        List list = List<ProductModel>.from(
            data['products'].map((product) => ProductModel.fromJson(product)));
        list.forEach((element) {
          productsPaginated.add(element);
        });


        page++;
        controller.loadComplete();
      } else {
        controller.loadComplete();
      }

    loading = false;
    notifyListeners();
  }

  void removeFav(int id) async {
    var data = productsService.removeFromFav(id,
        LocalStorage.getData(key: 'token'));

    displayToastMessage("تم ازالة المنتج من المفضلة");

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
    productsId.add(id);
    //quantities.add(1);
    productsPaginated.forEach((element) {
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
}