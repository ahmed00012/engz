
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:engez/data/provider/Notify_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';
import 'notify_details.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key}) : super(key: key);

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  String  ?token ='';
  void getToken ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    setState(() {

    });
  }
  bool ?status = true;


  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return
    Scaffold(
      backgroundColor: Color(0xfff4f5fb),
        appBar: AppBar(
          backgroundColor: dark,
          title: Text("الاشعارات",
            style: TextStyle(color: Colors.white, fontSize: size.height * 0.02),
          ),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),

        ),
      body:
      ChangeNotifierProvider<NotifyProvider>(
          create: (context) => NotifyProvider(),
          child: Consumer<NotifyProvider>(
            builder: (buildContext, notifyProvider, _) =>
            // favProvider.isLoud == true?

            SmartRefresher(
              controller: notifyProvider.controller,
              onLoading: () {
                print(
                    "-------------------------object--------------------------------");
                notifyProvider.onRefresh();

              },
              enablePullUp: true,
              enablePullDown: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    notifyProvider.isLoud == false?
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 3,
                        itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              height: 210,
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: SkeletonItem(
                                child: Card(
                                  elevation: .2,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11)),
                                  child: SkeletonItem(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            // height: 120,
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                              ),
                            ))):
                    notifyProvider.notify.data.length !=0?
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: notifyProvider.notify.data.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>NotificationDetails(notification: notifyProvider.notify.data[index],)));
                          },
                          child: Container(
                            height: 190,
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Card(
                              elevation: .2,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              child: SizedBox(
                                width: double.infinity,
                                // height: 120,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(11.0),
                                          topLeft: Radius.circular(11.0),
                                        ),
                                        child: Image.network(
                                          notifyProvider.notify.data[index].photo.toString(),
                                          fit: BoxFit.cover,
                                          height: 190,
                                          width: double.infinity,
                                        )),
                                    Container(
                                      width: double.infinity,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFF000000)
                                                .withOpacity(0.0),
                                            const Color(0xFF000000)
                                                .withOpacity(.7),
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(11.0),
                                          topLeft: Radius.circular(11.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 130.0),
                                      child: Center(
                                        child: Text(
                                          notifyProvider.notify.data[index].title.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )):
                    Container(
                      height: MediaQuery.of(context).size.height,
                      //width: MediaQuery.of(context).size.width,
                      color: Colors.white ,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/noti.gif",height: size.height *.3,),
                            Text("لا يوجد اشعارات", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //helpLoading()
          )
      )
    );
  }
}
