
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/provider/fav.dart';
import 'package:engez/data/provider/orders.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/data/servicese/products_service.dart';
import 'package:engez/peresentation/screens/orders.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant.dart';
import '../local_storage.dart';

final cartFuture = ChangeNotifierProvider.autoDispose<CartController>(
        (ref) => CartController());

class CartController extends ChangeNotifier {
   List<ProductModel> cartItemsAPI = [];
  ProductsService productsService = ProductsService();
   bool cartLoading= true;
   double? total = 0.0;
   double? subTotal = 0.0;
   double? tax = 0.0;
   double? balance = 0.0;
   String ?cartBalance ;
   int? cartID;
   String token='';

   CartController() {
     print("object");
     token = LocalStorage.getData(key: "token")??'';
    // if(token != '')
     getCart();
   }


   getCart() async {
    var data =
    await productsService.getCart(LocalStorage.getData(key: 'token'));
    cartItemsAPI = List<ProductModel>.from(
        data['data'].map((e) => ProductModel.fromJson(e)));
    LocalStorage.saveData(key: 'counter', value: data['data'].length);
    ProductsController.counter = data['data'].length;
    //LocalStorage.saveData(key: 'tax', value: data['tax']);


    if(data['data'].isNotEmpty)
    cartID  = data['data'][0]['cart_id'];
    else
      cartID = 0;

    if(cartItemsAPI.isNotEmpty) {
      subTotal = double.parse(data['sub_total'].toString());
      tax = double.parse(data['tax'].toString());
      balance = double.parse(data['balance'].toString());
      cartBalance =data['cart_balance'];
      total = double.parse(data['data'][0]['cart_total'].toString());
    }
    LocalStorage.saveData(key: 'counter', value: cartItemsAPI.length);
    print(total);
    cartLoading = false;
    notifyListeners();
  }


   int cityMinDilivery() {
     if (LocalStorage.getData(key: 'city_minDelivery') != null)
       return LocalStorage.getData(key: 'city_minDelivery');
     else
       return 0;
   }


   void updateCart(int id, int actionType, double price,{int? index,int? maxQTY}) async {

     if(index!=null) {
       if(actionType == 1) {
         print(cartItemsAPI[index].minQty!);
         if(cartItemsAPI[index].qty!< cartItemsAPI[index].minQty!) {
           total = total! +price;
           subTotal = subTotal! + price;
          cartItemsAPI[index].qty = cartItemsAPI[index].qty! + 1;
        }
         else
           displayToastMessage('اقصى كمية من هذا المنتج ${cartItemsAPI[index].minQty} قطعة');
      } else {
         total = total! - price;
         subTotal = subTotal! - price;
         print(subTotal);
         print(price);
         if(cartItemsAPI.length==1){
           LocalStorage.removeData(key: 'cart_id');
           LocalStorage.saveData(key: 'counter', value:0);
         }
         if (cartItemsAPI[index].qty! > 1) {
          cartItemsAPI[index].qty = cartItemsAPI[index].qty! - 1;
        } else {
          cartItemsAPI.remove(cartItemsAPI[index]);
          LocalStorage.saveData(key: 'counter', value:LocalStorage.getData(key: 'counter')-1);
          ProductsController.counter =  ProductsController.counter - 1;
          if( FavProvider.productsId.contains(id))
          FavProvider.productsId.remove(id);
        }
      };
     }
     var data = productsService.updateCart(
         {'click_type': actionType, 'product_id': id},
         LocalStorage.getData(key: 'token'));
     print(data);
     notifyListeners();
   }
   void updateRemove(int id, int actionType, double price,{int? index,int? maxQTY}) async {

     if(index!=null) {


           cartItemsAPI.remove(cartItemsAPI[index]);
           LocalStorage.saveData(key: 'counter', value:LocalStorage.getData(key: 'counter')-1);
           ProductsController.counter =  ProductsController.counter - 1 ;

       }

     var data = productsService.updateCart(
         {'click_type': actionType, 'product_id': id},
         LocalStorage.getData(key: 'token'));
     print(data);
     notifyListeners();
   }
   void confirmOrder(BuildContext context) async {
     Size size = MediaQuery.of(context).size;
     // cartLoading = true;
     print(cartBalance);
     if(total!>=cityMinDilivery()) {

      var data = await productsService.confirmOrder(
          cartID!,
          LocalStorage.getData(key: 'token'));
      LocalStorage.saveData(key: 'counter', value:0);
      ProductsController.counter = 0;
      cartItemsAPI = [];
      total = 0.0;
      subTotal =0.0;
      getCart();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
                // title:
            // Center(
                //     child: Text(
                //   'تم ارسال طلبك بنجاح',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: kColorPrimary),
                // )),
                content: Container(
                  height: size.height*0.8,
                  width: size.width*0.9,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/cach.png",),
                        fit: BoxFit.fill,
                    ),),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height *.1,
                        ),
                      Center(
                          child: Text(
                          "انجز",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
                      )),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          width: size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                                      Text(
                                        data['data']['uuid'].toString()+ '#',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                              Text(
                                'رقم الطلب ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              Text(
                                '${data['date']} ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'التاريخ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width*0.5,
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 3.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                      //    dashGradient: [Colors.red, Colors.blue],
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                       //   dashGapGradient: [Colors.red, Colors.blue],
                            dashGapRadius: 0.0,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                               Container(
                                 width: size.width*0.5,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                   children: [
                                     Text(
                                       '${data['subTotal']} ج.م',
                                       textDirection: TextDirection.rtl,
                                       style: TextStyle(
                                           fontWeight: FontWeight.bold, fontSize: 16),
                                     ),
                                     Text(
                                       'اجمالي الطلب   ',
                                       style: TextStyle(
                                           fontWeight: FontWeight.bold, fontSize: 16),
                                     ),

                                   ],
                                 ),
                               ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                '${data['tax']} ج.م',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                  'الضريبة   ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                            ],
                          ),
                        ),

                        if(data['discount']!=null)
                        SizedBox(
                          height: 20,
                        ),
                        if(data['discount']!=null)
                        Container(
                          width: size.width*0.5,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                data['discount'].toString()+ ' ج.م ',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16,color:  Colors.black),
                              ),
                                           Text(
                                             'قيمة الخصم  ',

                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold, fontSize: 16,color:  Colors.black),
                                           ),



                            ],
                          ),
                        ),

                        SizedBox(height: 30,),

                        Container(
                          width: size.width*0.5,
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 3.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            //    dashGradient: [Colors.red, Colors.blue],
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            //   dashGapGradient: [Colors.red, Colors.blue],
                            dashGapRadius: 0.0,
                          ),
                        ),

                        SizedBox(height: 30,),
                        Container(
                          width: size.width*0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                '${data['total']} ج.م',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'اجمالي الفاتورة   ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 20,),
                        Container(
                          width: size.width*0.5,
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 3.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            //    dashGradient: [Colors.red, Colors.blue],
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            //   dashGapGradient: [Colors.red, Colors.blue],
                            dashGapRadius: 0.0,
                          ),
                        ),
                        SizedBox(height: 20,),
                                Container(
                                  width: size.width*0.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            whatsAppOpen();
                                          },
                                          child: Image.asset('assets/images/whatsapp.png',height: 40,width: 40,)),
                                      Spacer(),

                                      InkWell(
                                          onTap: (){ launch("tel://+201559159909");},
                                          child: Icon(Icons.call,size: 35,color: Colors.green,)),

                                      SizedBox(width: 20,),

                                      Text('اتصل بنا  ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ],
                                  ),
                                ),

                        SizedBox(height: 40,),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersProvider.statusId=1;
                          //  order?.switchCompany(1);
                            OrdersProvider.statusId =1;

                       //     push(context, OrdersScreen(status: 0,state: 0,));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrdersScreen(state: 0,status: 0,)),
                                    (route) => false);
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: kColorPrimary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'حسنا',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                ),
                // content: Directionality(
                //   textDirection: TextDirection.rtl,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.75,
                //    // width: MediaQuery.of(context).size.width * 0.9,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //
                //         SizedBox(
                //           height: 10,
                //         ),
                //
                //         Text(
                //           'رقم الطلب '+  data['data']['uuid'].toString()+ '#',
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold, fontSize: 16,color: kColorPrimary),
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //
                //        Row(
                //          mainAxisAlignment: MainAxisAlignment.start,
                //          children: [
                //
                //            Text(
                //              'اجمالي الطلب :  ',
                //              style: TextStyle(
                //                  fontWeight: FontWeight.bold, fontSize: 16,color: Colors.orange),
                //            ),
                //            Text(
                //              '${data['subTotal']} ج.م',
                //              style: TextStyle(
                //                  fontWeight: FontWeight.bold, fontSize: 16,color: kColorPrimary),
                //            ),
                //          ],
                //        ),
                //         SizedBox(height: 5,),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //
                //             Text(
                //               'الضريبة  :  ',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 16,color: Colors.orange),
                //             ),
                //             Text(
                //               '${data['tax']} ج.م',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 16,color: kColorPrimary),
                //             ),
                //           ],
                //         ),
                //
                //        if(data['discount']!=null)
                //          SizedBox(
                //            height: 5,
                //          ),
                //        if(data['discount']!=null)
                //          Row(
                //            mainAxisAlignment: MainAxisAlignment.start,
                //            children: [
                //
                //              Text(
                //                'قيمة الخصم : ',
                //
                //                style: TextStyle(
                //                    fontWeight: FontWeight.bold, fontSize: 16,color:  Colors.orange),
                //              ),
                //              Text(
                //                data['discount'].toString()+ ' ج.م ',
                //
                //                style: TextStyle(
                //                    fontWeight: FontWeight.bold, fontSize: 16,color:  kColorPrimary),
                //              ),
                //            ],
                //          ),
                //         SizedBox(height: 5,),
                //
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //
                //             Text(
                //               'اجمالي الفاتورة :  ',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 16,color: Colors.orange),
                //             ),
                //             Text(
                //               '${data['total']} ج.م',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 16,color: kColorPrimary),
                //             ),
                //           ],
                //         ),
                //
                //
                //         SizedBox(
                //           height: 20,
                //         ),
                //         Image.asset(
                //             'assets/images/succ.gif',height: 170,),
                //         SizedBox(
                //           height: 30,
                //         ),
                //
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //
                //             Text('اتصل بنا : ',
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   color: kColorPrimary,fontWeight: FontWeight.bold
                //               ),),
                //             SizedBox(
                //               width: 20,
                //             ),
                //             InkWell(
                //                 onTap: (){
                //                   whatsAppOpen();
                //                 },
                //                 child: Image.asset('assets/images/whatsapp.png',height: 40,width: 40,)),
                //             SizedBox(
                //               width: 30,
                //             ),
                //             InkWell(
                //                 onTap: (){ launch("tel://+201559159909");},
                //                 child: Icon(Icons.call,size: 35,color: Colors.green,)),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 60,
                //         ),
                //         InkWell(
                //           onTap: () {
                //             Navigator.pop(context);
                //             Navigator.pushAndRemoveUntil(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => OrdersScreen()),
                //                 (route) => false);
                //           },
                //           child: Container(
                //             height: 60,
                //             alignment: Alignment.bottomCenter,
                //             width: MediaQuery.of(context).size.width * 0.4,
                //             decoration: BoxDecoration(
                //                 color: kColorPrimary,
                //                 borderRadius: BorderRadius.circular(10)),
                //             child: Center(
                //               child: Text(
                //                 'حسنا',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 16,
                //                     color: Colors.white),
                //               ),
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ));


    }
     else
       displayToastMessage('اقل قيمة للطلب ${cityMinDilivery()} جنيه');
  }
   void useBalance() async {
print(cartID);
     var data = productsService.useBalance(
         {'cart_id': cartID,},
         LocalStorage.getData(key: 'token')).then((value) =>    getCart() );
     print(data.toString()+"kkkk");
 //    if(data['jj'] == true)

     notifyListeners();
   }

   void whatsAppOpen() async {
     var whatsapp ="+201112027747";
     var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text= ";
     await launch(whatsappURl_android);
   }


   void displayToastMessage(var toastMessage) {
     showSimpleNotification(
         Container(
           height: 60,
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