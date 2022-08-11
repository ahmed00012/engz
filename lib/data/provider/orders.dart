import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/order.dart';
import 'package:engez/data/servicese/orders.dart';
import 'package:engez/peresentation/screens/cart.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import '../local_storage.dart';

final ordersFuture =
ChangeNotifierProvider.autoDispose.family<OrdersProvider,int>((ref,status) => OrdersProvider(status));

class OrdersProvider extends ChangeNotifier{
  OrdersProvider(this.state){
    //switchCompany(0);
    switchCompany(state??0);
    getOrder();
    token = LocalStorage.getData(key: "token")??'';

  }
  static int? statusId =1;
  OrderModel order = new OrderModel();
  bool isLoad =true;
  int orderr =1;
  int page =1;
  int ?state ;

  RefreshController controller = RefreshController();
  String token ='';

   getOrder(){
if(state == 0)
  statusId =1;
    OrdersService.instance.getorders(1,statusId!).then((homeNew){
      order = homeNew!;
      isLoad =false;
      notifyListeners();
    }
    );
  }

  void onRefresh(){
    page++;
    OrdersService.instance.getorders(page,statusId??0).then((valueNew){
      OrderModel? order2 = valueNew!;
      order.data!.data.addAll(order2!.data!.data);
      order2=null;
      controller.loadComplete();
      notifyListeners();
    }
    );
  }
   List<Map<String, dynamic>> status = [
    {"image":  "assets/images/new1.png",
      "title":"الطلبات الجديدة",
      "status":1,
      "chosen":true},
    {"image": "assets/images/sand-clock.png",
      "title":"جاري العمل عليها",
      "status":2,
      "chosen":false},
    {"image": "assets/images/done.png",
      "title":"الطلبات المنتهية",
      "status":3,
      "chosen":false},
    {"image": "assets/images/cancel.png",
      "title":"الطلبات الملغية",
      "status":4,
      "chosen":false},

  ];
  switchCompany(int index) {
    status.forEach((element) {
      element["chosen"] = false;
    });
    status[index]["chosen"] = true;
    notifyListeners();
  }
  void deleteOrder(int id) async {
    var data = OrdersService.instance.delete(
        {'order_id': id},
        LocalStorage.getData(key: 'token')).then((value) {
          if(value["status"] == true){
            displayToastMessage("تم الغاء الطلب بنجاح");
            getOrder();

          }
          else
            displayToastMessage("فشل الغاء الطلب");
    });
    print(data
    .toString()+"mmmmmmmmmmmmmmm");
    notifyListeners();
  }
  void editOrder(int id,context) async {
    var data = OrdersService.instance.editOrder(
        {'order_id': id},
        LocalStorage.getData(key: 'token')).then((value) {
      if(value["status"] == true){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CartScreen(fromNav: false,)));
        //  displayToastMessage("تم الغاء الطلب بنجاح");
       //  getOrder();

      }
      else
        displayToastMessage("فشل تعديل الطلب");
    });
    print(data
        .toString()+"mmmmmmmmmmmmmmm");
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