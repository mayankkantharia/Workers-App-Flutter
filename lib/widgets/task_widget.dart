// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/inner_screens/task_details.dart';
import 'package:work_app/services/global_methods.dart';

class TaskWidget extends StatelessWidget {
  TaskWidget({
    Key? key,
    required this.taskTitle,
    required this.taskDescription,
    required this.taskId,
    required this.taskUploadedBy,
    required this.isDone,
    required this.taskCategory,
    required this.deadlineDate,
    required this.postedDateTimestamp,
    required this.deadlineDateTimestamp,
  }) : super(key: key);
  final bool isDone;
  final String taskId;
  final String taskTitle;
  final String taskUploadedBy;
  final String taskDescription;
  final String taskCategory;
  final String deadlineDate;
  final Timestamp postedDateTimestamp;
  final Timestamp deadlineDateTimestamp;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    deleteDialog() {
      User? user = _auth.currentUser;
      final uid = user!.uid;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (taskUploadedBy == uid) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(taskId)
                          .delete();
                      await Fluttertoast.showToast(
                        msg: 'The task has been deleted.',
                        fontSize: 16.0,
                        backgroundColor: pink,
                        gravity: ToastGravity.CENTER,
                      );
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    } else {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      GlobalMethods.showErrorDialog(
                        error: 'You cannot perform this action.',
                        context: context,
                      );
                    }
                  } on FirebaseException catch (error) {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    GlobalMethods.showErrorDialog(
                      error: error.message.toString(),
                      context: context,
                    );
                    // GlobalMethods.showErrorDialog(
                    //   error: "This task can't be deleted.",
                    //   context: context,
                    // );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return Card(
      elevation: 2,
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          navigateWithoutReplacement(
            context,
            TaskDetailsScreen(
              taskId: taskId,
              uploadedBy: taskUploadedBy,
              taskTitle: taskTitle,
              taskDescription: taskDescription,
              taskCategory: taskCategory,
              isDone: isDone,
              deadlineDate: deadlineDate,
              deadlineDateTimestamp: deadlineDateTimestamp,
              postedDateTimestamp: postedDateTimestamp,
            ),
          );
        },
        onLongPress: deleteDialog,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
              ),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: transparent,
            radius: 20,
            child: Image.asset(
              isDone ? 'assets/images/done.png' : 'assets/images/not_done.png',
            ),
          ),
        ),
        title: Text(
          taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: pink[800],
            ),
            Text(
              taskDescription,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: pink[800],
        ),
      ),
    );
  }
}
