// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.pagesTotal,
    this.currentPage,
    this.perPage,
    this.itemCount,
    required this.data,
  });

  bool? status;
  String? message;
  int ?pagesTotal;
  int ?currentPage;
  int ?perPage;
  int ?itemCount;
  List<NotificationData> data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    message: json["message"],
    pagesTotal: json["pages_total"],
    currentPage: json["current_page"],
    perPage: json["per_page"],
    itemCount: json["item_count"],
    data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "pages_total": pagesTotal,
    "current_page": currentPage,
    "per_page": perPage,
    "item_count": itemCount,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    this.notificationId,
    this.title,
    this.description,
    this.photo,
  });

  int ?notificationId;
  String? title;
  String ?description;
  String ?photo;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    notificationId: json["notification_id"],
    title: json["title"],
    description: json["content"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "title": title,
    "description": description,
    "photo": photo,
  };
}
