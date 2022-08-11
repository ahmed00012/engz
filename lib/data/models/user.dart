import '../local_storage.dart';

class UserModel {
  UserModel({
    this.data,
  });
  Data? data;

  UserModel.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
  }

}

class Data {
  Data(
      {this.id,
      this.name,
      this.mobile,
      this.cityId,
      this.cityName,
      this.cityMinDelivery,
      this.token,
      this.shopName,
      this.shopAddress,
      this.minProductOrder});
  int? id;
  String? name;
  String? mobile;
  int? cityId;
  String? cityName;
  int? cityMinDelivery;
  String? token;
  String? shopName;
  String? shopAddress;
  int? minProductOrder;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['name'] != null)
      LocalStorage.saveData(key: 'name', value: (json['name']));
    mobile = json['mobile'];
    if (json['mobile'] != null)
      LocalStorage.saveData(key: 'mobile', value: (json['mobile']));
    cityId = json['city_id'];
    if (json['city_id'] != null)
      LocalStorage.saveData(key: 'city_id', value: (json['city_id']));
    cityName = json['city_name'];
    cityMinDelivery = json['city_minDelivery'];
    if (json['city_minDelivery'] != null)
      LocalStorage.saveData(
          key: 'city_minDelivery', value: (json['city_minDelivery']));
    token = json['token'];
    if (json['token'] != null)
      LocalStorage.saveData(key: 'token', value: ("Bearer ${json['token']}"));
    shopName = json['shop_name'];
    if (json['shop_name'] != null)
      LocalStorage.saveData(key: 'shop_name', value: (json['shop_name']));
    shopAddress = json['shop_address'];
    if (json['shop_address'] != null)
      LocalStorage.saveData(key: 'shop_address', value: (json['shop_address']));

    minProductOrder = json['minProductOrder'];
    if (json['minProductOrder'] != null)
      LocalStorage.saveData(
          key: 'minProductOrder', value: (json['minProductOrder']));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['mobile'] = mobile;
    _data['city_id'] = cityId;
    _data['city_name'] = cityName;
    _data['city_minDelivery'] = cityMinDelivery;
    _data['token'] = token;
    _data['shop_name'] = shopName;
    _data['shop_address'] = shopAddress;
    return _data;
  }
}
