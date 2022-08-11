
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/screens/update_profile.dart';
import 'package:engez/peresentation/widgets/loading.dart';
import 'package:engez/peresentation/widgets/more_item.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../constant.dart';
import 'about.dart';
import 'login.dart';
import 'notification_screen.dart';
import 'on_boarding.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<void> _submit() async {
    try {

      LoadingScreen.show(context);
      await AuthService.instance.logOut();
      LocalStorage.removeData(key: 'token');
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => OnBoardingPage()));
      // helpNavigateTo(context, HomeScreen());
      //   }
    } on ApiException catch (_) {
      print('ApiException');
      Navigator.of(context).pop();
      ServerConstants.showDialog1(context, _.toString());
    } on DioError catch (e) {
      //<<<<< IN THIS LINE
      print(
          "e.response.statusCode    ////////////////////////////         DioError");
      if (e.response!.statusCode == 400) {
        print(e.response!.statusCode);
      } else {
        print(e.message);
        // print(e?.request);
      }
    } catch (e) {
      print('catch');
      print(e);

      Navigator.of(context).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }
  String ? name;
  String ? mobile;
  String ? token;

  @override
  void initState() {
    name = LocalStorage.getData(key: 'name');
    mobile = LocalStorage.getData(key: 'mobile');
    token = LocalStorage.getData(key: 'token');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/backkk.jpg",),
    fit: BoxFit.fill
    ),),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 // Image.asset('assets/images/logo.jpg',height: 100,width: 100,),
                  SizedBox(height: he*.02),
                  Text(
                    name??'مرحبا بك',
                    style: TextStyle(
                        fontSize: 22,
                        color: dark,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    mobile??'سجل دخولك لتتمكن من الشراء',
                    style: TextStyle(
                        fontSize: 18,
                        color: dark
                    ),
                  ),
                  SizedBox(height:  he*.05),
                  if(token != null)
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return  UpdateProfile();
                        }
                        ));
                      },
                      child: const ProfileListItem(
                        icon: FontAwesomeIcons.userEdit,
                        text: 'تعديل حسابك',
                      ),
                    ),
                  if(token != null)
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return  NotifyScreen();
                        }
                        ));
                      },
                      child: const ProfileListItem(
                        icon: Icons.notifications,
                        text: 'الاشعارات',
                      ),
                    ),
                  InkWell(
                    onTap: (){
                     launch("tel://+201559159909");

                    },
                    child: const ProfileListItem(
                      icon: Icons.call,
                      text: 'اتصل بنا',
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      var whatsapp ="+201559159909";
                      var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text= ";
                      await launch(whatsappURl_android);
                    },
                    child: const ProfileListItem(
                      icon:FontAwesomeIcons.whatsappSquare,
                      text: 'راسلنا',
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return  AboutScreen();
                      }
                      ));
                    },
                     child: ProfileListItem(
                      icon: FontAwesomeIcons.solidQuestionCircle,
                      text: 'حول التطبيق',
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      token==null?
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return  LoginScreen();
                      }
                      )):
                      _submit();
                    },
                    child: ProfileListItem(
                      icon:token ==null ? FontAwesomeIcons.signInAlt: FontAwesomeIcons.signOutAlt,
                      text: token==null? 'تسجيل دخول':'تسجيل خروج',
                      hasNavigation: false,
                    ),
                  ),
                 // SizedBox(height: token==null? he*.28:he*.01,),
                  Text("version 1.0",
                    style: TextStyle(
                        fontSize: 13,
                        color: kColorPrimary
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          String url = "https://icontds.com/";
                           launch(url);
                        },
                        child: Text('Icon Tech ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                              fontSize: 13,
                              color: kColorPrimary
                          ),),
                      ),
                      Text('Powered by',
                        style: TextStyle(
                            fontSize: 13,
                            color: kColorPrimary
                        ),),

                    ],
                  ),
                //  SizedBox(height:  he*.3,),

                ],
              ),
            ),
          ),
        ),
      ),
    );


  }
}
