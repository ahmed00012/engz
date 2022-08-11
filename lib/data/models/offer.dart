
import 'dart:convert';

OfferModel offerModelFromJson(String str) => OfferModel.fromJson(json.decode(str));


class OfferModel {
  OfferModel({
    this.title,
    this.data,
  });

  String? title;
  List<Datum>? data;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    title: json["title"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

}

class Datum {
  Datum({
    this.id,
    this.offerId,
    this.content,
  });

  int? id;
  int ?offerId;
  String ?content;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    offerId: json["offer_id"],
    content: json["content"],
  );

}
