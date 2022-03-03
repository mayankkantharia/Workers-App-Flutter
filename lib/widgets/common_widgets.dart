import 'package:flutter/material.dart';
import 'package:work_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';

messageWidget({required String message}) {
  return Text(
    message,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 18,
      color: darkBlue,
    ),
  ).px(10).centered();
}
