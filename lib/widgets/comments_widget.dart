import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/inner_screens/profile_screen.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({
    Key? key,
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl,
  }) : super(key: key);
  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;
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
  final commenterNameTextStyle = const TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  final commentBodyTextStyle = TextStyle(
    color: grey.shade700,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateWithoutReplacement(
          context,
          ProfileScreen(
            userID: commenterId,
          ),
        );
      },
      child: Row(
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
                image: DecorationImage(
                  image: NetworkImage(
                    commenterImageUrl,
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
                Text(
                  commenterName,
                  style: commenterNameTextStyle,
                ),
                Text(
                  commentBody,
                  style: commentBodyTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
