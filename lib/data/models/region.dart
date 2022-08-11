// To parse this JSON data, do
//
//     final regionModel = regionModelFromJson(jsonString);

import 'dart:convert';

RegionModel regionModelFromJson(String str) => RegionModel.fromJson(json.decode(str));


class RegionModel {
  RegionModel({
    this.data,
  });

  List<Datum>? data;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

}

class Datum {
  Datum({
    this.id,
    this.name,
    this.minOrder,
  });

  int? id;
  String ?name;
  String ?minOrder;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    minOrder: json["min_order"],
  );

}
