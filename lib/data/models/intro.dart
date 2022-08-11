

import 'dart:convert';

IntroModel introModelFromJson(String str) => IntroModel.fromJson(json.decode(str));


class IntroModel {
  IntroModel({
    this.data,
  });

  bool ?status;
  String? msg;
  List<Datum> ?data;

  factory IntroModel.fromJson(Map<String, dynamic> json) => IntroModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  Datum({
    this.homeId,
    this.name,
    this.photo,
  });

  int ?homeId;
  String ?name;
  String? photo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    homeId: json["id"],
    name: json["name"],
    photo: json["photo"],
  );

}
