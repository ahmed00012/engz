import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constant.dart';


class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key ?key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Container(
      height: he *.08,
      margin: EdgeInsets.symmetric(
        horizontal: 10 * 4,
      ).copyWith(
        bottom: 10 * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10 * 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 15,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],

      ),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: 10 * 2.5,
            color: kColorAccent,
          ),
          SizedBox(width: 10 * 1.5),
          Text(
            this.text,
            style:TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: dark
            ),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              FontAwesomeIcons.angleLeft,
              size: 10 * 2.5,
              color: dark,
            ),
        ],
      ),
    );
  }
}