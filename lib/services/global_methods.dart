import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/helpers/user_state.dart';

class GlobalMethods {
  static void mailTo({required email}) async {
    var mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      throw 'Error Occured';
    }
  }

  static void openWhatsappChat({required phoneNumber}) async {
    var url = 'https://wa.me/+91$phoneNumber?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error Occured';
    }
  }

  static void callPhoneNumber({required phoneNumber}) async {
    var phoneUrl = 'tel://+91$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Error Occured';
    }
  }

  static void logout(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/images/logout.png',
                height: 25,
                width: 25,
              ).p(8),
              const Text(
                'Sign Out',
              ).p(8),
            ],
          ),
          content: const Text(
            'Do you want to Sign Out?',
            style: TextStyle(
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
                'Cancel',
                style: myAlertTextButtonTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                navigateWithReplacement(context, const UserState());
              },
              child: const Text(
                'Yes',
                style: myAlertTextButtonTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog({
    required String error,
    required BuildContext context,
  }) {
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
              const Text(
                'Error Occured',
              ).p(8),
            ],
          ),
          content: Text(
            error,
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
