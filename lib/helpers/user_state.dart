import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/screens/auth/login.dart';
import 'package:work_app/screens/tasks_screen.dart';

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
