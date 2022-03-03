import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/widgets/common_widgets.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/task_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String filterState = 'All';
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
              List _allCategory = [];
              List _selectedCategory = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                if (filterState == snapshot.data!.docs[i]['taskCategory']) {
                  _selectedCategory.add(snapshot.data!.docs[i]);
                } else if (filterState == 'All') {
                  _allCategory.add(snapshot.data!.docs[i]);
                }
              }
              if (filterState == 'All') {
                _selectedCategory = _allCategory;
              }
              return _selectedCategory.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _selectedCategory.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(
                          taskId: _selectedCategory[index]['taskId'],
                          taskTitle: _selectedCategory[index]['taskTitle'],
                          taskCategory: _selectedCategory[index]
                              ['taskCategory'],
                          taskDescription: _selectedCategory[index]
                              ['taskDescription'],
                          taskUploadedBy: _selectedCategory[index]
                              ['uploadedBy'],
                          isDone: _selectedCategory[index]['isDone'],
                          deadlineDate: _selectedCategory[index]
                              ['deadlineDate'],
                          deadlineDateTimestamp: _selectedCategory[index]
                              ['deadlineDateTimeStamp'],
                          postedDateTimestamp: _selectedCategory[index]
                              ['createdAt'],
                        ).pOnly(
                          bottom:
                              index == snapshot.data!.docs.length - 1 ? 20 : 0,
                        );
                      },
                    )
                  : messageWidget(
                      message: 'There are no tasks for this Category',
                    );
            } else {
              return messageWidget(
                message: 'There are no tasks.',
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
            width: size.width,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskCategoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      filterState = taskCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: red.shade200,
                      ),
                      Text(
                        taskCategoryList[index],
                        style: myDialogTextStyle,
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
              onPressed: () {
                setState(() {
                  filterState = 'All';
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
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
