
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engez/data/provider/auth.dart';
import 'package:engez/peresentation/widgets/loading.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:provider/provider.dart';

import '../../constant.dart';
import 'new_password.dart';



class PinCode extends StatefulWidget {
  String? phone;
  String? fName;
  String? sName;
  String? password;
  bool? resetPassword;

  PinCode(
      {this.fName, this.sName, this.password, this.phone, this.resetPassword});

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  TextEditingController pin = TextEditingController();
  String? _verificationCode;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+20${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
void submit()async{
  if (pin.text != '') {
    print(pin.text);
    try {
      LoadingScreen.show(context);
      await FirebaseAuth.instance
          .signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: _verificationCode!,
              smsCode: pin.text))
          .then((value) async {
        if (value.user != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return ForgotPass();
          }));
        }
      });
    } catch (e) {
      FocusScope.of(context).unfocus();
     Navigator.pop(context);
      displayToastMessage('invalid otp');
    }
  }
}

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }
  void dispose() {
    pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(builder: (context, auth, child) {
        return SingleChildScrollView(
            child: Column(children: <Widget>[
          // Logo Image
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black45,
                            style: BorderStyle.solid,
                            width: 2),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black45,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 15,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('تفعيل الحساب',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 18,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          SizedBox(height: 50),

          Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/otp.gif')),
          SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  ' ادخل الكود المرسل على '+widget.phone! ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: myGrey),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),

          SizedBox(
            height: 50,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1.3,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: PinCodeTextField(
              appContext: context,
              controller: pin,
              pastedTextStyle: TextStyle(
                color: kColorPrimary,
              ),
              textStyle: TextStyle(color: kColorPrimary),
              length: 6,
              pinTheme: PinTheme(
                activeColor: kColorPrimary,
                selectedColor: kColorPrimary,
                inactiveColor: kColorPrimary,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 45,
                fieldWidth: 45,
              ),
              cursorColor: kColorPrimary,
              keyboardType: TextInputType.number,
              onChanged: (String value) {},
            ),
          ),

          SizedBox(
            height: 60,
          ),

          Container(
            margin: new EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 15,
                right: MediaQuery.of(context).size.width / 15),
            child: ButtonTheme(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              minWidth: 300.0,
              height: MediaQuery.of(context).size.width / 8,
              child: InkWell(
        onTap: () async {
        submit();
        },
                child: Container(
                    child: Center(
                      child: Text('تفعيل',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    color: kColorPrimary,
                   ),
              ),
            ),
          ),
        ]));
      }),
    ));
  }

  void displayToastMessage(String toastMessage) {
    showSimpleNotification(
      Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              toastMessage,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      duration: Duration(seconds: 2),
      background: kColorPrimary,
      position: NotificationPosition.top,
    );
  }
}
