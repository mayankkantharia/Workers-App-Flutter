import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/inner_screens/task_details.dart';
import 'package:work_app/services/global_methods.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.taskTitle,
    required this.taskDescription,
    required this.taskId,
    required this.taskUploadedBy,
    required this.isDone,
    // required this.authorPosition,
    // required this.authorName,
    // required this.userImageUrl,
    required this.taskCategory,
    // required this.postedDate,
    required this.deadlineDate,
    required this.postedDateTimestamp,
    required this.deadlineDateTimestamp,
  }) : super(key: key);
  final bool isDone;
  final String taskId;
  final String taskTitle;
  final String taskUploadedBy;
  final String taskDescription;
  // final String authorName;
  // final String authorPosition;
  // final String userImageUrl;
  final String taskCategory;
  // final String postedDate;
  final String deadlineDate;
  final Timestamp postedDateTimestamp;
  final Timestamp deadlineDateTimestamp;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
              taskId: widget.taskId,
              uploadedBy: widget.taskUploadedBy,
              taskTitle: widget.taskTitle,
              taskDescription: widget.taskDescription,
              taskCategory: widget.taskCategory,
              isDone: widget.isDone,
              deadlineDate: widget.deadlineDate,
              deadlineDateTimestamp: widget.deadlineDateTimestamp,
              postedDateTimestamp: widget.postedDateTimestamp,
            ),
          );
        },
        onLongPress: _deleteDialog,
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
            child: Image.network(
              widget.isDone
                  ? 'https://image.flaticon.com/icons/png/128/390/390973.png'
                  : 'https://image.flaticon.com/icons/png/128/850/850960.png',
            ),
          ),
        ),
        title: Text(
          widget.taskTitle,
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
              widget.taskDescription,
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

  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (widget.taskUploadedBy == _uid) {
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(widget.taskId)
                        .delete();
                    await Fluttertoast.showToast(
                      msg: 'The task has been deleted.',
                      fontSize: 16.0,
                    );
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  } else {
                    GlobalMethods.showErrorDialog(
                      error: 'You cannot perform this action.',
                      context: context,
                    );
                  }
                } catch (error) {
                  GlobalMethods.showErrorDialog(
                    error: "This task can't be deleted.",
                    context: context,
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
}
