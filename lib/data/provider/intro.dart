
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/intro.dart';
import 'package:engez/data/servicese/intro.dart';
import 'package:introduction_screen/introduction_screen.dart';
final splashFuture =
ChangeNotifierProvider<SplashProvider>((ref) => SplashProvider());
class SplashProvider extends ChangeNotifier{
  SplashProvider(){
    getSlider();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      if(pageController.hasClients) {
        pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }
  final introKey = GlobalKey<IntroductionScreenState>();

  int currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  changePage(var value){
    currentPage = value;
    notifyListeners();
  }

  IntroModel slider = new IntroModel(data: []);
  void getSlider()async{
    ApiSplash.instance.getSlider().then((slide){
      slider = slide!;
      notifyListeners();
    }
    );
  }

}