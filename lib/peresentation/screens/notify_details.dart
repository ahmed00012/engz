
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:engez/data/models/notification_model.dart';

import '../../constant.dart';

class NotificationDetails extends StatelessWidget {
  const NotificationDetails({Key? key, required this.notification}) : super(key: key);
  final  NotificationData notification;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark,
        title: Text("الاشعارات",
          style: TextStyle(color: Colors.white, fontSize: size.height * 0.02),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),

      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                notification.photo.toString(),
                fit: BoxFit.fill,
                height: 250,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(notification.title.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(notification.description.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
