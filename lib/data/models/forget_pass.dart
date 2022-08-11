
import 'dart:convert';

PassCodeModel passCodeModelFromJson(String str) => PassCodeModel.fromJson(json.decode(str));

class PassCodeModel {
  PassCodeModel({
    this.data,
  });


  String ?data;

  factory PassCodeModel.fromJson(Map<String, dynamic> json) => PassCodeModel(
    data: json["data"],
  );
}
