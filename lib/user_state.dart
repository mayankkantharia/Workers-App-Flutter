import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/screens/auth/forgot_password.dart';
import 'package:work_app/screens/auth/login.dart';
import 'package:work_app/screens/auth/register.dart';
import 'package:work_app/screens/tasks_screen.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:animate_do/animate_do.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          return const LoginScreen();
        } else if (userSnapshot.hasData) {
          return const TasksScreen();
        } else if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black87,
            body: const Text(
              'An error has been occured.',
              style: TextStyle(
                color: white,
              ),
            ).centered(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black87,
            body: SpinKitDualRing(
              color: pink[700]!,
            ).centered(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black87,
          body: const Text(
            'Something went wrong.',
            style: TextStyle(
              color: white,
            ),
          ).centered(),
        );
      },
    );
  }
}
