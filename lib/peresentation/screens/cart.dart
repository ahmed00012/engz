import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/provider/cart_controller.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';

class CartScreen extends ConsumerWidget {
  bool? fromNav;

  CartScreen({this.fromNav});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, String>> slider = [
      {"image": "assets/images/cream.png"},
      {"image": "assets/images/pngwing.com.png"},
      {"image": "assets/images/cream.png"},
    ];
    Size size = MediaQuery.of(context).size;
    final viewModel = ref.watch(cartFuture);
    return WillPopScope(
      onWillPop: () {
        if (fromNav != true || fromNav != null) {
          print(viewModel.total.toString()+"lllllllllllllfff");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavBar()),
                  (route) => false);
        }
        else {
          print(viewModel.total.toString()+"lllllllllllll");
          Navigator.pop(context, viewModel.subTotal);
        }        return Future.value(false);
      },
      child: viewModel.token == ''
          ? LoginScreen()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: dark,
                title: Text(
                  'سلة المنتجات',
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height * 0.02),
                ),
                centerTitle: true,
                leading: InkWell(
                    onTap: () {
                      print(viewModel.total.toString()+"llllllllllllllllllj");
                      if (fromNav != true || fromNav != null) {
                        print(viewModel.total.toString()+"lllllllllllllfff");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()),
                                (route) => false);
                      }
                      else {
                        print(viewModel.total.toString()+"lllllllllllll");
                        Navigator.pop(context, viewModel.subTotal);
                      }
                    },
                    child: Icon(Icons.arrow_back_ios)),
              ),
              body: Skeleton(
                isLoading: viewModel.cartLoading,
                skeleton: SkeletonListView(
                  itemCount: 5,
                  itemBuilder: (context, i) {
                    return SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        height: 150,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5),
                      ),
                    );
                  },
                ),
                child: Stack(
                  children: [
                    viewModel.cartItemsAPI.isEmpty
                        ? Container(
                      height: size.height,
                          width: size.width,
                          color: Colors.white,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/images/cart.gif',
                                      height: size.height *.37,
                                 //     width: 400
                                  ),
                                  Text(
                                    'السلة فارغة',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: dark),
                                  )
                                ],
                              ),
                            ),
                        )
                        : ListView(
                            children: [
                              ListView.builder(
                                  itemCount: viewModel.cartItemsAPI.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    ProductModel product =
                                        viewModel.cartItemsAPI[i];
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              height: 140,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Row(
                                                textDirection:
                                                    TextDirection.rtl,
                                                children: [
                                                  SizedBox(width: size.width * .03,),

                                                  Flexible(
                                                    flex:4,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(10),
                                                          bottomRight:
                                                              Radius.circular(10),
                                                        ),
                                                        child: Image.network(
                                                          product.image!,
                                                        // height: size.height * .13,
                                                         width: size.width * 0.21,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: size.width * .03,),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: Container(
                                                            width: size.width *
                                                                0.45,
                                                            child: Text(
                                                              product.title!,
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.019,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            width: size.width *
                                                                0.36,
                                                            child:
                                                                product.description !=
                                                                        null
                                                                    ? Text(
                                                                        product.description! +
                                                                            ' - ' +
                                                                            product.type!,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            3,
                                                                        style: TextStyle(
                                                                            fontSize: size.height *
                                                                                0.017,
                                                                            color:
                                                                                Colors.grey),
                                                                      )
                                                                    : Text(
                                                                        product.type ??
                                                                            '',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            3,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              size.height * 0.017,
                                                                        ),
                                                                      )),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'السعر :  ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.017,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            Text(
                                                              product.price
                                                                      .toString() +
                                                                  ' جنيه',
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.017,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'سعر القطعة :  ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.017,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                product
                                                                    .pricePerUnit
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.017,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                '  جنيه',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.017,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            viewModel.updateCart(
                                                                product.id!,
                                                                1,
                                                                product.price!,
                                                                index: i,
                                                                maxQTY: product
                                                                    .minQty);
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kColorAccent,
                                                              //  borderRadius:
                                                              //  BorderRadius.only(
                                                              //    topLeft:
                                                              //    Radius.circular(8),
                                                              // )
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          product.qty
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.018),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            viewModel.updateCart(
                                                                product.id!,
                                                                2,
                                                                product.price!,
                                                                index: i,
                                                                maxQTY: product
                                                                    .minQty);
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 60,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kColorAccent,
                                                              // borderRadius:
                                                              // BorderRadius.only(
                                                              //   bottomLeft:
                                                              //   Radius.circular(8),
                                                              // )
                                                            ),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .minus,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Positioned(
                                        //   right: 0,
                                        //   top: 0,
                                        //   child: Container(
                                        //     height: 40,
                                        //     width: 50,
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
                                        //         height: size.height * .033,
                                        //         color: Colors.red,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  }),
                              SizedBox(
                                height:  fromNav == true? 300 : 200,
                              ),
                            ],
                          ),
                    if (!viewModel.cartLoading &&
                        viewModel.cartItemsAPI.isNotEmpty)
                      Padding(
                        padding:
                            EdgeInsets.only(bottom:  fromNav == true? 65 : 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              padding:
                              EdgeInsets.only(top: 20),
                          //    height: size.height *.4,
                            //  alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * .08,
                                        right: size.width * .1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${viewModel.subTotal!.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: dark,
                                            fontSize: size.height * 0.02,
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          'اجمالي الطلب',
                                          style: TextStyle(
                                            color: dark,
                                            fontSize: size.height * 0.02,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * .08,
                                        right: size.width * .07),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${viewModel.tax!.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: dark,
                                            fontSize: size.height * 0.02,
                                            //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          'الضريبة',
                                          style: TextStyle(
                                            color: dark,
                                            fontSize: size.height * 0.02,
                                            //  fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .01,
                                  ),

                                  viewModel.cartBalance == null?
                                  GestureDetector(
                                    onTap: (){
                                      if(viewModel.balance! > 0 )
                                      viewModel.useBalance();
                                    },
                                    child: Container(
                                      //   height: ,
                                      width: size.width * .9,

                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(color: kColorAccent)
                                      ),
                                      child:  Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .016,
                                            bottom: size.height * .016,
                                            left: size.width * .05,
                                            right: size.width * .03),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${viewModel.balance!.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: dark,
                                                fontSize: size.height * 0.02,
                                                //    fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              'استخدم رصيدك',
                                              style: TextStyle(
                                                color: dark,
                                                fontSize: size.height * 0.02 ,
                                                //  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ):
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text(
                                        'تم الخصم بنجاح',
                                        style: TextStyle(
                                          color: dark,
                                          fontSize: size.height * 0.023,
                                          //  fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Image.asset("assets/images/check.png",height: size.height *.03 ,),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        if (viewModel.total! >=
                                            viewModel.cityMinDilivery() &&
                                            viewModel.cartItemsAPI.length >=
                                                LocalStorage.getData(
                                                    key: 'minProductOrder'))
                                          viewModel.confirmOrder(context);
                                        else if (viewModel.total! <
                                            viewModel.cityMinDilivery())
                                          viewModel.displayToastMessage(
                                              'اقل قيمة للطلب ${viewModel.cityMinDilivery()} جنيه');
                                        else if (viewModel.cartItemsAPI.length <
                                            LocalStorage.getData(
                                                key: 'minProductOrder'))
                                          viewModel.displayToastMessage(
                                              'اقل عدد اصناف للطلب الواحد يجب ان تكون ${LocalStorage.getData(key: 'minProductOrder')} صنف');
                                        // print(viewModel.total);
                                        // print(viewModel.cityMinDilivery());
                                      },
                                      child: Container(
                                          height: 60,
                                          width: size.width,
                                          color: viewModel.total! <
                                              viewModel.cityMinDilivery()
                                              ? Color(0xff979dac)
                                              : Color(0xff20bf55),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                width: size.width * 0.25,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'اطلب الان',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                            size.height * 0.02,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        'كاش',
                                                        style: TextStyle(
                                                            color: Colors.amber,
                                                            fontSize:
                                                            size.height * 0.02,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 200,
                                                width: 1,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'الاجمالي ${viewModel.total!.toStringAsFixed(2)} جنيه',
                                                style: TextStyle(
                                                  fontSize: size.height * 0.025,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                  ],
                ),
              )),
    );
  }
}
