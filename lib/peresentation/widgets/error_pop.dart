
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';



class ErrorPopUp extends StatelessWidget {
  final String message;

  ErrorPopUp({ required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'عذرا',
          style: TextStyle(),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 8.0),
          Container(
            child: Text(
              "$message",
              style: TextStyle(),
            ),
          ),
          SizedBox(height: 24.0),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(

              decoration: BoxDecoration(
                  color: kColorPrimary,
                borderRadius: BorderRadius.circular(15)
              ),
              height: 40,
              width: 150,
              child: Center(
                child: Text(
                  "حسنا",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
