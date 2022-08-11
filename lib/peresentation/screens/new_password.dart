
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/widgets/loading.dart';

import 'login.dart';



enum Gender {
  password,
  passConfirm
}

class ForgotPass extends StatefulWidget {


  const ForgotPass({Key? key,}) : super(key: key);
  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  bool ispasswordev = true;
  bool ispasswordevCon = true;
  Gender? selected;


  final passConfirmController = TextEditingController();
  final passController = TextEditingController();

  String ? token;


  @override
  void dispose() {
    passController.dispose();
    passConfirmController.dispose();
    super.dispose();
  }
  FocusNode passConFocusNode = new FocusNode();
  FocusNode passFocusNode = new FocusNode();


  String password = '';
  String conPass = '';
  String? get _passErrorText {
    if (password.isEmpty) {
      return 'من فضلك ادخل كلمة المرور';
    }
    if (password.length < 6) {
      return 'كلمة المرور ضعيفة';
    }
    // return null if the text is valid
    return null;
  }
  String? get _passConfirmErrorText {
    if (conPass.isEmpty) {
      return 'تأكيد كلمة المرور';
    }
    if(conPass != password){
      return "كلمة المرور غير متطابقة";
    }
    // return null if the text is valid
    return null;
  }

  bool isSubmitted = false;
  bool passSubmit = false;
  int ? id;


  @override
  void initState() {
    token = LocalStorage.getData(key: 'code');

    super.initState();

  }
  bool showPassword = true;
  bool showPassCon = true;
  Future<void> _submit() async {
    print(token);
    setState(() {
      isSubmitted = true;
    });
    try {
      if ( _passConfirmErrorText == null && _passErrorText == null) {

        LoadingScreen.show(context);
        await AuthService.instance.forgotPass( password,conPass, token!);
        Navigator.of(context).popUntil((route) => route.isFirst);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  LoginScreen()));
        });

      }
    } on ApiException catch (_) {
      print('ApiException');
      Navigator.of(context).pop();
      ServerConstants.showDialog1(context, _.toString());
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        print(e.response!.statusCode);
      } else {
        print(e.message);
      }
    } catch (e) {
      print('catch');
      print(e);

      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: he * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          // alignment: Alignment.topLeft,
                          margin: EdgeInsets.symmetric(horizontal: we * 0.04),
                          child: const Icon(Icons.arrow_back_outlined,color: Colors.black,size: 35.0,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                       "استعادة كلمة المرور",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            letterSpacing: 2),
                      ),
                    ),

                  SizedBox(
                    height: he * 0.01,
                  ),
 Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'ادخل كلمة المرور الجديدة',
                        style: TextStyle(
                            color: Colors.grey, letterSpacing: 0.5),
                      ),
                    ),

                  SizedBox(
                    height: he * 0.06,
                  ),
               Container(

                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        focusNode: passFocusNode,
                        //  controller: passController,
                        onChanged: (text) => setState(() =>  password = text),
                        onTap: () {
                          setState(() {
                            selected = Gender.password;
                          });
                        },
                        decoration: InputDecoration(
                          errorText: isSubmitted ? _passErrorText: null,
                          errorBorder:isSubmitted? null :   OutlineInputBorder(
                            borderSide:    BorderSide(
                                color: Colors.white,
                                width: 1.0),
                          ),
                          errorStyle:isSubmitted? null : !passFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : null,
                          prefixIcon: Icon(
                            Icons.lock_open_outlined,
                            color: selected == Gender.password
                                ? kColorAccent
                                : deaible,
                          ),
                          suffixIcon: IconButton(
                            icon: ispasswordev
                                ? Icon(
                              Icons.visibility_off,
                              color: selected == Gender.password
                                  ? kColorAccent
                                  : deaible,
                            )
                                : Icon(
                              Icons.visibility,
                              color: selected == Gender.password
                                  ? kColorAccent
                                  : deaible,
                            ),
                            onPressed: () =>
                                setState(() => ispasswordev = !ispasswordev),
                          ),
                          label:  Text("كلمة المرور"),
                          labelStyle: TextStyle(color: deaible,fontFamily: 'Tajawal'),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: passFocusNode.hasFocus
                                    ? enabled
                                    : Colors.grey,
                                width: 1.0),
                          ),
                        ),
                        obscureText: ispasswordev,
                        style: TextStyle(
                            color: selected == Gender.password
                                ? kColorAccent
                                : deaible,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                  SizedBox(
                    height: he * 0.02,
                  ),
         Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        focusNode: passConFocusNode,
                        //  controller: passController,
                        onChanged: (text) => setState(() =>  conPass = text),
                        onTap: () {
                          setState(() {
                            selected = Gender.passConfirm;
                          });
                        },
                        decoration: InputDecoration(
                          errorText: isSubmitted ? _passConfirmErrorText: null,
                          errorBorder:isSubmitted? null :   OutlineInputBorder(
                            borderSide:    BorderSide(
                                color: Colors.white,
                                width: 1.0),
                          ),
                          errorStyle:isSubmitted? null : !passConFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : null,
                          prefixIcon: Icon(
                            Icons.lock_open_outlined,
                            color: selected == Gender.passConfirm
                                ? kColorAccent
                                : deaible,
                          ),
                          suffixIcon: IconButton(
                            icon: ispasswordevCon
                                ? Icon(
                              Icons.visibility_off,
                              color: selected == Gender.passConfirm
                                  ? kColorAccent
                                  : deaible,
                            )
                                : Icon(
                              Icons.visibility,
                              color: selected == Gender.passConfirm
                                  ? kColorAccent
                                  : deaible,
                            ),
                            onPressed: () =>
                                setState(() => ispasswordevCon = !ispasswordevCon),
                          ),
                          label:  Text("تأكيد كلمة المرور"),
                          labelStyle: TextStyle(color: selected == Gender.passConfirm ? kColorAccent : deaible),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: passConFocusNode.hasFocus
                                    ? enabled
                                    : Colors.grey,
                                width: 1.0),
                          ),
                        ),
                        obscureText: ispasswordevCon,
                        style: TextStyle(
                            color: selected == Gender.passConfirm
                                ? kColorAccent
                                : deaible,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                  SizedBox(height: 35),
                Center(
                      child: TextButton.icon(
                          icon: Icon(Icons.send,color: Colors.white,),
                          onPressed: () {
                            _submit();
                          },
                          label: Text(
                           "إرسال",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: kColorPrimary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 80),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0)))),
                    ),

                ],
              ),
            ),
          )

      ),
    );
  }

}
