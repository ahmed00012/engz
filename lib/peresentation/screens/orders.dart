import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/provider/orders.dart';
import 'package:engez/peresentation/screens/order_details.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

import 'login.dart';


class OrdersScreen extends ConsumerWidget {
  int ? status;
  int ? state;
   OrdersScreen({Key? key,this.status,this.state}) : super(key: key);



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final ordersController = ref.watch(ordersFuture(status??1));
    Size size = MediaQuery.of(context).size;


    return WillPopScope(
      onWillPop: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavBar(index: 0,)), (route) => false);
        return Future.value(false);
      },
      child: ordersController.token == ''
          ? LoginScreen()
      : Scaffold(
       backgroundColor:Color(0xffEEEEEE) ,

        appBar: AppBar(
          backgroundColor: dark,
          title: Text('طلباتي',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight .bold,
                fontSize: 20
            ),
          ),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavBar()), (route) => false);
              },
              child: Icon(Icons.arrow_back_ios)),
        ),
        body:  Directionality(
          textDirection: TextDirection.rtl,
          child:


              // ordersController.order.data!.data.length ==0?
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   color: Colors.white ,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text("لا يوجد طلبات حتي الان", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              //       Image.asset("assets/images/empty.gif")
              //     ],
              //   ),):
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: size.height * .1,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                      shrinkWrap: true,
itemCount: ordersController.status.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                //    ordersController.orderr =1;
                                ordersController.switchCompany(index);
                                ordersController.page =1;
                                ordersController.state =index;
                                print(ordersController.status[index]["status"]);
                                OrdersProvider.statusId = ordersController.status[index]["status"];
                                ordersController.isLoad =true;
                                ordersController.getOrder();
                                // productsController.productsPaginated = [];
                                // if (index == 0) {
                                //   productsController.loading = true;
                                //   productsController.companyID = null;
                                //   productsController.company = 0;
                                //   productsController.getProducts();
                                // } else {
                                //   productsController.companyID =
                                //       productsController.subCategory[index].id
                                //           .toString();
                                //   productsController.filterProducts();
                                // }
                              },
                              child: Container(
                                //   height: 80,
                                //   width: 110,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                        ordersController
                                            .status[index]["chosen"]??
                                            false
                                         ?

                                        dark
                                            :
                                        Colors.transparent
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ordersController
                                            .status[index]["image"],
                                        width: size.width * .16,
                                        height: size.height * .04,
                                      ),
                                      SizedBox(height: 7,),

                                      Text(ordersController
                                          .status[index]["title"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.016,
                                          color: Colors.black,
                                          //   fontWeight: FontWeight.bold
                                        ),
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                      }),
                ),
              ),
              !ordersController.isLoad ?
              ordersController.order.data!.data.isEmpty?
              Container(
                // height: size.height,
                // width: size.width,
                // color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                          'assets/images/orders.gif',
                          height: 400,
                          width: 400),
                      Text(
                        'لا يوجد طلبات',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: dark),
                      )
                    ],
                  ),
                ),
              ):
              SizedBox(
                height: size.height * .7,
                child: SmartRefresher(
                  header: WaterDropHeader(),
                  controller: ordersController.controller,
                  onLoading: () {
                    ordersController.onRefresh();
                  },
                  enablePullUp: true,
                  enablePullDown: false,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount:   ordersController.order.data?.data.length??0,
                   // physics: NeverScrollableScrollPhysics(),
                   // ordersController.order.data?.data.length??0,
                    itemBuilder: (ctx, index) =>
                        Stack(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return OrderDetails(orderDetail: ordersController.order.data!.data[index],);
                                    },

                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                                child: Container(
                                  width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,

                                    ),
                                    child:Padding(
                                      padding: const EdgeInsets.only(top: 18.0,right: 15,bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('# '+'${ordersController.order.data!.data[index].uuid.toString()}',
                                            style: TextStyle(
                                              color: kColorAccent,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 3,),
                                          Text('التكلفة الكلية :${ordersController.order.data!.data[index].cart!.total} جنيها ',
                                            style: TextStyle(
                                                color: kColorPrimary,
                                                fontSize: 18,
                                               // fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 3,),
                                          Text(ordersController.order.data!.data[index].cart!.updatedAt.toString(),
                                            style: TextStyle(
                                                color: kColorPrimary,
                                                fontSize: 15,
                                             //   fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 3,),
                                          Text(ordersController.order.data!.data[index].statusId ==1?"طلب جديد":OrdersProvider.statusId ==2?"جاري العمل عليه":OrdersProvider.statusId ==3?"تم التسليم":'طلب ملغي',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              //   fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          if(ordersController.order.data!.data[index].statusId ==1)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  ordersController.editOrder(ordersController.order.data!.data[index].id!,context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      height: size.height * .05,
                                                      width: size.width *.24,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7),
                                                        color: Colors.green.shade400,

                                                      ),
                                                      child: Center(
                                                        child: Text("تعديل الطلب",
                                                          textAlign: TextAlign.left,
                                                          //ordersController.order.data!.data[index].createdAt.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            //   fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  ordersController.deleteOrder(ordersController.order.data!.data[index].id!);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      height: size.height * .05,
                                                      width: size.width *.24,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7),
                                                        color: Colors.red.shade400,

                                                      ),
                                                      child: Center(
                                                        child: Text("الغاء الطلب",
                                                          textAlign: TextAlign.left,
                                                          //ordersController.order.data!.data[index].createdAt.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            //   fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                )
                              ),
                            ),
                            // Positioned(
                            //   left: 4,
                            //   top: 0,
                            //   child: Container(
                            //     height: 35,
                            //     width: 40,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: Colors.white,
                            //       border: Border.all(color: kColorPrimary)
                            //       // borderRadius:
                            //       // BorderRadius.only(
                            //       //   bottomLeft:
                            //       //   Radius.circular(8),
                            //       // )
                            //     ),
                            //     child: Center(
                            //       child: Image.asset(
                            //       "assets/images/delete.png",
                            //         height: size.height * .026,
                            //         color: Colors.red,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                  ),
                ),
              ):
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,

                itemBuilder: (ctx, index) =>
                    InkWell(
                      onTap: (){
                      },

                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 15,
                                  offset: Offset(0, 5), // changes position of shadow
                                ),
                              ],

                            ),
                            child: SkeletonAvatar(
                                style: SkeletonAvatarStyle( height: 98)
                            ),
                          )
                      ),

                    ),
              ),
              SizedBox(height: size.height * .1 ,)
            ],
          )

        ),
      ),
    );
  }
}
