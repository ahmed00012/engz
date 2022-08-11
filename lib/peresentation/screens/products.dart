
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/peresentation/screens/cart.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';



class Products extends ConsumerWidget {
  String? subCategory;
  int? company;
  Products({this.subCategory, this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final productsController = ref.watch(productsFuture(company ?? 0));
    return Scaffold(
        backgroundColor:Color(0xffEEEEEE) ,

        appBar: AppBar(
          backgroundColor: dark,
          title: Text(
            subCategory!,
            style: TextStyle(color: Colors.white, fontSize: size.height * 0.02),
          ),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CartScreen())).then((value) => productsController.refresh(value));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                        height: size.height * 0.02,
                        width: size.height * 0.02,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                             ProductsController.counter.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.015,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: size.height * 0.03,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
           SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              header: WaterDropHeader(),
             controller: productsController.refreshController,
             onLoading: productsController.getProducts,
             child:
          ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: size.height * .08,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: productsController.subCategory.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  productsController.switchCompany(index);
                                  productsController.page = 1;
                                  productsController.productsPaginated = [];
                                  if (index == 0) {
                                    productsController.loading = true;
                                    productsController.companyID = null;
                                    productsController.company = 0;
                                    productsController.getProducts();
                                  } else {
                                    productsController.companyID =
                                        productsController.subCategory[index].id
                                            .toString();
                                    productsController.filterProducts();
                                  }
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
                                          productsController
                                              .subCategory[index]
                                              .chosen ??
                                              false
                                              ? dark
                                              :
                                          Colors.transparent)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (productsController
                                            .subCategory[index].image ==
                                            null)
                                          SizedBox(width: 20,),
                                        Text(

                                          productsController
                                              .subCategory[index].title!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: size.height * 0.017,
                                              color: Colors.black,
                                           //   fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        if (productsController
                                            .subCategory[index].image !=
                                            null)
                                          Image.network(
                                            productsController.subCategory[index].image!,
                                            width: size.width * .17,
                                            height: size.height * .06,
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
                  SizedBox(
                    height: 10,
                  ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        onChanged: (value){
          productsController.page =1;
          ProductsController.filter=value;
          productsController.productsId = [];
          productsController.quantities = [];
          productsController.productsPaginated=[];
          productsController.debouncer.run(() {
            productsController.getProducts();

          });


        },
      cursorColor: Colors.grey,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,

      decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding:
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide.none),
      hintText: 'Search',
      hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
      enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
      color: kColorPrimary,
      width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
      color:kColorPrimary,
      width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      prefixIcon: Container(
      padding: EdgeInsets.all(15.0),
      child: Image.asset(
      'assets/images/search.png',
      width: 20.0,
      ),
      ),
      ),
      ),
    ),
                  SizedBox(
                    height: 15,
                  ),
                  productsController.loading ?
                  GridView.builder(
                    itemCount:
                    productsController.loading ? 6
                        : productsController.productsPaginated.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.63),
                    itemBuilder: (context, i) {
                      ProductModel product = ProductModel();
                      if (!productsController.loading) {
                        product = productsController.productsPaginated[i];
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:
                          productsController.loading
                              ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  padding: const EdgeInsets.all(2.0),
                                ),
                              )):
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Image.network(
                                        product.image!,
                                        height: size.height * 0.14,
                                        width: size.width * 0.3,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    if (product.salePercentage != 0.0)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 25,
                                          width: size.width * .18,
                                          padding: EdgeInsets.only(right: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.only(
                                                  topRight:
                                                  Radius.circular(
                                                      8))),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'خصم ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    size.height *
                                                        0.015),
                                              ),
                                              Text(
                                                product.salePercentage.toString() + '%',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    size.height *
                                                        0.015),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    GestureDetector(
                                      onTap: (){
                                        if(LocalStorage.getData(key: 'token') != null){
                                          if(product.isFav == false){
                                            productsController.addFav(product.id!);
                                            product.isFav =true;
                                          }else{
                                            productsController.removeFav(product.id!);
                                            product.isFav =false;
                                          }}else
                                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => LoginScreen()));

                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            height: 33,
                                            width: size.width * .1,
                                            margin: EdgeInsets.only(left: 2),
                                            decoration: BoxDecoration(
                                              shape:  BoxShape.circle,
                                              color: kColorAccent,
                                              //  borderRadius:
                                              //  BorderRadius.only(
                                              //      topRight:
                                              //      Radius.circular(
                                              //          8)
                                              //  )
                                            ),
                                            child: Icon(product.isFav==true?Icons.favorite:Icons.favorite_border,color: Colors.white,)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: Text(
                                    product.title!,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child:
                                  product.description!=null?
                                  Column(
                                    children: [
                                      Text(
                                        product.description! ,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                      Text(
                                        //  "200 ml",
                                        product.type!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      )
                                    ],
                                  ):
                                  Text(
                                    product.type??'',
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                    ),
                                  ),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        product.price.toString()
                                            +
                                            ' جنيه ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (product.oldPrice != 0.0)
                                        Text(
                                          // "230"
                                          product.oldPrice.toString()
                                              +
                                              ' جنيه ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                              size.height * 0.015,
                                              color: Colors.red,
                                              fontFamily:
                                              'RobotoCondensed',
                                              decoration: TextDecoration
                                                  .lineThrough),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'سعر القطعة :  ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                      Text(
                                        product.pricePerUnit.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '  جنيه',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                !productsController.productsId
                                    .contains(product.id!)
                                //   && productsController.productsPaginated[i].cartCount==null
                                    ?
                                InkWell(
                                  onTap: () {
                                    if (productsController
                                        .isLogin(context)) {
                                      productsController
                                          .addProductInitial(
                                          product.id!);
                                      ProductsController.counter =
                                          ProductsController
                                              .counter +
                                              1;
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: kColorAccent,
                                        borderRadius:
                                        BorderRadius.only(
                                          bottomRight:
                                          Radius.circular(8),
                                          bottomLeft:
                                          Radius.circular(8),
                                        )),
                                    child: Center(
                                      child: Text(
                                        'شراء',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            size.height * 0.02),
                                      ),
                                    ),
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        productsController
                                            .addProduct(
                                            product.id!,
                                            false,
                                            product.price!,
                                            product.minQty!);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: kColorAccent,
                                            borderRadius:
                                            BorderRadius.only(
                                              bottomLeft:
                                              Radius.circular(
                                                  8),
                                            )),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      //productsController.productsPaginated[i].cartCount==null?
                                      productsController.getQuantity(product.id!),
                                      //:
                                      //      productsController.productsPaginated[i].cartCount.toString(),
                                      style: TextStyle(
                                          fontSize:
                                          size.height * 0.018),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        productsController
                                            .removeProduct(
                                            product.id!,
                                            false,
                                            product.price!);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: kColorAccent,
                                            borderRadius:
                                            BorderRadius.only(
                                              bottomRight:
                                              Radius.circular(
                                                  8),
                                            )),
                                        child: Center(
                                          child: Icon(
                                            Icons.minimize,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ):
                  productsController.productsPaginated.isEmpty?
                  Container(
                    // height: size.height,
                    // width: size.width,
                    // color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              'assets/images/box.gif',
                              height: 260,
                              width: 400),
                          SizedBox(height: size.height * .04,),
                          Text(
                            'القسم فارغ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: dark),
                          )
                        ],
                      ),
                    ),
                  ):
                  GridView.builder(
                    itemCount:
                    productsController.loading ? 6
                        : productsController.productsPaginated.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.63),
                    itemBuilder: (context, i) {
                      ProductModel product = ProductModel();
                      if (!productsController.loading) {
                        product = productsController.productsPaginated[i];
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                           child:
                          productsController.loading
                              ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  padding: const EdgeInsets.all(2.0),
                                ),
                              )):
                            Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Image.network(
                                        product.image!,
                                        height: size.height * 0.14,
                                        width: size.width * 0.3,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    if (product.salePercentage != 0.0)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 25,
                                          width: size.width * .18,
                                          padding: EdgeInsets.only(right: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.only(
                                                  topRight:
                                                  Radius.circular(
                                                      8))),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'خصم ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    size.height *
                                                        0.015),
                                              ),
                                              Text(
                                                product.salePercentage.toString() + '%',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    size.height *
                                                        0.015),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    GestureDetector(
                                      onTap: (){
                                        if(LocalStorage.getData(key: 'token') != null){
                                        if(product.isFav == false){
                                          productsController.addFav(product.id!);
                                          product.isFav =true;
                                        }else{
                                          productsController.removeFav(product.id!);
                                          product.isFav =false;
                                        }}else
                                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => LoginScreen()));

                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 33,
                                          width: size.width * .1,
                                         margin: EdgeInsets.only(left: 2),
                                          decoration: BoxDecoration(
                                            shape:  BoxShape.circle,
                                              color: kColorAccent,
                                             //  borderRadius:
                                             //  BorderRadius.only(
                                             //      topRight:
                                             //      Radius.circular(
                                             //          8)
                                             //  )
                                          ),
                                          child: Icon(product.isFav==true?Icons.favorite:Icons.favorite_border,color: Colors.white,)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: Text(
                                    product.title!,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child:
                                product.description!=null?
                                  Column(
                                    children: [
                                      Text(
                                        product.description! ,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                      Text(
                                      //  "200 ml",
                                        product.type!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      )
                                    ],
                                  ):
                                  Text(
                                    product.type??'',
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                    ),
                                  ),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        product.price.toString()
                                            +
                                            ' جنيه ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (product.oldPrice != 0.0)
                                        Text(
                                         // "230"
                                          product.oldPrice.toString()
                                              +
                                              ' جنيه ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                              size.height * 0.015,
                                              color: Colors.red,
                                              fontFamily:
                                              'RobotoCondensed',
                                              decoration: TextDecoration
                                                  .lineThrough),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'سعر القطعة :  ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                      Text(
                                        product.pricePerUnit.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '  جنيه',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height * 0.017,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                !productsController.productsId
                                    .contains(product.id!)
                                 //   && productsController.productsPaginated[i].cartCount==null
                                   ?
                          InkWell(
                                  onTap: () {
                                    if (productsController
                                        .isLogin(context)) {
                                      productsController
                                          .addProductInitial(
                                          product.id!);
                                      ProductsController.counter =
                                          ProductsController
                                              .counter +
                                              1;
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: kColorAccent,
                                        borderRadius:
                                        BorderRadius.only(
                                          bottomRight:
                                          Radius.circular(8),
                                          bottomLeft:
                                          Radius.circular(8),
                                        )),
                                    child: Center(
                                      child: Text(
                                        'شراء',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            size.height * 0.02),
                                      ),
                                    ),
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        productsController
                                            .addProduct(
                                            product.id!,
                                            false,
                                            product.price!,
                                            product.minQty!);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: kColorAccent,
                                            borderRadius:
                                            BorderRadius.only(
                                              bottomLeft:
                                              Radius.circular(
                                                  8),
                                            )),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      //productsController.productsPaginated[i].cartCount==null?
                                    productsController.getQuantity(product.id!),
                          //:
                              //      productsController.productsPaginated[i].cartCount.toString(),
                                      style: TextStyle(
                                          fontSize:
                                          size.height * 0.018),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        productsController
                                            .removeProduct(
                                            product.id!,
                                            false,
                                            product.price!);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: kColorAccent,
                                            borderRadius:
                                            BorderRadius.only(
                                              bottomRight:
                                              Radius.circular(
                                                  8),
                                            )),
                                        child: Center(
                                          child: Icon(
                                            Icons.minimize,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
              if (productsController.cityMinDilivery() > 0)
  Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_)=>CartScreen())).then((value) => productsController.refresh(value));
                  },
                  child: Container(
                    height: 100,
                    width: size.width,
                    color: Color(0xffD8D2CB),
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: size.width *
                              (ProductsController.total! /
                                  productsController.cityMinDilivery()),
                          color: Color(0xff20bf55),
                          // Color(0xff20bf55),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: size.width * 0.25,
                              child: Center(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اطلب الان',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      'كاش',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold),
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' الحد الادنى للطلب ${productsController.cityMinDilivery()} جنيه',
                                  style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' اجمالي طلبك ${ProductsController.total!.toStringAsFixed(2)} جنيه',
                                  style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
             ),
          ],
        )
    );
  }
}
