// To parse this JSON data, do
//
//     final favModel = favModelFromJson(jsonString);

import 'dart:convert';

FavModel favModelFromJson(String str) => FavModel.fromJson(json.decode(str));

String favModelToJson(FavModel data) => json.encode(data.toJson());

class FavModel {
  FavModel({
    this.pagesTotal,
    this.currentPage,
    this.perPage,
    this.itemCount,
    required this.products,
  });

  int ?pagesTotal;
  int ?currentPage;
  int ?perPage;
  int ?itemCount;
  List<Product> products;

  factory FavModel.fromJson(Map<String, dynamic> json) => FavModel(
    pagesTotal: json["pages_total"],
    currentPage: json["current_page"],
    perPage: json["per_page"],
    itemCount: json["item_count"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages_total": pagesTotal,
    "current_page": currentPage,
    "per_page": perPage,
    "item_count": itemCount,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.type,
    this.oldPrice,
    this.pricePerUnit,
    this.sale,
    this.salePercentage,
    this.photo,
    this.minQty,
    this.departmentId,
    this.companyId,
    this.thumbnail,
    this.viewStatus,
    this.isFav,
    this.cartCount,
  });

  int? id;
  String? title;
  String ?description;
  int ?price;
  String? type;
  int ?oldPrice;
  int ?pricePerUnit;
  bool? sale;
  int ?salePercentage;
  String? photo;
  int ?minQty;
  int ?departmentId;
  int ?companyId;
  String ?thumbnail;
  int ?viewStatus;
  bool? isFav;
  int ?cartCount;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    type: json["type"],
    oldPrice: json["oldPrice"],
    pricePerUnit: json["pricePerUnit"],
    sale: json["sale"],
    salePercentage: json["salePercentage"] == null ? null : json["salePercentage"],
    photo: json["photo"],
    minQty: json["minQty"],
    departmentId: json["department_id"],
    companyId: json["company_id"],
    thumbnail: json["thumbnail"],
    viewStatus: json["view_status"],
    isFav: json["is_fav"],
    cartCount: json["cartCount"] == null ? null : json["cartCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "type": type,
    "oldPrice": oldPrice,
    "pricePerUnit": pricePerUnit,
    "sale": sale,
    "salePercentage": salePercentage == null ? null : salePercentage,
    "photo": photo,
    "minQty": minQty,
    "department_id": departmentId,
    "company_id": companyId,
    "thumbnail": thumbnail,
    "view_status": viewStatus,
    "is_fav": isFav,
    "cartCount": cartCount == null ? null : cartCount,
  };
}
