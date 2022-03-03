import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:work_app/constants/constants.dart';
import 'package:work_app/helpers/screen_navigation.dart';
import 'package:work_app/screens/auth/forgot_password.dart';
import 'package:work_app/screens/auth/register.dart';
import 'package:work_app/services/global_methods.dart';
import 'package:work_app/helpers/user_state.dart';
import 'package:work_app/widgets/my_buttons.dart';
import 'package:animate_do/animate_do.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isLoading = false;

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
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitFormLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passwordTextController.text,
        );
        navigateWithReplacement(context, const UserState());
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErrorDialog(
          error: error.message.toString(),
          context: context,
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          // CachedNetworkImage(
          //   imageUrl:
          //   "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
          //   placeholder: (context, url) => SpinKitDualRing(
          //     color: pink[700]!,
          //   ).centered(),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.cover,
          //   alignment: FractionalOffset(_animation.value, 0),
          // ),
          SafeArea(
            child: FadeInUp(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
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
                            text: "Don't have an account?",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(text: '    '),
                          TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => navigateWithoutReplacement(
                                    context,
                                    const RegisterScreen(),
                                  ),
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
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            style: myTextFormFieldStyle,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: myHintStyle,
                              enabledBorder: myUnderlineInputBorder,
                              focusedBorder: myUnderlineInputBorder,
                              errorBorder: myErrorUnderlineInputBorder,
                              focusedErrorBorder: myErrorUnderlineInputBorder,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Please enter a valid Email address";
                              } else {
                                return null;
                              }
                            },
                          ),
                          20.heightBox,
                          TextFormField(
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () => _submitFormLogin(),
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
                        ],
                      ),
                    ),
                    15.heightBox,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => navigateWithoutReplacement(
                          context,
                          const ForgotPasswordScreen(),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    _isLoading
                        ? Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: pink[700]!,
                              ),
                            ).py(40),
                          )
                        : MyMaterialButton(
                            text: 'Login',
                            onPressed: _submitFormLogin,
                            icon: Icons.login,
                          ).py(50),
                  ],
                ),
              ).centered(),
            ),
          ),
        ],
      ),
    );
  }
}
