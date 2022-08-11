// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    this.status,
    this.msg,
    this.countUserCart,
    this.minOrder,
    this.department,
    this.sliders,
    this.products,
    this.offer,
    this.popup,
  });

  bool ?status;
  String? msg;
  int ?countUserCart;
  dynamic minOrder;
  List<Department> ?department;
  List<Slider> ?sliders;
  List<Product>? products;
  Offer ?offer;
  Popup? popup;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json["status"],
    msg: json["msg"],
    countUserCart: json["CountUserCart"],
    minOrder: json["minOrder"],
    department: List<Department>.from(json["department"].map((x) => Department.fromJson(x))),
    sliders: List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    offer: Offer.fromJson(json["offer"]),
    popup: Popup.fromJson(json["popup"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "CountUserCart": countUserCart,
    "minOrder": minOrder,
    "department": List<dynamic>.from(department!.map((x) => x.toJson())),
    "sliders": List<dynamic>.from(sliders!.map((x) => x.toJson())),
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "offer": offer!.toJson(),
    "popup": popup!.toJson(),
  };
}

class Department {
  Department({
    this.id,
    this.photo,
    this.name,
  });

  int ?id;
  String? photo;
  String? name;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    photo: json["photo"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "name": name,
  };
}

class Offer {
  Offer({
    this.photo,
  });

  String ?photo;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
  };
}

class Popup {
  Popup({
    this.photo,
    this.departmentId,
    this.companyId,
    this.departmentName
  });

  String ?photo;
  int ?companyId;
  int ?departmentId;
  String ?departmentName;

  factory Popup.fromJson(Map<String, dynamic> json) => Popup(
    photo: json["photo"],
    companyId: json["company_id"],
    departmentName: json["department_name"],
      departmentId: json["department_id"]
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
    "company_id": companyId,
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
  });

  int ?id;
  String ?title;
  String? description;
  int? price;
  int? type;
  int ?oldPrice;
  int ?pricePerUnit;
  bool ?sale;
  int ?salePercentage;
  String ?photo;
  int? minQty;
  int? departmentId;
  int ?companyId;
  String ?thumbnail;
  int ?viewStatus;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    type: json["type"],
    oldPrice: json["oldPrice"],
    pricePerUnit: json["pricePerUnit"],
    sale: json["sale"],
    salePercentage: json["salePercentage"],
    photo: json["photo"],
    minQty: json["minQty"],
    departmentId: json["department_id"],
    companyId: json["company_id"],
    thumbnail: json["thumbnail"],
    viewStatus: json["view_status"],
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
    "salePercentage": salePercentage,
    "photo": photo,
    "minQty": minQty,
    "department_id": departmentId,
    "company_id": companyId,
    "thumbnail": thumbnail,
    "view_status": viewStatus,
  };
}

class Slider {
  Slider({
    this.photo,
    this.companyId,
    this.departmentId,
    this.departmentName,
  });

  String? photo;
  int ?companyId;
  int ?departmentId;
  String? departmentName;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    photo: json["photo"],
    companyId: json["company_id"],
    departmentId: json["department_id"],
    departmentName: json["department_name"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
    "company_id": companyId,
    "department_id": departmentId,
    "department_name": departmentName,
  };
}
