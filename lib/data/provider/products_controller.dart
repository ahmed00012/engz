import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/models/sub_category_model.dart';
import 'package:engez/data/servicese/products_service.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../local_storage.dart';


final productsFuture = ChangeNotifierProvider.autoDispose
    .family<ProductsController, int>(
        (ref, company) => ProductsController(company));

class ProductsController extends ChangeNotifier {
  List<SubCategoryModel> subCategory = [];
  List<ProductModel> productsPaginated = [];
  List<int> productsId = [];
  List<int> quantities = [];
static  double? total = 0.0;
  bool loading = true;
  String? companyID;
  int? company;
  static int? subCategoryID;
  static String filter ='';
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  static int counter = LocalStorage.getData(key: 'counter') ?? 0;
  final debouncer = Debouncer(milliseconds: 300);


  ProductsService productsService = ProductsService();

  ProductsController(this.company) {
    filter ='';
    getProducts();
    notifyListeners();
    productsId = [];
 quantities = [];
 productsPaginated=[];

  }

  void getProducts() async {
    // productsPaginated=[];
    // quantities=[];
    // productsId=[];
    if (companyID == null && company == 0) {
      loading = true;
      var data = await productsService.getProducts(filter,subCategoryID!, '0', page,token: LocalStorage.getData(key: 'token') ?? '');
      LocalStorage.saveData(key: 'counter', value: data['CountCart']);
     total = double.parse(data['TotalCart'].toString());
     log(data.toString());

      if (page <= data['pages_total']) {

        List list = List<ProductModel>.from(
            data['products'].map((product) => ProductModel.fromJson(product)));
        list.forEach((element) {
          productsPaginated.add(element);
        });

        subCategory = List<SubCategoryModel>.from(data['company']
            .map((company) => SubCategoryModel.fromJson(company)));
        subCategory.insert(0, SubCategoryModel(title: 'الكل', chosen: true));

        page++;
        refreshController.loadComplete();
      } else {
        refreshController.loadComplete();
      }
    } else {
      if (company != 0) companyID = company.toString();
      filterProducts();
    }
    loading = false;
    notifyListeners();
  }

  switchCompany(int index) {
    subCategory.forEach((element) {
      element.chosen = false;
    });
    subCategory[index].chosen = true;
    notifyListeners();
  }

  void filterProducts() async {
    loading = true;
    var data = await productsService.getProducts(filter,
        subCategoryID!, companyID!, page,
        token: LocalStorage.getData(key: 'token') ?? '');
    LocalStorage.saveData(key: 'counter', value: data['CountCart']);
    if(LocalStorage.getData(key: 'token') != null)
    LocalStorage.saveData(key: 'city_minDelivery',value: int.parse(data['min_order']));
    print(data['min_order']);
    total = double.parse(data['TotalCart'].toString());
    if (page <= data['pages_total']) {
      List list = List<ProductModel>.from(
          data['products'].map((product) => ProductModel.fromJson(product)));
      subCategory = List<SubCategoryModel>.from(
          data['company'].map((company) => SubCategoryModel.fromJson(company)));
      subCategory.insert(0, SubCategoryModel(title: 'الكل', chosen: false));
      for (int i = 0; i < subCategory.length; i++) {
        if (subCategory[i].id.toString() == companyID) {
          switchCompany(i);
        }
      }
      list.forEach((element) {
        productsPaginated.add(element);
      });
      list = [];
      page++;
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
    loading = false;
    notifyListeners();
  }

  String getQuantity(int id) {
    int index = productsId.indexOf(id);
    return quantities[index].toString();
  }

  bool isLogin(BuildContext context) {
    if (LocalStorage.getData(key: 'token') == null) {
      displayToastMessage('عليك التسجيل اولا');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(
               //       id: productsId, quantity: quantities
                  )),
          (route) => false);
      return false;
    } else
      return true;
  }

 void addProductInitial(int id) {
    LocalStorage.saveData(
        key: 'counter', value: LocalStorage.getData(key: 'counter') + 1);
    updateCart(id, 1);
    productsId.add(id);
    quantities.add(1);
    productsPaginated.forEach((element) {
      if (element.id == id) {
        total = total! + element.price!;
      }
    });
    notifyListeners();
  }

 void addProduct(int id, bool cart, double price, int maxQty) {
    int index = productsId.indexOf(id);
    if (quantities[index] < maxQty) {
      quantities[index] = quantities[index] + 1;
      total = total! + price;
      updateCart(id, 1);
    } else {
      displayToastMessage('اقصى كمية يمكن طلبها من هذا المنتج $maxQty');
    }

    notifyListeners();
  }

  removeProduct(int id, bool cart, double price) {
    int index = productsId.indexOf(id);
    print(quantities);
    if (quantities[index] > 0) quantities[index] = quantities[index] - 1;
    if (quantities[index] == 0) {
      productsId.removeAt(index);
      quantities.removeAt(index);
      LocalStorage.saveData(
          key: 'counter', value: LocalStorage.getData(key: 'counter') - 1);
      // counter = counter-1;
    }
    total = total! - price;
    updateCart(id, 2);
    notifyListeners();
  }

  int cityMinDilivery() {
    if (LocalStorage.getData(key: 'city_minDelivery') != null)
      return LocalStorage.getData(key: 'city_minDelivery');
    else
      return 0;
  }

  void updateCart(int id, int actionType) async {
    var data = productsService.updateCart(
        {'click_type': actionType, 'product_id': id},
        LocalStorage.getData(key: 'token'));
    notifyListeners();
  }

  void refresh(double value) {
    print("hhhhhhhhhhhhhhh");
    print(value);
    total = value;
    if(value==0) {
      quantities = [];
      productsId = [];
    }
    notifyListeners();
  }
  void addFav(int id) async {
    var data = productsService.addToFav(id,
        LocalStorage.getData(key: 'token'));
    displayToastMessage("تم اضافة المنتج الي المفضلة");
    notifyListeners();
  }

  void removeFav(int id) async {
    var data = productsService.removeFromFav(id,
        LocalStorage.getData(key: 'token'));

    displayToastMessage("تم ازالة المنتج من المفضلة");

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


class Debouncer {
  final int milliseconds;
  VoidCallback ?action;
  Timer? timer;

  Debouncer({required this.milliseconds,this.timer,this.action});

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}