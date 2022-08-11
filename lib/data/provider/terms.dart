


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/terms.dart';
import 'package:engez/data/servicese/auth.dart';
final termsFuture =
ChangeNotifierProvider<TermsProvider>((ref) => TermsProvider());
class TermsProvider extends ChangeNotifier{
  TermsProvider(){
    getTerms();
  }

  bool isLoad = true;
  TermsModel terms = new TermsModel();


  void getTerms() {
    AuthService.instance
        .terms().then((newCities) {
      terms = newCities!;
      isLoad = false;

      notifyListeners();
    }
    );

}}