// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String? msg;
  Data ?data;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int ?currentPage;
  List<Details> data;
  String ?firstPageUrl;
  int ?from;
  int ?lastPage;
  String ?lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String ?path;
  int ?perPage;
  dynamic prevPageUrl;
  int ?to;
  int ?total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<Details>.from(json["data"].map((x) => Details.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Details {
  Details({
    this.id,
    this.uuid,
    this.createdAt,
    this.cartId,
    this.statusId,
    this.cart,
  });

  int? id;
  String? uuid;
  String ?createdAt;
  int ?cartId;
  int ?statusId;
  Cart ?cart;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["id"],
    uuid: json["uuid"],
    createdAt: json["created_at"],
    cartId: json["cart_id"],
    statusId: json["status_id"],
    cart: Cart.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "created_at": createdAt,
    "cart_id": cartId,
    "status_id": statusId,
    "cart": cart!.toJson(),
  };
}

class Cart {
  Cart({
    this.id,
    this.updatedAt,
    this.total,
    this.subTotal,
    this.tax,
    this.discount,
    this.cartItems,
  });

  int? id;
  String? updatedAt;
  double? total;
  int ?subTotal;
  int ?tax;
  dynamic discount;
  List<CartItem>? cartItems;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    updatedAt: json["updated_at"],
    total: json["total"].toDouble(),
    subTotal: json["subTotal"],
    tax: json["tax"],
    discount: json["discount"],
    cartItems: List<CartItem>.from(json["cart_items"].map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
   // "updated_at": "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
    "total": total,
    "subTotal": subTotal,
    "tax": tax,
    "discount": discount,
    "cart_items": List<dynamic>.from(cartItems!.map((x) => x.toJson())),
  };
}

class CartItem {
  CartItem({
    this.id,
    this.cartId,
    this.productId,
    this.productPrice,
    this.productCount,
    this.products,
  });

  int ?id;
  int ?cartId;
  int ?productId;
  int ?productPrice;
  int ?productCount;
  Products? products;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    cartId: json["cart_id"],
    productId: json["product_id"],
    productPrice: json["product_price"],
    productCount: json["product_count"],
    products: Products.fromJson(json["products"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_id": cartId,
    "product_id": productId,
    "product_price": productPrice,
    "product_count": productCount,
    "products": products!.toJson(),
  };
}

class Products {
  Products({
    this.id,
    this.title,
    this.photo,
  });

  int ?id;
  String ?title;
  String ?photo;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    title: json["title"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "photo": photo,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String ?label;
  bool ?active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}
