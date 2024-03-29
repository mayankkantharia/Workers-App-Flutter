import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/screens/auth/login.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _positionTextController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final _signUpFormKey = GlobalKey<FormState>();

  CroppedFile? imageFile;
  bool _obscureText = true;
  bool _isLoading = false;
  late String imageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 25,
      ),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        for (int i = 0; i < 3; i++) {
          if (animationStatus == AnimationStatus.completed) {
            _animationController.reset();
            _animationController.forward();
          }
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _focusNodeDispose() {
    //dispose focus nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneFocusNode.dispose();
  }

  void _textEditinControllerDispose() {
    //textediting controllers
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _positionTextController.dispose();
    _phoneNumberController.dispose();
  }

  void _focusNodeUnfocus() {
    //unfocus focus nodes
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _positionFocusNode.unfocus();
    _phoneFocusNode.unfocus();
  }

  @override
  void dispose() {
    //animation controller
    _animationController.dispose();
    _focusNodeDispose();
    _textEditinControllerDispose();
    super.dispose();
  }

  void _submitFormSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethods.showErrorDialog(
          error: 'Please pick an Image',
          context: context,
        );
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        try {
          await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passwordTextController.text,
          );
          final User? user = _auth.currentUser;
          final uid = user!.uid;
          final ref = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child('$uid.jpg');
          await ref.putFile(File(imageFile!.path));
          imageUrl = await ref.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(uid).set(
            {
              'id': uid,
              'name': _fullNameTextController.text,
              'email': _emailTextController.text,
              'userImage': imageUrl,
              'phoneNumber': _phoneNumberController.text,
              'positionInCompany': _positionTextController.text,
              'createdAt': Timestamp.now(),
            },
          );
          if (!mounted) return;
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        } on FirebaseAuthException catch (error) {
          setState(() {
            _isLoading = false;
          });
          GlobalMethods.showErrorDialog(
            error: error.message.toString(),
            context: context,
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          SafeArea(
            child: FadeInUp(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    10.heightBox,
                    const Text(
                      'SignUp',
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    10.heightBox,
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account?",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(text: '    '),
                          TextSpan(
                            text: "Login",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                                navigateWithReplacement(
                                  context,
                                  const LoginScreen(),
                                );
                              },
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: blue[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    40.heightBox,
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _focusNodeUnfocus();
                              _showImageDialog();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: white,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? Image.asset(
                                            'assets/images/profile.png',
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            File(imageFile!.path),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ).p(12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: pink,
                                    border: Border.all(
                                      width: 2,
                                      color: white,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    imageFile == null
                                        ? Icons.add_a_photo
                                        : Icons.edit_outlined,
                                    color: white,
                                    size: 18,
                                  ).p(6),
                                ).positioned(top: 0, right: 0),
                              ],
                            ),
                          ),
                          10.heightBox,
                          TextFormField(
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameTextController,
                            style: myTextFormFieldStyle,
                            decoration: const InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: myHintStyle,
                              enabledBorder: myUnderlineInputBorder,
                              focusedBorder: myUnderlineInputBorder,
                              errorBorder: myErrorUnderlineInputBorder,
                              focusedErrorBorder: myErrorUnderlineInputBorder,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          20.heightBox,
                          TextFormField(
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Please enter a valid Email address";
                              } else {
                                return null;
                              }
                            },
                            style: myTextFormFieldStyle,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: myHintStyle,
                              enabledBorder: myUnderlineInputBorder,
                              focusedBorder: myUnderlineInputBorder,
                              errorBorder: myErrorUnderlineInputBorder,
                              focusedErrorBorder: myErrorUnderlineInputBorder,
                            ),
                          ),
                          20.heightBox,
                          TextFormField(
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_phoneFocusNode),
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordTextController,
                            style: myTextFormFieldStyle,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: myHintStyle,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: white,
                                ),
                              ),
                              enabledBorder: myUnderlineInputBorder,
                              focusedBorder: myUnderlineInputBorder,
                              errorBorder: myErrorUnderlineInputBorder,
                              focusedErrorBorder: myErrorUnderlineInputBorder,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return "Please enter a valid password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          20.heightBox,
                          TextFormField(
                            focusNode: _phoneFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_positionFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            style: myTextFormFieldStyle,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: myHintStyle,
                              enabledBorder: myUnderlineInputBorder,
                              focusedBorder: myUnderlineInputBorder,
                              errorBorder: myErrorUnderlineInputBorder,
                              focusedErrorBorder: myErrorUnderlineInputBorder,
                            ),
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid phone number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          20.heightBox,
                          GestureDetector(
                            onTap: () {
                              _focusNodeUnfocus();
                              _showTaskCategoriesDialog(size: size);
                            },
                            child: TextFormField(
                              enabled: false,
                              focusNode: _positionFocusNode,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () => _submitFormSignUp(),
                              keyboardType: TextInputType.text,
                              controller: _positionTextController,
                              style: myTextFormFieldStyle,
                              decoration: const InputDecoration(
                                hintText: 'Position',
                                hintStyle: myHintStyle,
                                enabledBorder: myUnderlineInputBorder,
                                disabledBorder: myUnderlineInputBorder,
                                focusedBorder: myUnderlineInputBorder,
                                errorBorder: myErrorUnderlineInputBorder,
                                focusedErrorBorder: myErrorUnderlineInputBorder,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is missing";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: pink[700]!,
                            ),
                          ).pOnly(top: 40, bottom: 20).centered()
                        : MyMaterialButton(
                            text: 'SignUp',
                            onPressed: _submitFormSignUp,
                            icon: Icons.person_add,
                          ).pOnly(top: 40, bottom: 20).centered(),
                  ],
                ),
              ).centered(),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Please choose an action',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getImageFromCamera();
                },
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.camera,
                      color: purple,
                      size: 30,
                    ),
                    24.widthBox,
                    const Text(
                      'Camera',
                      style: TextStyle(
                        color: purple,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              15.heightBox,
              InkWell(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.photo,
                      color: purple,
                      size: 30,
                    ),
                    24.widthBox,
                    const Text(
                      'Gallery',
                      style: TextStyle(
                        color: purple,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImageFromGallery() async {
    XFile? selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(selectedImage!.path);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _getImageFromCamera() async {
    XFile? selectedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(selectedImage!.path);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Choose your Job',
            style: myHeadingTextStyle,
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              itemCount: jobsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _positionTextController.text = jobsList[index];
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
                        jobsList[index],
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
