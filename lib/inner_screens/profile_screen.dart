import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _titleTextStyle = const TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  final _contentTextStyle = TextStyle(
    fontSize: 18,
    color: blue[900],
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
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
                      'Name',
                      style: _titleTextStyle,
                    ).centered(),
                    10.heightBox,
                    Text(
                      'Job joined date 2021-8-10',
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
                    userInfo(title: 'Email:', content: 'email@gmail.com').p(4),
                    userInfo(title: 'Phone Number:', content: '48594758').p(4),
                    15.heightBox,
                    const Divider(thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _contactBy(
                          color: green,
                          icon: FontAwesomeIcons.whatsapp,
                          onPressed: () {
                            _openWhatsappChat();
                          },
                        ),
                        _contactBy(
                          color: red,
                          icon: Icons.email,
                          onPressed: () {
                            _mailTo();
                          },
                        ),
                        _contactBy(
                          color: purple,
                          icon: Icons.call_outlined,
                          onPressed: () {
                            _callPhoneNumber();
                          },
                        ),
                      ],
                    ).pSymmetric(v: 15),
                    const Divider(
                      thickness: 1,
                    ),
                    15.heightBox,
                    MyMaterialButton(
                      text: 'Logout',
                      icon: FontAwesomeIcons.signOutAlt,
                      onPressed: () {},
                      mainAxisSize: MainAxisSize.min,
                    ).centered(),
                    6.heightBox,
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
                        width: 8,
                        color: ghostWhite,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'),
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

  void _openWhatsappChat() async {
    String phoneNumber = '+919769445870';
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error Occured';
    }
  }

  void _mailTo() async {
    String email = 'mayankkantharia1@gmail.com';
    var mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      throw 'Error Occured';
    }
  }

  void _callPhoneNumber() async {
    String phoneNumber = '+919769445870';
    var phoneUrl = 'tel://$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Error Occured';
    }
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: _titleTextStyle,
        ),
        10.widthBox,
        Text(
          content,
          style: _contentTextStyle,
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
