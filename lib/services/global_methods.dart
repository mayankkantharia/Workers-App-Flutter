import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants.dart';

class GlobalMethods {
  static void showErrorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 30,
                color: pink[700],
              ).p(8),
              // Image.network(
              //   'https://image.flaticon.com/icons/png/128/1252/1252006.png',
              //   height: 25,
              //   width: 25,
              // ).p(8),
              const Text(
                'Error Occured',
              ).p(8),
            ],
          ),
          content: Text(
            '$error',
            style: const TextStyle(
              color: darkBlue,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Ok',
                style: myAlertTextButtonTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
