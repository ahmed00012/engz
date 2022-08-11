// To parse this JSON data, do
//
//     final termsModel = termsModelFromJson(jsonString);

import 'dart:convert';

TermsModel termsModelFromJson(String str) => TermsModel.fromJson(json.decode(str));


class TermsModel {
  TermsModel({
    this.data,
  });

  String ?data;

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
    data: json["data"],
  );

}
