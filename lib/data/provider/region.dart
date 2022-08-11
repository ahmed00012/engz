
import 'package:flutter/material.dart';
import 'package:engez/data/models/region.dart';
import 'package:engez/data/servicese/regions.dart';

class RegionProvider extends ChangeNotifier{
  RegionProvider(){
    getRegions();
  }
  RegionModel region = new RegionModel(data: []);


  void getRegions() {
    RegionService.instance
        .getRegion().then((newCities) {
      region = newCities!;
      notifyListeners();
    }
    );
  }
}