import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/task_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class TasksScreen extends StatefulWidget {
  // const TasksScreen({Key? key}) : super(key: key);

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
      body: ListView.builder(
        itemCount: 15,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return const TaskWidget().pOnly(
            top: index == 0 ? 6 : 0,
            bottom: index == 14 ? 6 : 0,
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
            width: size.width * 0.9,
            child: ListView.builder(
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
