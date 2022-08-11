
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/about.dart';
import 'package:engez/data/servicese/about.dart';
final aboutFuture =
ChangeNotifierProvider<AboutProvider>((ref) => AboutProvider());
class AboutProvider extends ChangeNotifier{
  AboutProvider(){
    getAbout();
  }

  AboutModel about = new AboutModel();
  bool isLoad = true;
  void getAbout(){
    AboutService.instance.getAbout().then((slide){
      about = slide!;
      isLoad = false;
      notifyListeners();
    }
    );
  }

}