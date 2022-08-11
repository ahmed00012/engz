//
// import 'package:baraka_app/models/intro.dart';
// import 'package:baraka_app/models/offer.dart';
// import 'package:baraka_app/servicese/intro.dart';
// import 'package:baraka_app/servicese/offers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// final offerFuture =
// ChangeNotifierProvider<OfferProvider>((ref) => OfferProvider());
// class OfferProvider extends ChangeNotifier{
//   OfferProvider(){
//     getOffer();
//   }
//
//   OfferModel offer = new OfferModel(data: []);
//   bool isLoad = true;
//   void getOffer(){
//     OfferService.instance.getOffers().then((slide){
//       offer = slide!;
//       isLoad = false;
//       notifyListeners();
//     }
//     );
//   }
//
// }