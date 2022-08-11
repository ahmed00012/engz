
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/provider/region.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/widgets/loading.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

enum Gender{
  fullname,
  store_name,
  store_address,
  password,
  region,
  phone
}
class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  int ? cityId;
  bool ispasswordev = true;
  Gender? selected;
  bool isSubmitted = false;
  bool checkedValue = false;
  int ? terms;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final store_nameController = TextEditingController();
  final store_addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    phoneController.dispose();
    store_addressController.dispose();
    store_nameController.dispose();
    super.dispose();
  }
  FocusNode nameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode passFocusNode = new FocusNode();
  FocusNode store_nameFocusNode = new FocusNode();
  FocusNode store_addresspassFocusNode = new FocusNode();
  String name = '';
  String phone = '';
  String password = '';
  String store_address= '';
  String store_name ='';
  String? get _nameErrorText {
    // at any time, we can get the text from _controller.value.text
    //  final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (name.isEmpty) {
      return  'من فضلك ادخل اسمك';
    }
    if (name.length < 4) {
      return  "الاسم قصير جدا";
    }
    // return null if the text is valid
    return null;
  }
  String? get _passErrorText {
    if (password.isEmpty) {
      return  'من فضلك ادخل كلمة المرور';
    }
    if (password.length < 6) {
      return  "كلمة المرور قصيرة جدا";
    }
    // return null if the text is valid
    return null;
  }
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
  String? get _store_nameErrorText {
    if (store_name.isEmpty) {
      return  'من فضلك ادخل اسم المحل ';
    }
    // return null if the text is valid
    return null;
  }
  String? get _store_addressErrorText {
    if (store_name.isEmpty) {
      return  'من فضلك ادخل عنوان المحل ';
    }
    // return null if the text is valid
    return null;
  }
  Future<void> _submit() async {
    setState(() {
      isSubmitted = true;
    });
    try {
      if (_nameErrorText == null && _phoneErrorText == null  && _store_addressErrorText==null && _store_nameErrorText == null) {
        if(cityId == null)
          displayToastMessage('يلزم اختيار منطقة');
        _formKey.currentState?.save();

        if(cityId != null){
          LoadingScreen.show(context);
          if(checkedValue == true)
            terms =1;
          else
            terms = 0;
          await AuthService.instance.updateProfile(
            phone.toString(),
            name.toString(),
            store_name,
            store_address,
            cityId!,);
          displayToastMessage('تم التعديل بنجاح');
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new BottomNavBar()));
        }}
    } on ApiException catch (_) {
      print('ApiException');
      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, _.toString());
    } on DioError catch (e) {
      //<<<<< IN THIS LINE
      print(
          "e.response.statusCode    ////////////////////////////         DioError");
      if (e.response?.statusCode == 400) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        // print(e?.request);
      }
      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, e.toString());
    } catch (e) {
      print('catch');
      print(e);

      Navigator.of(context,  rootNavigator: true).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }
  GlobalKey<FormState> _formKey = GlobalKey();


  @override
  void initState() {
    name = LocalStorage.getData(key: 'name');
    phone = LocalStorage.getData(key: 'mobile');
    store_address = LocalStorage.getData(key: 'shop_address');
    store_name = LocalStorage.getData(key: 'shop_name');
    cityId = LocalStorage.getData(key: 'city_id');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar:  AppBar(
        backgroundColor: dark,
        title: Text('تعديل الحساب',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: he * 0.07,
                ),
           Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('تعديل بياناتك',style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        letterSpacing: 2
                    ),
                    ),
                  ),

                SizedBox(
                    height: he * 0.05
                ),
              Container(
                    // width: we * 0.9,
                    // height:he * 0.071,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20.0),
                    //   color: selected == Gender.fullname ?  enabled : backgroundColor,
                    // ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child:  TextFormField(
                      initialValue: name,
                      focusNode: nameFocusNode,
                      //controller: nameController,
                      onChanged: (text) => setState(() =>  name = text),
                      onTap: (){
                        setState(() {
                          selected = Gender.fullname;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: isSubmitted?_nameErrorText: null,
                        errorBorder: isSubmitted? null :!nameFocusNode.hasFocus ?  UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ): null,
                        errorStyle:isSubmitted? null : !nameFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : null,
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  selected == Gender.fullname ? enabled:Colors.grey, width: 1.0),
                        ),

                        prefixIcon: Icon(Icons.person_outlined,color: selected == Gender.fullname ? kColorAccent : deaible,),
                        label:  Text("الاسم"),
                        labelStyle: TextStyle(
                          color:  selected == Gender.fullname ? kColorAccent : deaible,
                        ),
                      ),
                      style:  TextStyle(color:  selected == Gender.fullname ? kColorAccent : deaible,fontWeight:FontWeight.bold),
                    ),
                  ),


                SizedBox(
                  height: he * 0.02,
                ),
              Container(

                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:  TextFormField(
                      initialValue: phone,
                      keyboardType: TextInputType.number,
                      focusNode: phoneFocusNode,
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
                  height: he * 0.02,
                ),
       ChangeNotifierProvider<RegionProvider>(
                      create: (context) => RegionProvider(),
                      child: Consumer<RegionProvider>(
                          builder: (buildContext, regions, _) =>
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                                padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)
                                  //   color: Colors.white,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    hint:  Row(
                                      children: [
                                        Icon(Icons.location_city,color: Colors.grey,),

                                        SizedBox(width: 10,),
                                        Text(regions.region.data!.length ==0?
                                        'تحميل ....':
                                        'اختار منطقتك',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    value: cityId,
                                    isDense: true,
                                    isExpanded: true,
                                    items: [
                                      for(int i =0 ;i < regions.region.data!.length; i++)
                                        DropdownMenuItem(
                                            child: Row(

                                              children: [
                                                Icon(Icons.location_city,color: Colors.grey,),

                                                SizedBox(width: 10,),
                                                Text(regions.region.data![i].name.toString()),
                                              ],
                                            ), value:regions.region.data![i].id),
                                    ],
                                    onChanged: (newValue) {
                                      setState(() {
                                        //  FocusScope.of(context).requestFocus(new FocusNode());
                                        cityId = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ))),

                SizedBox(
                  height: he * 0.02,
                ),
          Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child:  TextFormField(
                      initialValue: store_name,
                      focusNode: store_nameFocusNode,
                     // controller: store_nameController,
                      onChanged: (text) => setState(() =>  store_name = text),
                      onTap: (){
                        setState(() {
                          selected = Gender.store_name;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: isSubmitted?_store_nameErrorText: null,
                        errorBorder: isSubmitted? null :!store_nameFocusNode.hasFocus ?  UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ): null,
                        errorStyle:isSubmitted? null : !store_nameFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : null,
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  selected == Gender.store_name ? enabled:Colors.grey, width: 1.0),
                        ),

                        prefixIcon: Icon(Icons.store,color: selected == Gender.store_name ? kColorAccent : deaible,),
                        label:  Text("اسم المحل"),
                        labelStyle: TextStyle(
                          color:  selected == Gender.store_name ? kColorAccent : deaible,
                        ),
                      ),
                      style:  TextStyle(color:  selected == Gender.store_name ? kColorAccent : deaible,fontWeight:FontWeight.bold),
                    ),
                  ),


                SizedBox(
                  height: he * 0.02,
                ),
           Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child:  TextFormField(
                      initialValue: store_address,
                      focusNode: store_addresspassFocusNode,
                     // controller: store_addressController,
                      onChanged: (text) => setState(() =>  store_address = text),
                      onTap: (){
                        setState(() {
                          selected = Gender.store_address;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: isSubmitted?_store_addressErrorText: null,
                        errorBorder: isSubmitted? null :!store_addresspassFocusNode.hasFocus ?  UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ): null,
                        errorStyle:isSubmitted? null : !store_addresspassFocusNode.hasFocus ? TextStyle(fontSize: 0, height: 0) : null,
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  selected == Gender.store_address ? enabled:Colors.grey, width: 1.0),
                        ),

                        prefixIcon: Icon(Icons.store_mall_directory,color: selected == Gender.store_address ? kColorAccent : deaible,),
                        label:  Text("عنوان المحل"),
                        labelStyle: TextStyle(
                          color:  selected == Gender.store_address ? kColorAccent : deaible,
                        ),
                      ),
                      style:  TextStyle(color:  selected == Gender.store_address ? kColorAccent : deaible,fontWeight:FontWeight.bold),
                    ),
                  ),


                SizedBox(
                  height: he * 0.05,
                ),

             Center(
                    child: TextButton(

                        child: Text( "ارسال",style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),),
                        style:  TextButton.styleFrom(
                            backgroundColor:  dark,
                            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)
                            )
                        ), onPressed: () {_submit();  },
                    ),
                  ),

                SizedBox(
                    height: he * 0.08
                ),

              ],
            ),
          ),
        ),
      ),
    );
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
