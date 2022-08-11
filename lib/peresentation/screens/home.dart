import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/provider/fav.dart';
import 'package:engez/data/provider/home.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:engez/peresentation/screens/more.dart';
import 'package:engez/peresentation/screens/products.dart';
import 'package:engez/peresentation/widgets/default_button.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';
import 'departments.dart';

class HomeScreen extends StatefulWidget {
  bool ?fromNav =false;
  int ? count =0;
   HomeScreen({Key? key,this.fromNav,this.count}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current =0;
  AnimatedContainer buildDot({int ?index}) {

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
  List<Map<String, String>> sliders = [
    {"image": "assets/images/1.webp"},
    {"image": "assets/images/2.jpg"},
  ];
  List<Map<String, String>> slider = [
    {"image": "assets/images/lip.png"},
    {"image": "assets/images/cream.png"},
    {"image": "assets/images/pngwing.com.png"},
    {"image": "assets/images/cream.png"},

  ];
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, child) {
      final homeController = ref.watch(homeFuture(widget.fromNav!));
      return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backkk.jpg",),
                    fit: BoxFit.fill
              ),
              // gradient:
              // LinearGradient(colors: [Color(0xFF8e9eab), Color(0xFFeef2f3)],
              //   begin: Alignment.bottomLeft,
              //   end: Alignment.bottomCenter,
              // ),

            ),
          child: OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;
              return connected
                  ? Consumer(builder: (BuildContext context, WidgetRef ref, child) {
                      // final homeController = ref.watch(homeFuture);
                      return SafeArea(

                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: he *.06,),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 26.0, vertical: 5),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: const [
                                  //       Center(
                                  //         child: Text(
                                  //           'انجز',
                                  //           style: TextStyle(
                                  //               color: dark,
                                  //               fontWeight: FontWeight.bold,
                                  //               fontSize: 25),
                                  //         ),
                                  //       ),
                                  //       // IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined,size: 33,color: kColorPrimary,))
                                  //     ],
                                  //   ),
                                  // ),
                                  Expanded(
                                      child:
                                          !homeController.isLoad ?
                                          SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: he * .01,
                                        ),
                                        CarouselSlider(
                                          options: CarouselOptions(
                                              height: he * .21,
                                              autoPlay: true,
                                              onPageChanged: (index, reason) {
                                              //  print(homeController.current);

                                             //   reason=CarouselPageChangedReason.values;
                                                setState(() {
                                                  current = index;
                                                });
                                              }),
                                          items:
                                              homeController.home.sliders!.map((element) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return InkWell(
                                                    onTap: () {
                                                      ProductsController.subCategoryID =element.departmentId;
                                                      if(ProductsController.subCategoryID!=null) {

                                                        Navigator.of(
                                                            context)
                                                            .push(MaterialPageRoute(
                                                            builder:
                                                                (context) {
                                                              return Products(
                                                                company: element
                                                                    .companyId,
                                                                subCategory: element.departmentName,
                                                              );
                                                            })).then((value) => homeController. refresh());
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Card(
                                                          elevation: 2,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Container(
                                                            width: we * 0.8,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),

                                                              child: CachedNetworkImage(
                                                                imageUrl: element.photo!,
                                                                fit: BoxFit.fill,
                                                                placeholder: (context, url) => SkeletonAvatar(
                                                                  style:  SkeletonAvatarStyle(
                                                                    width: we - 20,
                                                                    height: he * .16,
                                                                    padding:  const EdgeInsets.symmetric(
                                                                        vertical: 5.0, horizontal: 5),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ));
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          height: he * .02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            homeController.home.sliders!.length ,
                                            (i){
                                          return    buildDot(index: i);
                                            }
                                          ),
                                        ),
                                        SizedBox(
                                          height: he * .01,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 20.0,bottom: 10,left: 20),
                                            child: homeTitle("الاقسام",(){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => DepartmentsScreen()));},context)),

                                          ),
                                        SizedBox(
                                          height: he * .2,
                                          child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            //     shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: homeController.home.department?.length??0,
                                            itemBuilder: (ctx, index) => InkWell(
                                              onTap: () {
                                                // DepartmentsController.categoryID =  homeController.home
                                                //     .department![index]
                                                //     .id;

                                                // Navigator.of(context)
                                                //     .push(MaterialPageRoute(
                                                //     builder: (context) {
                                                //       return Products(company: 1,subCategory: "مكياج");}));

                                                ProductsController.subCategoryID =  homeController.home
                                                    .department![index]
                                                    .id;
                                                if(ProductsController.subCategoryID != null)
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(builder: (context) {
                                                    return Products(subCategory:homeController.home
                                                        .department![index]
                                                        .name??'');
                                                  })).then((value) => homeController. refresh());

                                                // Navigator.of(context)
                                                //     .push(MaterialPageRoute(
                                                //     builder: (context) {
                                                //       return DepartmentsScreen(
                                                //         name: homeController.home
                                                //             .department![index]
                                                //             .name??'',
                                                //         categoryID:  homeController.home
                                                //             .department![index]
                                                //             .id,);
                                                //     })).then((value) => homeController. refresh());
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 0.0, horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: he * .15,
                                                      child: Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Container(
                                                            width: we * .23,
                                                            height: he * .23,
                                                            decoration: BoxDecoration(
                                                                // image: DecorationImage(
                                                                //   image: AssetImage(
                                                                //       "assets/images/pngwing.com.png"),
                                                                //   fit: BoxFit.fill,
                                                                //
                                                                // ),

                                                                shape: BoxShape.circle,
                                                                color:dark.withOpacity(.1)),
                                                          ),
                                                          CachedNetworkImage(
                                                            imageUrl: homeController.home.department![index].photo!,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => SkeletonAvatar(
                                                              style:  SkeletonAvatarStyle(
                                                            //    width: we - 20,
                                                                height: he * .09,
                                                                // padding:  const EdgeInsets.symmetric(
                                                                //     vertical: 5.0, horizontal: 5),
                                                              ),
                                                            ),
                                                          ),
                                                          // Image.asset(
                                                          //   slider[index]["image"].toString(),
                                                          //   height: he * .09,
                                                          //   fit: BoxFit.cover,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: he * .001,),
                                                    Text(
                                                        homeController.home.department![index].name! ,
                                                      style: TextStyle(
                                                        fontSize: we * .04,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: he * .01,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15.0),
                                            child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: he * .035,
                                                  width: we*.012,
                                                  decoration: BoxDecoration(
                                                   //   color: dark,

                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  child:  VerticalDivider(
                                                      color: dark,
                                                    thickness: we*.012,

                                                  ),),
                                                SizedBox(
                                                  width: we * .017,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    homeController.token ==''?
                                                        "احدث المنتجات":
                                                    "المنتجات التي تهمك",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                           //     fontWeight: FontWeight.bold,
                                                      fontSize: we * .05,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: he * .01,
                                        ),
                                        SizedBox(
                                          height: he * .26,
                                          child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            //     shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:  homeController.home.products?.length??0,
                                            itemBuilder: (ctx, index) => InkWell(
                                              onTap: () {
                                                // DepartmentsController.categoryID =  homeController.home
                                                //     .department![index]
                                                //     .id;

                                                // Navigator.of(context)
                                                //     .push(MaterialPageRoute(
                                                //     builder: (context) {
                                                //       return DepartmentsScreen(
                                                //         name: homeController.home
                                                //             .department![index]
                                                //             .name??'',
                                                //         categoryID:  homeController.home
                                                //             .department![index]
                                                //             .id,);
                                                //     })).then((value) => homeController. refresh());
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 0.0, horizontal: 3),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: he * .24,
                                                      child: Card(
                                                        elevation: 0,
                                                        child: Container(
                                                          width: we * .32,
                                                          height: he * .28,
                                                          decoration: BoxDecoration(
                                                            //  boxShadow: [
                                                              //   BoxShadow(
                                                              //     color: Colors.grey.withOpacity(0.3),
                                                              //     spreadRadius: 3,
                                                              //     blurRadius: 15,
                                                              //     offset: Offset(0, 5), // changes position of shadow
                                                              //   ),
                                                              // ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              color: Colors.white),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: he * .02,
                                                              ),
                                                              Image.network(
                                                                homeController.home.products![index].photo!,
                                                                height: he * .11,
                                                                fit: BoxFit.fill,
                                                              ),
                                                              SizedBox(height: he *.01),
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6.0),
                                                                child: Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text(
                                                                   homeController.home.products![index].title!,
                                                                    textAlign: TextAlign.right,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: we * .036,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                homeController.home.products![index].price.toString()
                                                                    +
                                                                    ' جنيه ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: he * 0.017,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              SizedBox(height: he *.006),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                child: DefaultButton(
                                                                  font:  we*.035,
                                                                  function: (){
                                                                    print("hhhhhhhhhhh");
                                                                    print(homeController.token);
                                                                    if(homeController.token != ""){
                                                                    if(!FavProvider.productsId.contains(homeController.home.products![index].id)) {
                                                                      homeController
                                                                          .addProductInitial(
                                                                          homeController
                                                                              .home
                                                                              .products![index]
                                                                              .id!);
                                                                    }}
                                                                    else{
                                                                      push(context, LoginScreen());
                                                                    }
                                                                  },
                                                                  color:FavProvider.productsId.contains(homeController.home.products![index].id)?Colors.grey: kColorAccent,
                                                                  radius: 5,
                                                                  textColor: Colors.white,
                                                                 title: FavProvider.productsId.contains(homeController.home.products![index].id)?"في السلة":"شراء",

                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: he * .08,
                                        ),
                                      ],
                                    ),
                                  ):
                                      SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: he * .04,),
                                            Container(
                                              decoration: const BoxDecoration(

                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey.withOpacity(0.3),
                                                //     spreadRadius: 3,
                                                //     blurRadius: 15,
                                                //     offset: Offset(0, 5), // changes position of shadow
                                                //   ),
                                                // ],
                                              ),
                                              child: CarouselSlider(
                                                options: CarouselOptions(
                                                    height: he * .21,
                                                    autoPlay: true,
                                                    onPageChanged: (index, reason) {

                                                      homeController.current = index;

                                                    }),
                                                items: [1, 2, 3, 4].map((element) {
                                                  return Builder(
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                          width: we * 0.9,
                                                          margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                          decoration: BoxDecoration(

                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.3),
                                                                spreadRadius: 3,
                                                                blurRadius: 15,
                                                                offset: Offset(0, 5), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                            child: Container(
                                                              // decoration: BoxDecoration(
                                                              //
                                                              //   boxShadow: [
                                                              //     BoxShadow(
                                                              //       color: Colors.grey.withOpacity(0.3),
                                                              //       spreadRadius: 3,
                                                              //       blurRadius: 15,
                                                              //       offset: Offset(0, 5), // changes position of shadow
                                                              //     ),
                                                              //   ],
                                                              // ),
                                                              child: SkeletonAvatar(
                                                                  style: SkeletonAvatarStyle(
                                                                      width: double
                                                                          .infinity,
                                                                      height: double
                                                                          .infinity)),
                                                            ),
                                                            // FadeInImage.assetNetwork(
                                                            //   placeholder: 'assets/images/loadd.gif',
                                                            //   image: element['image'].toString(),
                                                            //   fit: BoxFit.fill,
                                                            // ),
                                                          ));
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            SizedBox(height: he * .02,),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.center,
                                            //   children: List.generate(
                                            //     homeController.home.sliders?.length??0,
                                            //         (i) => buildDot(index: i),
                                            //   ),
                                            // ),
                                            SizedBox(height: he * .04,),
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    7),
                                                child: SkeletonAvatar(
                                                    style: SkeletonAvatarStyle(
                                                        width: we - 30,
                                                        height: he * .15))),
                                            SizedBox(height: he * .03,),
                                            // Text('تسوق بالاقسام',
                                            //   style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                                            // ),
                                            // SizedBox(height: he * .02,),
                                            ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: 5,
                                              itemBuilder: (ctx, index) =>
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8.0,
                                                        horizontal: 20),

                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(7),
                                                        child: SkeletonAvatar(
                                                            style: SkeletonAvatarStyle(
                                                                width: we - 30,
                                                                height: he *
                                                                    .16))),
                                                  ),
                                            ),
                                            SizedBox(height: he * .12,),
                                          ],
                                        ),
                                      )
                                      ),
                                  // SizedBox(height: he * .07,)
                                ],
                              ),
                              if (HomeProvider.show && !homeController.load)
                                InkWell(
                                  onTap: () {
                                  //  print(homeController.popup.departmentId);
                                    ProductsController.subCategoryID =homeController.popup.departmentId;
                                    if(ProductsController.subCategoryID!=null) {

                                      Navigator.of(
                                          context)
                                          .push(MaterialPageRoute(
                                          builder:
                                              (context) {
                                            return Products(
                                              company: homeController.popup
                                                  .companyId,
                                              subCategory: homeController.popup.departmentName,
                                            );
                                          })).then((value) => homeController. refresh());
                                  }},
                                  child: Container(
                                    height: he,
                                    width: we,
                                    color: Colors.black45,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: Image.network(
                                                  homeController.popup.photo!,
                                                  fit: BoxFit.fill,
                                                  width: we * .87,
                                                  height: he * .7,
                                                )),
                                            InkWell(
                                              onTap: () {
                                                homeController.closePopUp();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  Icons.close,
                                                  size: 20,
                                                ),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    })
                  : Container(
                      height: he,
                      width: we,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/net.gif"),
                          Text(
                            'لا يوجد اتصال بالانترنت',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    );
            },
            child: CircularProgressIndicator(),
          ),
        );}
     ),
    );
  }

  Widget homeTitle(String title,GestureTapCallback press,context){
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: he * .035,
              width: we*.012,
              decoration: BoxDecoration(
                //  color: dark,

                  borderRadius: BorderRadius.circular(15)
              ),
              child:  VerticalDivider(
                color: kColorAccent,
                width: we*.012,
                thickness: we*.012,
              ),),
            SizedBox(
              width: we * .017,
            ),
            Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                //   fontWeight: FontWeight.bold,
                fontSize: we * .05,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: press,
          child: Text(
            "عرض كل الاقسام ....",
            style: TextStyle(color: Colors.black, fontSize: we * .036),
          ),
        ),
      ],
    );
  }
}
