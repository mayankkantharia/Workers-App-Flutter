import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/my_buttons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);
  final String userID;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _titleTextStyle = const TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  final _contentTextStyle = TextStyle(
    fontSize: 15,
    color: blue[900],
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String phoneNumber = '';
  String email = '';
  String name = '';
  String job = '';
  String imageUrl = '';
  String joinedAt = '';
  bool isSameUser = false;
  void getUserData() async {
    try {
      _isLoading = true;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc.exists) {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          job = userDoc.get('positionInCompany');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
          _isLoading = false;
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          isSameUser = _uid == widget.userID;
        });
      }
    } catch (error) {
      return;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _logoutButton() {
      return Column(
        children: [
          MyMaterialButton(
            text: 'Logout',
            icon: FontAwesomeIcons.signOutAlt,
            onPressed: () {
              GlobalMethods.logout(context);
            },
            mainAxisSize: MainAxisSize.min,
          ).centered(),
          6.heightBox
        ],
      );
    }

    Widget _contactWidget() {
      return Column(
        children: [
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _contactBy(
                color: green,
                icon: FontAwesomeIcons.whatsapp,
                onPressed: () {
                  GlobalMethods.openWhatsappChat(phoneNumber: phoneNumber);
                },
              ),
              _contactBy(
                color: red,
                icon: Icons.email,
                onPressed: () {
                  GlobalMethods.mailTo(email: email);
                },
              ),
              _contactBy(
                color: purple,
                icon: Icons.call_outlined,
                onPressed: () {
                  GlobalMethods.callPhoneNumber(phoneNumber: phoneNumber);
                },
              ),
            ],
          ).pSymmetric(v: 15),
          const Divider(thickness: 1),
          15.heightBox,
        ],
      );
    }

    return _isLoading
        ? Scaffold(
            backgroundColor: ghostWhite,
            body: SpinKitDualRing(
              color: pink[700]!,
            ).centered(),
          )
        : Scaffold(
            drawer: const DrawerWidget(),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: darkBlue),
              backgroundColor: ghostWhite,
              title: const Text(
                'Profile',
                style: myHeadingTextStyle,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          60.heightBox,
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ).centered(),
                          10.heightBox,
                          Text(
                            '$job since $joinedAt',
                            style: _contentTextStyle,
                          ).centered(),
                          15.heightBox,
                          const Divider(thickness: 1),
                          20.heightBox,
                          Text(
                            'Contact Info',
                            style: _titleTextStyle,
                          ).pSymmetric(h: 4),
                          15.heightBox,
                          userInfo(
                            title: 'Email:',
                            content: email,
                          ).p(4),
                          userInfo(
                            title: 'Phone Number:',
                            content: phoneNumber,
                          ).p(4),
                          15.heightBox,
                          isSameUser ? 0.heightBox : _contactWidget(),
                          isSameUser ? _logoutButton() : 0.heightBox,
                        ],
                      ).p(15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 10,
                              color: ghostWhite,
                              style: BorderStyle.solid,
                            ),
                            image: DecorationImage(
                              filterQuality: FilterQuality.medium,
                              image: NetworkImage(
                                imageUrl == "" || imageUrl.isEmptyOrNull
                                    ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                    : imageUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ).centered(),
            ),
          );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: _titleTextStyle,
        ),
        10.widthBox,
        Flexible(
          child: Text(
            content,
            style: _contentTextStyle,
          ),
        )
      ],
    );
  }

  Widget _contactBy({
    required Color color,
    required Function onPressed,
    required IconData icon,
  }) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: white,
        child: IconButton(
          onPressed: () {
            onPressed();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }
}
