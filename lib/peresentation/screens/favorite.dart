

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/models/product_model.dart';
import 'package:engez/data/provider/fav.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';



class Favorite extends ConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final productsController = ref.watch(favFuture);
    return
      productsController.token == ''
          ? LoginScreen():
      Scaffold(
        appBar: AppBar(
          backgroundColor: dark,
          title: Text("المفضلة",
            style: TextStyle(color: Colors.white, fontSize: size.height * 0.02),
          ),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),

        ),
        body:productsController.loading?

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
                    ))
                    :
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




                                productsController.removeFav(product.id!);
                                productsController.productsPaginated.removeAt(i);
                                product.isFav =false;
                              }else
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
                      // !productsController.productsId
                      //     .contains(product.id!)
                      // //   && productsController.productsPaginated[i].cartCount==null
                      //     ?
                      InkWell(
                        onTap: () {
                          // if (productsController
                          //     .isLogin(context)) {
                          // if(!FavProvider.productsId.contains(product.id))
                            productsController
                                .addProductInitial(
                                product.id!);
                          //   ProductsController.counter =
                          //       ProductsController
                          //           .counter +
                          //           1;
                          // }
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color:kColorAccent ,
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
                    ],
                  ),
                ),
              ),
            );
          },
        ):
        productsController.productsPaginated.isEmpty?
        Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/images/fav.gif',
                    height: size.height *.3,
                    width: 400),
                Text(
                  'المفضلة فارغة',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: dark),
                )
              ],
            ),
          ),
        ):

        SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          header: WaterDropHeader(),
          controller: productsController.controller,
          onLoading: productsController.getProducts,
          child:
          ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 15,
              ),
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
                          ))
                          :
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




                                        productsController.removeFav(product.id!);
                                        productsController.productsPaginated.removeAt(i);
                                        product.isFav =false;
                                      }else
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
                            // !productsController.productsId
                            //     .contains(product.id!)
                            // //   && productsController.productsPaginated[i].cartCount==null
                            //     ?
                            InkWell(
                              onTap: () {
                                // if (productsController
                                //     .isLogin(context)) {
                                // if(!FavProvider.productsId.contains(product.id))
                                  productsController
                                      .addProductInitial(
                                      product.id!);
                                //   ProductsController.counter =
                                //       ProductsController
                                //           .counter +
                                //           1;
                                // }
                              },
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    color:kColorAccent,
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
        )
    );
  }
}
