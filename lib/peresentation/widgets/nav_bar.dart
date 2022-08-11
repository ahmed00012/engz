
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:engez/data/provider/orders.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/peresentation/screens/cart.dart';
import 'package:engez/peresentation/screens/favorite.dart';
import 'package:engez/peresentation/screens/home.dart';
import 'package:engez/peresentation/screens/more.dart';
import 'package:engez/peresentation/screens/notification_screen.dart';
import 'package:engez/peresentation/screens/orders.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:overlay_support/overlay_support.dart';


import '../../constant.dart';

class BottomNavBar extends StatefulWidget {
  int? index;
  BottomNavBar({this.index});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
{
  // late AnimationController _animationController;
  // Animation<double>? animation;
  //  late CurvedAnimation curve;
  // PageController _pageController = PageController(initialPage: 0);
  int? currentTab =2;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  bool isLogin = false;


  final List<IconData> iconList = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.solidHeart,
    // Icons.bookmark_border,
    FontAwesomeIcons.userCog,
  ];

  final iconTitlesAR = <String>[
    'الرئيسية',
    'المفضلة',
    'الاعدادات',
  ];

bool d = false;

  DateTime? currentBackPressTime;
static  int count =0;
  List<Widget> _screens = [
    MoreScreen(),
    OrdersScreen(status: 0,state: 0,),
    HomeScreen(count: count+1,fromNav:count > 1? false : true,),
    CartScreen(fromNav: true,),
    Favorite(),


  ];

  @override
  void initState() {
    count++;
    if(widget.index==null)
      currentTab = 2;
    else
      currentTab = widget.index;
   fcmNotification();
    super.initState();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
OrdersProvider? order ;
  fcmNotification() async {
    //   if(status == true) {
 //   print(status);
    //FCM
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print('djjdjdjj');
    });

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                notification.title!,
                notification.body!,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        print(message.data['status'].toString()+"kjjjjjjjjjjj");
        if (message.data['status'].toString() == "0") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NotifyScreen()));
              },
              child: Container(
                height: 65,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background: Color(0xff20bf55)
          );
        } else if (message.data['status'].toString() == "2") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                OrdersProvider.statusId=2;
                order?.switchCompany(1);
                // OrdersProvider.status.forEach((element) {
                //   element["chosen"] = false;
                // });
                OrdersProvider.statusId =2;

                push(context, OrdersScreen(status: 1,));
            //    NavBar.myPage!.jumpToPage(17);
              },
              child: Container(
                height: 65,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background:Color(0xff20bf55),
          );
        } else if (message.data['status'].toString() == "3") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                OrdersProvider.statusId=3;
                order?.switchCompany(2);
                OrdersProvider.statusId =3;

                push(context, OrdersScreen(status: 2,));

                //    NavBar.myPage!.jumpToPage(16);
              },
              child: Container(
                height: 65,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background: Color(0xff20bf55),
          );
        } else if (message.data['status'].toString() == "4") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                OrdersProvider.statusId=4;
                order?.switchCompany(3);
                OrdersProvider.statusId =4;

                push(context, OrdersScreen(status: 3,));
              //  NavBar.myPage!.jumpToPage(1);
              },
              child: Container(
                height: 65,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background:Color(0xff20bf55),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['status'].toString() == "0") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => NotifyScreen()));
       // NavBar.myPage!.jumpToPage(6);
      } else if (message.data['status'].toString() == "3") {
        OrdersProvider.statusId=3;
        order?.switchCompany(2);
        OrdersProvider.statusId =3;

        push(context, OrdersScreen(status: 2,));
      } else if (message.data['status'].toString() == "2") {
        OrdersProvider.statusId=2;
        order?.switchCompany(1);
        OrdersProvider.statusId =2;

        push(context, OrdersScreen(status: 1,));
        // NavBar.myPage!.jumpToPage(16);
      } else if (message.data['status'].toString() == "4") {
        OrdersProvider.statusId=4;
        order?.switchCompany(3);
        OrdersProvider.statusId =4;

        push(context, OrdersScreen(status: 3,));
      }
    });
    //  }
  }

  Future<bool> onWillPop() {
    if(currentTab!=2) {
      setState(() {
        currentTab = 2;
      });
      return Future.value(false);
    } else
    {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Double Tap To Exit');
        return Future.value(false);
      } else
        exit(0);
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            _screens[currentTab!],
            Align(
              alignment: Alignment.bottomCenter,
              child: CurvedNavigationBar(
                index: currentTab!,
                height: 70,
                color: Colors.white,
                buttonBackgroundColor: dark,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    currentTab = index;
                  });
                  //  print(provider.currentIndex.toString()+'dkfbdifudbfiub');
                },

                items:  <Widget>[
                  currentTab == 0?
                  Icon(
                      Icons.segment,
                      size: 35,
                      color: Colors.white
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.segment,
                          size: 30,
                          color: Color(0xffB6B7B7),
                        ),
                        Text("المزيد", style: TextStyle(fontSize: 12, color: Colors.grey),)
                      ],
                    ),
                  ),

                  currentTab == 1?
                  Icon(
                      Icons.bookmark_border,
                      size: 35,
                      color: Colors.white
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 30,
                          color: Color(0xffB6B7B7),
                        ),
                        Text("طلباتي", style: TextStyle(fontSize: 12, color: Colors.grey),)
                      ],
                    ),
                  ),

                  currentTab == 2?
                  Icon(
                      Icons.home,
                      size: 35,
                      color: Colors.white
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 30,
                          color: Color(0xffB6B7B7),
                        ),
                        Text("الرئيسية", style: TextStyle(fontSize: 12, color: Colors.grey),)
                      ],
                    ),
                  ),

                  currentTab == 3?
                  Icon(
                      Icons. shopping_cart_rounded,
                      size: 35,
                      color: Colors.white
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Center(
                                child: Text(
                                  ProductsController.counter.toString(),
                                  style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          size:25,
                          color: Color(0xffB6B7B7),
                        ),
                        Text("السلة", style: TextStyle(fontSize: 12, color: Colors.grey),)
                      ],
                    ),
                  ),

                  currentTab == 4?
                  Icon(
                      Icons.favorite_border,
                      size: 35,
                      color: Colors.white
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 30,
                          color: Color(0xffB6B7B7),
                        ),
                        Text("المفضلة", style: TextStyle(fontSize: 12, color: Colors.grey),)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }





}
