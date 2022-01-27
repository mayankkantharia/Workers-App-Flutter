import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/inner_screens/profile_screen.dart';
import 'package:work_app/inner_screens/upload_task_screen.dart';
import 'package:work_app/screens/all_workers_screen.dart';
import 'package:work_app/screens/tasks_screen.dart';
import 'package:work_app/services/global_methods.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: cyan,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1055/1055672.png',
                  ),
                ),
                10.heightBox,
                const Flexible(
                  child: Text(
                    'Work App',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.heightBox,
          _listTile(
            label: 'All Tasks',
            onTap: () {
              navigateWithReplacement(context, const TasksScreen());
            },
            icon: Icons.task_outlined,
          ),
          _listTile(
            label: 'My Account',
            onTap: () {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final User user = _auth.currentUser!;
              final String uid = user.uid;
              navigateWithReplacement(
                context,
                ProfileScreen(
                  userID: uid,
                ),
              );
            },
            icon: Icons.account_circle_outlined,
          ),
          _listTile(
            label: 'Registered Workers',
            onTap: () {
              navigateWithReplacement(context, const AllWorkersScreen());
            },
            icon: Icons.workspaces_outline,
          ),
          _listTile(
            label: 'Add a task',
            onTap: () {
              navigateWithReplacement(context, const UploadTaskScreen());
            },
            icon: Icons.add_task,
          ),
          const Divider(
            thickness: 1,
          ),
          _listTile(
            label: 'Logout',
            onTap: () {
              GlobalMethods.logout(context);
            },
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Widget _listTile({
    required String label,
    required Function onTap,
    required IconData icon,
  }) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Icon(
        icon,
        color: darkBlue,
        size: 26,
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: darkBlue,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
