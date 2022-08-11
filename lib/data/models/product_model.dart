class ProductModel {
  int? id;
  String? title;
  String? description;
  double? price;
  double? oldPrice;
  double? pricePerUnit;
  bool? sale;
  double? salePercentage;
  String? subCategory;
  String? image;
  String? type;
  int? qty;
  bool? chosen;
  int? minQty;
  int? cartCount;
  bool ?isFav;

  ProductModel(
      {this.title,
        this.price,
        this.id,
        this.description,
        this.pricePerUnit,
        this.sale,
        this.salePercentage,
        this.oldPrice,
        this.image,
        this.subCategory,
        this.chosen,this.qty,this.minQty,this.cartCount,this.isFav});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['photo'];
    title = json['title'];
    description = json['description'];
    price = double.parse(json['price'].toString());
    oldPrice =json['oldPrice']!=null? double.parse(json['oldPrice'].toString()):0.0;
    pricePerUnit = double.parse(json['pricePerUnit'].toString());
    sale = false;
    salePercentage = json['salePercentage'] != null? double.parse(json['salePercentage'].toString()):0.0;
    qty = json['product_count'];
    minQty = json['minQty'];
    type = json['type'].toString();
    subCategory = json['company_id'].toString();
    cartCount = json['cartCount'];
    isFav = json['is_fav'];

  }
}
