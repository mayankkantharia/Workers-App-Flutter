import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/widgets/all_workers_widget.dart';
import 'package:work_app/widgets/common_widgets.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({Key? key}) : super(key: key);
  @override
  AllWorkersScreenState createState() => AllWorkersScreenState();
}

class AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: myAppBar(
        title: 'All Workers',
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
                    bottom: index == snapshot.data!.docs.length - 1 ? 30 : 0,
                    top: index == 0 ? 10 : 0,
                  );
                },
              );
            } else {
              return messageWidget(
                message: 'There is no user',
              );
            }
          }
          return messageWidget(
            message: 'Something went wrong.',
          );
        },
      ),
    );
  }
}
