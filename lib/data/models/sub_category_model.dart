class SubCategoryModel{
  int? id;
  String? title;
  String? image;
  bool? chosen;
  SubCategoryModel({this.image,this.title,this.id,this.chosen = false});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['photo'];
    title = json['name'];
  }
}