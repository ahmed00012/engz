import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/screens/Sign_up.dart';
import 'package:engez/peresentation/screens/phone.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:engez/peresentation/widgets/loading.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phone, password;
  bool isPassword = true;
  String tokenFCM = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        tokenFCM = value!;
      });
    });
    // marker =
    //     createMarker(currentLocation?.latitude??LocalStorage.getData(key: 'lat'),
    // currentLocation?.longitude??LocalStorage.getData(key: 'long'),);
  }
  Future<void> _submitLogin() async {
    _key.currentState?.validate();
    try {
      print('0000000000000000000000000000');
      if (_key.currentState!.validate()) {

        _key.currentState?.save();
        LoadingScreen.show(context);
        await AuthService.instance.login(phone.toString(), password.toString(),tokenFCM);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BottomNavBar();
            },

          ),
        );

      }
    } on ApiException catch (_) {
      print('ApiException');
      Navigator.of(context ,  rootNavigator: true).pop();
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

      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
          child: Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return  BottomNavBar();
                              }
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10.0, right: 16.0, left: 16.0,bottom: 10),
                              color: kColorAccent,
                              width: MediaQuery.of(context).size.width * .28,
                              child: Text(
                              "تخطي",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 32.0, right: 16.0, left: 16.0),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              color: dark,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 24.0, left: 24.0),
                        child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            validator: validateMobile,
                            onSaved: (String? val) {
                              phone = val;
                            },
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kColorAccent,
                            decoration: getInputDecoration(
                              darkMode: false,
                                hint: 'موبايل',
                             //   darkMode: isDarkMode(context),
                                errorColor: Theme.of(context).errorColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 24.0, left: 24.0),
                        child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: isPassword,
                            validator: validatePassword,
                            onSaved: (String? val) {
                              password = val;
                            },
                            // onFieldSubmitted: (password) => context
                            //     .read<LoginBloc>()
                            //     .add(ValidateLoginFieldsEvent(_key)),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18.0),
                            cursorColor:kColorAccent,
                            decoration:InputDecoration(

                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              fillColor:  Colors.white,
                              hintText: 'كلمة المرور',

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(color: kColorAccent, width: 2.0)),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).errorColor),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              suffixIcon: IconButton(
                                icon: isPassword ?  Icon(Icons.visibility_off,color: Colors.grey,): Icon(Icons.visibility,color: Colors.grey,) ,
                                onPressed: () => setState(() => isPassword = !isPassword ),
                              ),

                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).errorColor),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                        ),
                      ),

                      /// forgot password text, navigates user to ResetPasswordScreen
                      /// and this is only visible when logging with email and password
                      Padding(
                        padding: const EdgeInsets.only(top: 16, right: 24),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                           onTap: () =>
                                 push(context, const PhoneForgotPass()),
                            child: const Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                  color: dark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            right: 40.0, left: 40.0, top: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: const BorderSide(
                                color: kColorAccent,
                              ),
                            ),
                            primary: kColorAccent,
                          ),
                          onPressed: () {_submitLogin(); },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                       //   onPressed: () => _submitLogin();
                          //     .read<LoginBloc>()
                          //     .add(ValidateLoginFieldsEvent(_key)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, right: 24),
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                             onTap: () =>
                            push(context, const SignUpScreen()),
                            child: const Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      // FutureBuilder<bool>(
                      //   future: apple.TheAppleSignIn.isAvailable(),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const CircularProgressIndicator.adaptive();
                      //     }
                      //     if (!snapshot.hasData || (snapshot.data != true)) {
                      //       return Container();
                      //     } else {
                      //       return Padding(
                      //         padding: const EdgeInsets.only(
                      //             right: 40.0, left: 40.0, bottom: 20),
                      //         child: apple.AppleSignInButton(
                      //             cornerRadius: 25.0,
                      //             type: apple.ButtonType.signIn,
                      //             style: isDarkMode(context)
                      //                 ? apple.ButtonStyle.white
                      //                 : apple.ButtonStyle.black,
                      //             onPressed: () {
                      //               context.read<LoadingCubit>().showLoading(
                      //                   context,
                      //                   'Logging in, Please wait...',
                      //                   false);
                      //               context.read<AuthenticationBloc>().add(
                      //                 LoginWithAppleEvent(),
                      //               );
                      //             }),
                      //       );
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
        ),
      )
    ); }

  }
