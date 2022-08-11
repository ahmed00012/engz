class StatusModel{
  int? id;
  String? title;
  String? image;
  bool? chosen;
  StatusModel({this.image,this.title,this.id,this.chosen = false});

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['photo'];
    title = json['name'];
  }
}