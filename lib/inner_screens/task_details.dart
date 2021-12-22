import 'package:flutter/material.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/widgets/comments_widget.dart';
import 'package:work_app/widgets/my_buttons.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _textStyle = const TextStyle(
    color: darkBlue,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  final _boldTextStyle = const TextStyle(
    color: darkBlue,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  final _decorationTextStyle = const TextStyle(
    color: darkBlue,
    fontSize: 15,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
  );
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkBlue),
        backgroundColor: ghostWhite,
        leadingWidth: 80,
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Back',
            style: myHeadingTextStyle,
          ),
        ),
        title: const Text(
          'Task Details',
          style: myHeadingTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text(
              'Task Title',
              style: TextStyle(
                color: darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ).py(20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  6.heightBox,
                  Row(
                    children: <Widget>[
                      Text(
                        'Uploaded By',
                        style: _boldTextStyle,
                      ),
                      const Spacer(),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Vx.pink700,
                          ),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      8.widthBox,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Uploader Name',
                            style: _textStyle,
                          ),
                          Text(
                            'Uploader Job',
                            style: _textStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  _dividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Uploaded On:',
                        style: _boldTextStyle,
                      ),
                      const Text(
                        '2001-03-12',
                        style: TextStyle(
                          color: darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Deadline Date:',
                        style: _boldTextStyle,
                      ),
                      const Text(
                        '2001-03-12',
                        style: TextStyle(
                          color: red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  const Text(
                    'Deadline is not finished yet',
                    style: TextStyle(
                      color: green,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ).centered(),
                  _dividerWidget(),
                  Text(
                    'Done state:',
                    style: _boldTextStyle,
                  ),
                  10.heightBox,
                  Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Done',
                          style: _decorationTextStyle,
                        ),
                      ),
                      const Opacity(
                        opacity: 0,
                        child: Icon(
                          Icons.check_box,
                          color: green,
                        ),
                      ),
                      40.widthBox,
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Not Done',
                          style: _decorationTextStyle,
                        ),
                      ),
                      const Opacity(
                        opacity: 1,
                        child: Icon(
                          Icons.check_box,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                  _dividerWidget(),
                  Text(
                    'Text Description:',
                    style: _boldTextStyle,
                  ),
                  10.heightBox,
                  Text(
                    'Uploader Name',
                    style: _textStyle,
                  ),
                  5.heightBox,
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: _isCommenting
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: TextField(
                                  maxLines: 6,
                                  maxLength: 100,
                                  controller: _commentController,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                    color: darkBlue,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ghostWhite,
                                    enabledBorder: myUnderlineInputBorderMethod(
                                      color: white,
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    MyMaterialButton(
                                      text: 'Post',
                                      textSize: 18,
                                      mainAxisSize: MainAxisSize.min,
                                      onPressed: () {},
                                    ).centered(),
                                    15.heightBox,
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                        });
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ).centered(),
                                  ],
                                ),
                              ),
                            ],
                          ).py(10)
                        : MyMaterialButton(
                            text: 'Add a comment',
                            textSize: 18,
                            mainAxisSize: MainAxisSize.min,
                            onPressed: () {
                              setState(() {
                                _isCommenting = !_isCommenting;
                              });
                            },
                          ).py(15).centered(),
                  ),
                  20.heightBox,
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CommentWidget();
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 1,
                      );
                    },
                    itemCount: 15,
                  ),
                ],
              ).p(10),
            ).p(10),
          ],
        ),
      ),
    );
  }

  _dividerWidget() {
    return Column(
      children: [
        6.heightBox,
        const Divider(
          thickness: 1,
        ),
        6.heightBox,
      ],
    );
  }
}
