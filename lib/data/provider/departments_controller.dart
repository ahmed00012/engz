import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/models/sub_category_model.dart';
import 'package:engez/data/servicese/department_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final departmentsFuture =
ChangeNotifierProvider<DepartmentsController>((ref) => DepartmentsController());
class DepartmentsController extends ChangeNotifier {
  late  DepartmentService departmentService = DepartmentService();
 late List subcategories = [];
  int? categoryID;
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;
  bool loading = true;


  DepartmentsController(){
    onLoading();
  }



  void onLoading() async {
    var data = await departmentService.getSubCategory(page);
    loading = false;
    if(page <= data['pages_total']) {
      List list = data['department']
          .map((department) => SubCategoryModel.fromJson(department))
          .toList();
      list.forEach((element){
        subcategories.add(element);
      });
      list = [];
      print(subcategories.length.toString()+'dklsdkldsk');
      page ++;
      refreshController.loadComplete();
    }
    else{
      refreshController.loadComplete();
    }

    notifyListeners();
  }
}
