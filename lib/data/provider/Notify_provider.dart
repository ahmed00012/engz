
import 'package:flutter/material.dart';
import 'package:engez/data/local_storage.dart';
import 'package:engez/data/models/notification_model.dart';
import 'package:engez/data/servicese/notification.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyProvider extends ChangeNotifier{
  NotifyProvider(){
    getNotify();

  }
  NotificationModel notify = new NotificationModel(data: []);

  int page =1;
  RefreshController controller = RefreshController();
  bool isLoud = false;

  void getNotify(){
    OfferService.instance.getOffers(1,LocalStorage.getData(key: "token")).then((homeNew){

      notify = homeNew!;
      isLoud = true;
      notifyListeners();
    }
    );
  }

  void onRefresh(){
    page++;
    OfferService.instance.getOffers(page,LocalStorage.getData(key: "token")).then((valueNew){
      NotificationModel? notify2 = valueNew!;
      notify.data.addAll(notify2!.data);
      notify2=null;
      controller.loadComplete();
      notifyListeners();
    }
    );
  }

}