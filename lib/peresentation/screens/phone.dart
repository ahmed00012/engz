
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/widgets/loading.dart';

import '../../constant.dart';
import 'otp.dart';



enum Gender {
  phone,
}
class PhoneForgotPass extends StatefulWidget {
  const PhoneForgotPass({Key? key}) : super(key: key);

  @override
  _PhoneForgotPassState createState() => _PhoneForgotPassState();
}

class _PhoneForgotPassState extends State<PhoneForgotPass> {
  Gender? selected;


  final phoneController = TextEditingController();
  FocusNode phoneFocusNode = new FocusNode();
  bool isSubmitted = false;
  String phone = '';
  String? get _phoneErrorText {
    if (phone.isEmpty) {
      return  'من فضلك ادخل رقم الموبايل';
    }
    if (phone.length != 11) {
      return 'رقم الموبايل يجب الا يقل عن 11 رقم';
    }
    // return null if the text is valid
    return null;
  }
  Future<void> _submit() async {
    setState(() {
      isSubmitted = true;
    });
    try {
      print('0000000000000000000000000000');
      if ( _phoneErrorText == null ) {

        LoadingScreen.show(context);
        await AuthService.instance.sendPhone(phone);
        Navigator.of(context).popUntil((route) => route.isFirst);

        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  PinCode(phone: phone,)));
        // helpNavigateTo(context, HomeScreen());
      }
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

      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }
  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: he * 0.05,
            ),
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
            SizedBox(
              height: he * 0.03,
            ),
        Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text( 'ادخل رقم الموبايل',style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 2
                ),
                ),
              ),

          Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text( "استعادة كلمة المرور",style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1),
                ),

              ),

            SizedBox(
                height: he * 0.07
            ),
            Container(
                // width: we * 0.9,
                // height:he * 0.071,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20.0),
                //   color: selected == Gender.phone ?  enabled : backgroundColor,
                // ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:  TextField(
                  keyboardType: TextInputType.number,
                  focusNode: phoneFocusNode,
                  controller: phoneController,
                  onChanged: (text) => setState(() =>  phone = text),
                  onTap: (){
                    setState(() {
                      selected = Gender.phone;
                    });
                  },
                  decoration: InputDecoration(
                    errorText:  isSubmitted? _phoneErrorText: null,
                    errorBorder:isSubmitted? null : !phoneFocusNode.hasFocus ?  const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ):  UnderlineInputBorder(
                      borderSide:  BorderSide(color: enabled,),
                    ),
                    errorStyle: isSubmitted? null :!phoneFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : TextStyle(color: enabled),
                    border: const OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(7))),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(
                          color:  selected == Gender.phone ? enabled:Colors.grey, width: 1.0),
                    ),
                    prefixIcon: Icon(Icons.phone_android_outlined,color: selected == Gender.phone ? kColorAccent : deaible,),
                    label:  Text('رقم الموبايل'),
                    hintText: 'رقم الموبايل',
                    helperStyle: TextStyle(color: deaible,),
                    labelStyle: TextStyle(
                      color:  selected == Gender.phone ? kColorAccent : deaible,
                    ),
                  ),
                  style:  TextStyle(color:  selected == Gender.phone ? kColorAccent : deaible,fontWeight:FontWeight.bold),
                ),
              ),

            SizedBox(
              height: he * 0.04,
            ),
              Center(
                child: TextButton.icon(
                    icon: Icon(Icons.send,color: Colors.white,),
                    onPressed: (){
                      _submit();
                    },
                    label: Text( 'ارسال',style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    style:  TextButton.styleFrom(
                        backgroundColor:  kColorPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0)
                        )
                    )
                ),
              ),



          ],
        ),
      ),
    );
  }
}
