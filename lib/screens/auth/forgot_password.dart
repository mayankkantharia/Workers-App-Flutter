import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:animate_do/animate_do.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _emailTextController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
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
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _forgotPassword() {
    final isValid = _forgotPasswordFormKey.currentState!.validate();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => CircularProgressIndicator(
              color: pink[700],
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          SafeArea(
            child: FadeInUp(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  (size.height * 0.1).heightBox,
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  40.heightBox,
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  10.heightBox,
                  Form(
                    key: _forgotPasswordFormKey,
                    child: TextFormField(
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => _forgotPassword(),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "Please enter a valid Email address";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(
                        color: black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: white,
                        enabledBorder: myEnabeledBorder,
                        focusedBorder: myFocusedBorder,
                        errorBorder: myErrorBorder,
                        focusedErrorBorder: myFocusedErrorBorder,
                      ),
                    ),
                  ),
                  MyMaterialButton(
                    text: 'Reset Now',
                    onPressed: _forgotPassword,
                  ).py(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
