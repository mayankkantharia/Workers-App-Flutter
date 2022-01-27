import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/widgets/all_workers_widget.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({Key? key}) : super(key: key);
  @override
  _AllWorkersScreenState createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkBlue),
        backgroundColor: ghostWhite,
        title: const Text(
          'Registered Workers',
          style: myHeadingTextStyle,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitDualRing(
              color: pink[700]!,
            ).centered();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return AllWorkersWidget(
                    phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                    positionInCompany: snapshot.data!.docs[index]
                        ['positionInCompany'],
                    userEmail: snapshot.data!.docs[index]['email'],
                    userID: snapshot.data!.docs[index]['id'],
                    userImageUrl: snapshot.data!.docs[index]['userImage'],
                    userName: snapshot.data!.docs[index]['name'],
                  ).pOnly(
                    top: index == 0 ? 6 : 0,
                    bottom: index == snapshot.data!.docs.length - 1 ? 6 : 0,
                  );
                },
              );
            } else {
              return const Text(
                'There is no user',
                style: TextStyle(
                  fontSize: 18,
                  color: darkBlue,
                ),
              ).centered();
            }
          }
          return const Text(
            'Something went wrong.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ).centered();
        },
      ),
    );
  }
}
