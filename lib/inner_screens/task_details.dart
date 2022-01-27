import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_app/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/widgets/comments_widget.dart';
import 'package:work_app/widgets/my_buttons.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    Key? key,
    required this.uploadedBy,
    required this.taskId,
    required this.taskCategory,
    required this.taskDescription,
    required this.taskTitle,
    required this.deadlineDate,
    required this.postedDateTimestamp,
    required this.deadlineDateTimestamp,
    required this.isDone,
  }) : super(key: key);
  final String uploadedBy;
  final String taskId;
  final String taskCategory;
  final String taskDescription;
  final String taskTitle;
  final String deadlineDate;
  final Timestamp postedDateTimestamp;
  final Timestamp deadlineDateTimestamp;
  final bool isDone;

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
  String? authorName;
  String? authorPosition;
  String? userImageUrl;
  String? postedDate;
  String? _loggedUserName;
  String? _loggedInUserImageUrl;
  late bool _isDone;
  bool _isCommenting = false;
  bool _isLoading = false;
  bool isDeadlineAvailable = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  late String _uid;

  @override
  void initState() {
    super.initState();
    getTaskData();
  }

  void getTaskData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      user = _auth.currentUser;
      _uid = user!.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      if (userDoc.exists) {
        setState(() {
          authorName = userDoc.get('name');
          authorPosition = userDoc.get('positionInCompany');
          userImageUrl = userDoc.get('userImage');
        });
      } else {
        return;
      }
      final DocumentSnapshot getCommenterInfoDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (getCommenterInfoDoc.exists) {
        setState(() {
          _loggedUserName = getCommenterInfoDoc.get('name');
          _loggedInUserImageUrl = getCommenterInfoDoc.get('userImage');
        });
      } else {
        return;
      }
      var postDate = widget.postedDateTimestamp.toDate();
      postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      var date = widget.deadlineDateTimestamp.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (taskDatabase.exists) {
        setState(() {
          _isDone = taskDatabase.get('isDone');
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.showErrorDialog(
        error: error.toString(),
        context: context,
      );
    }
  }

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
      body: _isLoading
          ? const CircularProgressIndicator().centered()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.taskTitle,
                    style: const TextStyle(
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
                              'Uploaded By:',
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
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                        : userImageUrl!,
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
                                  authorName == null ? '' : authorName!,
                                  style: _textStyle,
                                ),
                                Text(
                                  authorPosition == null ? '' : authorPosition!,
                                  style: _textStyle,
                                  maxLines: 2,
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
                            Text(
                              postedDate.isEmptyOrNull ? '' : postedDate!,
                              style: const TextStyle(
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
                            Text(
                              widget.deadlineDate,
                              style: const TextStyle(
                                color: red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        10.heightBox,
                        Text(
                          isDeadlineAvailable
                              ? 'Deadline is not finished yet'
                              : 'Deadline passes',
                          style: TextStyle(
                            color: isDeadlineAvailable ? green : red,
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
                              onPressed: () {
                                if (_uid == widget.uploadedBy) {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(widget.taskId)
                                        .update({
                                      'isDone': true,
                                    });
                                    getTaskData();
                                  } catch (error) {
                                    GlobalMethods.showErrorDialog(
                                      error: 'Action cannot be performed.',
                                      context: context,
                                    );
                                  }
                                } else {
                                  GlobalMethods.showErrorDialog(
                                    error: 'You cannot perform this action.',
                                    context: context,
                                  );
                                }
                              },
                              child: Text(
                                'Done',
                                style: _decorationTextStyle,
                              ),
                            ),
                            Opacity(
                              opacity: _isDone ? 1 : 0,
                              child: const Icon(
                                Icons.check_box,
                                color: green,
                              ),
                            ),
                            40.widthBox,
                            TextButton(
                              onPressed: () {
                                if (_uid == widget.uploadedBy) {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(widget.taskId)
                                        .update({
                                      'isDone': false,
                                    });
                                    getTaskData();
                                  } catch (error) {
                                    GlobalMethods.showErrorDialog(
                                      error: 'Action cannot be performed.',
                                      context: context,
                                    );
                                  }
                                } else {
                                  GlobalMethods.showErrorDialog(
                                    error: 'You cannot perform this action.',
                                    context: context,
                                  );
                                }
                              },
                              child: Text(
                                'Not Done',
                                style: _decorationTextStyle,
                              ),
                            ),
                            Opacity(
                              opacity: _isDone ? 0 : 1,
                              child: const Icon(
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
                          widget.taskDescription,
                          style: _textStyle,
                        ),
                        5.heightBox,
                        _dividerWidget(),
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
                                          enabledBorder:
                                              myUnderlineInputBorderMethod(
                                            color: white,
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                            onPressed: () async {
                                              if (_commentController
                                                  .text.isEmptyOrNull) {
                                                GlobalMethods.showErrorDialog(
                                                  error:
                                                      'Comment can\'t be empty.',
                                                  context: context,
                                                );
                                              } else {
                                                final _generatedId =
                                                    const Uuid().v4();
                                                await FirebaseFirestore.instance
                                                    .collection('tasks')
                                                    .doc(widget.taskId)
                                                    .update({
                                                  'taskComments':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'userId': _uid,
                                                      'commentId': _generatedId,
                                                      'name': _loggedUserName,
                                                      'userImageUrl':
                                                          _loggedInUserImageUrl,
                                                      'commentBody':
                                                          _commentController
                                                              .text,
                                                      'time': Timestamp.now(),
                                                    }
                                                  ]),
                                                });
                                                await Fluttertoast.showToast(
                                                  msg: 'Your comment is added.',
                                                  fontSize: 16.0,
                                                );
                                                _commentController.clear();
                                                setState(() {
                                                  _isCommenting =
                                                      !_isCommenting;
                                                });
                                              }
                                            },
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
                                ).py(5)
                              : MyMaterialButton(
                                  text: 'Add a comment',
                                  textSize: 18,
                                  mainAxisSize: MainAxisSize.min,
                                  onPressed: () {
                                    setState(() {
                                      _isCommenting = !_isCommenting;
                                    });
                                  },
                                ).py(10).centered(),
                        ),
                        _dividerWidget(),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator()
                                  .centered();
                            } else {
                              if (snapshot.data!['taskComments'].length == 0) {
                                return const Text(
                                  'There are no comments.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: darkBlue,
                                  ),
                                ).centered();
                              }
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!['taskComments'].length,
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                  commentId: snapshot.data!['taskComments']
                                      [index]['commentId'],
                                  commenterId: snapshot.data!['taskComments']
                                      [index]['userId'],
                                  commenterName: snapshot.data!['taskComments']
                                      [index]['name'],
                                  commentBody: snapshot.data!['taskComments']
                                      [index]['commentBody'],
                                  commenterImageUrl:
                                      snapshot.data!['taskComments'][index]
                                          ['userImageUrl'],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ).p(12),
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
