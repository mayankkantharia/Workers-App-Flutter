import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/task_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkBlue),
        backgroundColor: ghostWhite,
        title: const Text(
          'Tasks',
          style: myHeadingTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showTaskCategoriesDialog(size: size);
            },
            icon: const Icon(
              Icons.filter_list_outlined,
              color: black,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdAt', descending: false)
            .snapshots(),
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
                  return TaskWidget(
                    taskId: snapshot.data!.docs[index]['taskId'],
                    taskTitle: snapshot.data!.docs[index]['taskTitle'],
                    taskCategory: snapshot.data!.docs[index]['taskCategory'],
                    taskDescription: snapshot.data!.docs[index]
                        ['taskDescription'],
                    taskUploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                    isDone: snapshot.data!.docs[index]['isDone'],
                    // authorName: snapshot.data!.docs[index][''],
                    // authorPosition: '',
                    // userImageUrl: '',
                    deadlineDate: snapshot.data!.docs[index]['deadlineDate'],
                    deadlineDateTimestamp: snapshot.data!.docs[index]
                        ['deadlineDateTimeStamp'],
                    postedDateTimestamp: snapshot.data!.docs[index]
                        ['createdAt'],
                  ).pOnly(
                    top: index == 0 ? 6 : 0,
                    bottom: index == snapshot.data!.docs.length - 1 ? 6 : 0,
                  );
                },
              );
            } else {
              return const Text(
                'There are no tasks.',
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

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Task Category',
            style: myHeadingTextStyle,
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskCategoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: red.shade200,
                      ),
                      Text(
                        taskCategoryList[index],
                        style: const TextStyle(
                          color: darkBlue,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ).p(8),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Close',
                style: myAlertTextButtonTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Cancel Filter',
                style: myAlertTextButtonTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
