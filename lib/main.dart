import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Work OS',
      theme: ThemeData(
        scaffoldBackgroundColor: ghostWhite,
        primarySwatch: Colors.pink,
      ),
      home: const TasksScreen(),
    );
  }
}
