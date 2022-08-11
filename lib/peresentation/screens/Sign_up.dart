import 'dart:ui';

import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/provider/region.dart';
import 'package:engez/data/servicese/api_exeptions.dart';
import 'package:engez/data/servicese/auth.dart';
import 'package:engez/data/servicese/server_constants.dart';
import 'package:engez/peresentation/screens/login.dart';
import 'package:engez/peresentation/screens/terms.dart';
import 'package:engez/peresentation/widgets/helper.dart';
import 'package:engez/peresentation/widgets/loading.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  int? cityId;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  String? name, phone, address, storeName, password;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool acceptEULA = false;
  bool checkedValue = false;
  GoogleMapController? mapController;
  bool markerTapped = false;
  Marker? marker;
  double? lat;
  double? lng;
  Position? currentLocation;
  bool isPassword = true;

  getLocationStatus() async {
    var status = await Geolocator.isLocationServiceEnabled();
    if (status) {
      setState(() {
        // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
        getUserLocation();
      });
    } else {
      setState(() {
        //_showDialog(context);
      });
    }
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "الموقع",
            style: TextStyle(color: Colors.indigo),
          ),
          content: new Text(
              "لكى تتمكن من مشاهدة المطاعم بالقرب منك الرجاء تفعيل الموقع"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            InkWell(
            onTap: () {
          Navigator.of(context).pop();
          setActiveLocation();
        },
              child: new Container(
                  child: Center(
                    child: new Text(
                      "تفعيل",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: new Container(
                child: Center(
                  child: new Text(
                    "الغاء",
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),

              ),
            )
          ],
        );
      },
    );
  }

  setActiveLocation() async {
    var platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      AppSettings.openAppSettings();
    } else {
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch().then((value) => getUserLocation);
    }
  }

  getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition();
    currentLocation = await locateUser();
    setState(() {
      markerTapped = true;
      marker = createMarker(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      lat = currentLocation!.latitude;
      lng = currentLocation!.longitude;
    });
  }

  Future<Position> locateUser() {
    return Geolocator.getCurrentPosition();
  }

  Marker createMarker(double latitude, double longitude) {
    return Marker(
      draggable: true,
      markerId: MarkerId('Marker'),
      position: LatLng(latitude, longitude),
    );
  }
  String tokenFCM = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Geolocator.getCurrentPosition();
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        tokenFCM = value!;
      });
    });
    // marker =
    //     createMarker(currentLocation?.latitude??LocalStorage.getData(key: 'lat'),
    // currentLocation?.longitude??LocalStorage.getData(key: 'long'),);
    getUserLocation();
  }

  Future<void> _submit() async {
    _key.currentState?.validate();
    try {
      print('0000000000000000000000000000');
      if (_key.currentState!.validate()) {
        _key.currentState?.save();
        LoadingScreen.show(context);
        await AuthService.instance.signUp(
            name.toString(),
            phone.toString(),
            password.toString(),
            storeName.toString(),
            address.toString(),
            tokenFCM,
            cityId ?? 0,
            lat!,
            lng!);
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
      Navigator.of(context, rootNavigator: true).pop();
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

      Navigator.of(context, rootNavigator: true).pop();
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
              image: AssetImage(
                "assets/images/backkk.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, bottom: 16, top: 80),
              child: Form(
                key: _key,
                autovalidateMode: _validate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                          color: dark,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: validateName,
                        onSaved: (String? val) {
                          name = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'الاسم',
                            darkMode: isDarkMode(context),
                            errorColor: Theme.of(context).errorColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: validateMobile,
                        onSaved: (String? val) {
                          phone = val;
                        },
                        decoration: getInputDecoration(
                            hint: 'رقم التليفون',
                            darkMode: isDarkMode(context),
                            errorColor: Theme.of(context).errorColor),
                      ),
                    ),
                    ChangeNotifierProvider<RegionProvider>(
                        create: (context) => RegionProvider(),
                        child: Consumer<RegionProvider>(
                            builder: (buildContext, regions, _) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, right: 8.0, left: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    width: double.infinity,
                                    //  margin: EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Colors.grey.shade200)
                                        //   color: Colors.white,
                                        ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        hint: Row(
                                          children: [
                                            //   Icon(Icons.location_city,color: Colors.grey,),

                                            //   SizedBox(width: 10,),
                                            Text(
                                                regions.region.data!.length == 0
                                                    ? 'تحميل ....'
                                                    : 'اختار منطقتك',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        value: cityId,
                                        isDense: true,
                                        isExpanded: true,
                                        items: [
                                          for (int i = 0;
                                              i < regions.region.data!.length;
                                              i++)
                                            DropdownMenuItem(
                                                child: Row(
                                                  children: [
                                                    //    Icon(Icons.location_city,color: Colors.grey,),

                                                    //  SizedBox(width: 10,),
                                                    Text(regions
                                                        .region.data![i].name
                                                        .toString()),
                                                  ],
                                                ),
                                                value:
                                                    regions.region.data![i].id),
                                        ],
                                        onChanged: (newValue) {
                                          setState(() {
                                            //  FocusScope.of(context).requestFocus(new FocusNode());
                                            cityId = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ))),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        //  textCapitalization: TextCapitalization.words,
                        validator: validateStoreName,
                        onSaved: (String? val) {
                          storeName = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'اسم المحل/الصيدلية/الشركة',
                            darkMode: isDarkMode(context),
                            errorColor: Theme.of(context).errorColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,

                        //  textCapitalization: TextCapitalization.words,
                        validator: validateStoreAddress,
                        onSaved: (String? val) {
                          address = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'العنوان',
                            darkMode: isDarkMode(context),
                            errorColor: Theme.of(context).errorColor),
                      ),
                    ),
                    if (markerTapped == false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'جاري تحديد موقعك ...',
                            style:
                                TextStyle(color: kColorPrimary, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 300,
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer())),
                            onTap: (location) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {
                                marker = createMarker(
                                    location.latitude, location.longitude);
                                lat = location.latitude;
                                lng = location.longitude;
                              });
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  currentLocation?.latitude ??
                                      LocalStorage.getData(key: 'lat'),
                                  currentLocation?.longitude ??
                                      LocalStorage.getData(key: 'long')),
                              zoom: 14.0,
                            ),
                            markers: Set<Marker>.of(
                              <Marker>[marker!],
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                          ),
                        ),
                      ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextFormField(
                          obscureText: isPassword,
                          textInputAction: TextInputAction.next,
                          controller: _passwordController,
                          validator: validatePassword,
                          onSaved: (String? val) {
                            password = val;
                          },
                          style: const TextStyle(height: 0.8, fontSize: 18.0),
                          cursorColor: kColorPrimary,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            fillColor: Colors.white,
                            hintText: 'كلمة المرور',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                    color: kColorAccent, width: 2.0)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).errorColor),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                              icon: isPassword
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    ),
                              onPressed: () =>
                                  setState(() => isPassword = !isPassword),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).errorColor),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8),
                      child: CheckboxListTile(
                        title: GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  'اوافق علي ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const TermsScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'الشروط والاحكام',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )),
                              ],
                            )),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 40.0, left: 40.0, top: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: checkedValue ? kColorAccent : Colors.grey,
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(
                              color: checkedValue ? kColorAccent : Colors.grey,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (checkedValue) _submit();
                        },
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // onPressed: () => context.read<SignUpBloc>().add(
                        //   ValidateFieldsEvent(_key,
                        //       acceptEula: acceptEULA),
                        // ),
                      ),
                    ),
                    //const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, right: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => push(context, const LoginScreen()),
                          child: const Text(
                            'هل لديك حساب؟',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 50,)
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
