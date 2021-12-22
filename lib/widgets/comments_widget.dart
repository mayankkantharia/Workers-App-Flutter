import 'dart:math';

import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({Key? key}) : super(key: key);
  final List<Color> _colors = [
    red,
    blue,
    pink,
    green,
    cyan,
    purple,
    grey,
    orange,
    darkBlue,
    brown,
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: _colors[Random().nextInt(_colors.length)],
              ),
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        10.widthBox,
        Flexible(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Commentor Name',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Commentor Body',
                style: TextStyle(
                  color: grey.shade700,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
