import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/widgets/common_widgets.dart';
import 'package:work_app/widgets/drawer_widget.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadTaskScreen extends StatefulWidget {
  const UploadTaskScreen({Key? key}) : super(key: key);

  @override
  _UploadTaskScreenState createState() => _UploadTaskScreenState();
}

class _UploadTaskScreenState extends State<UploadTaskScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _taskCategoryController = TextEditingController(
    text: 'Choose Task Category',
  );
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskDeadlineDateController =
      TextEditingController(
    text: 'Choose Task Deadline Date',
  );
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? datePicked;
  Timestamp? _deadlineDateTimeStamp;
  @override
  void dispose() {
    _taskCategoryController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _taskDeadlineDateController.dispose();
    super.dispose();
  }

  void _uploadTask() async {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final _taskID = const Uuid().v4();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_taskDeadlineDateController.text == 'Choose Task Deadline Date' ||
          _taskCategoryController.text == 'Choose Task Category') {
        return GlobalMethods.showErrorDialog(
          error: 'Please select all details.',
          context: context,
        );
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(_taskID).set(
          {
            'taskId': _taskID,
            'uploadedBy': _uid,
            'taskTitle': _taskTitleController.text,
            'taskDescription': _taskDescriptionController.text,
            'deadlineDate': _taskDeadlineDateController.text,
            'deadlineDateTimeStamp': _deadlineDateTimeStamp,
            'taskCategory': _taskCategoryController.text,
            'taskComments': [],
            'isDone': false,
            'createdAt': Timestamp.now(),
          },
        );
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded.',
          fontSize: 16.0,
        );
        _taskTitleController.clear();
        _taskDescriptionController.clear();
        setState(() {
          _taskCategoryController.text = 'Choose Task Category';
          _taskDeadlineDateController.text = 'Choose Task Deadline Date';
        });
      } on FirebaseException catch (error) {
        GlobalMethods.showErrorDialog(
          error: error.message.toString(),
          context: context,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(
        title: 'Upload Task',
      ),
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                14.heightBox,
                const Text(
                  'All fields are required',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ).centered(),
                const Divider(
                  thickness: 1,
                ),
                15.heightBox,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textTitles(label: 'Task Category*'),
                      _textFormField(
                        valueKey: 'TaskCategory',
                        controller: _taskCategoryController,
                        enabled: false,
                        maxLength: 100,
                        onTap: () {
                          _showTaskCategoriesDialog(size: size);
                        },
                      ),
                      _textTitles(label: 'Task Title*'),
                      _textFormField(
                        valueKey: 'TaskTitle',
                        controller: _taskTitleController,
                        enabled: true,
                        maxLength: 100,
                        onTap: () {},
                      ),
                      _textTitles(label: 'Task Description*'),
                      _textFormField(
                        valueKey: 'TaskDescription',
                        controller: _taskDescriptionController,
                        enabled: true,
                        maxLength: 1000,
                        onTap: () {},
                      ),
                      _textTitles(label: 'Task Deadline Date*'),
                      _textFormField(
                        valueKey: 'TaskDeadline',
                        controller: _taskDeadlineDateController,
                        enabled: false,
                        maxLength: 1000,
                        onTap: () {
                          _pickDateDialog();
                        },
                      ),
                      _isLoading
                          ? const CircularProgressIndicator().centered()
                          : MyMaterialButton(
                              text: 'Upload Task',
                              onPressed: _uploadTask,
                              icon: Icons.upload_file,
                              mainAxisSize: MainAxisSize.min,
                            ).centered(),
                      30.heightBox,
                    ],
                  ),
                ).pSymmetric(h: 12),
              ],
            ),
          ).pSymmetric(h: 10, v: 10),
        ).centered(),
      ),
    );
  }

  Widget _textTitles({required String label}) {
    return Text(
      label,
      style: myInputHeadingTextStyle,
    ).p(5);
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function onTap,
    required int maxLength,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          onTap();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          style: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: ghostWhite,
            enabledBorder: myUnderlineInputBorderMethod(
              color: ghostWhite,
            ),
            focusedBorder: myUnderlineInputBorderMethod(
              color: pink,
            ),
            errorBorder: myErrorUnderlineInputBorderMethod(
              color: red,
            ),
            focusedErrorBorder: myErrorUnderlineInputBorderMethod(
              color: red,
            ),
          ),
        ),
      ).p(5),
    );
  }

  _pickDateDialog() async {
    datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (datePicked != null) {
      setState(() {
        _taskDeadlineDateController.text =
            '${datePicked!.day}-${datePicked!.month}-${datePicked!.year}';
        _deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
          datePicked!.microsecondsSinceEpoch,
        );
      });
    }
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Task Category',
            style: myHeadingTextStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              itemCount: taskCategoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _taskCategoryController.text = taskCategoryList[index];
                    });
                    Navigator.pop(context);
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
                'Cancel',
                style: myAlertTextButtonTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
