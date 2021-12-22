import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/inner_screens/task_details.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
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
            const TaskDetailsScreen(),
          );
        },
        onLongPress: _deleteDialog,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
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
            radius:
                20, //'https://image.flaticon.com/icons/png/128/850/850960.png'
            child: Image.network(
                'https://image.flaticon.com/icons/png/128/390/390973.png'),
          ),
        ),
        title: const Text(
          'title',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
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
            const Text(
              'Subtitle/Task Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {},
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
