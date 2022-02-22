import 'package:flutter/material.dart';
import 'package:work_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/helpers/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: black.withOpacity(0.8),
              body: SpinKitDualRing(
                color: pink[700]!,
              ).centered(),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.black87,
              body: const Text(
                'An error has been occured.',
                style: TextStyle(
                  color: white,
                ),
              ).centered(),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Work OS',
          theme: ThemeData(
            scaffoldBackgroundColor: ghostWhite,
            primarySwatch: Colors.pink,
          ),
          home: const UserState(),
        );
      },
    );
  }
}
