import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/common/widget/common_text_form_field.dart';
import 'package:practical_assignment/screen/login/login_controller.dart';
import 'package:practical_assignment/screen/register/register_screen.dart';
import 'package:string_validator/string_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final FocusNode emailFocus = new FocusNode();
  final FocusNode passwordFocus = new FocusNode();

  final _loginFormKey = GlobalKey<FormState>();
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    emailController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor.withOpacity(0.92),
      body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _loginFormKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Center(
                            child: Image.asset(
                              "assets/images/shopping-bag.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Login", style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.blackColor
                          ),)
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: CommonTextFormField(
                        textEditingController: emailController,
                        focusNode: emailFocus,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (term) {_fieldFocusChange(context, emailFocus, passwordFocus);},
                        hintText: 'Email id/ Phone number',
                        onTap: () {
                          setState(() {
                            emailFocus.context;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Email ID/ Phone Number";
                          } else {
                            if(isNumeric(value)) {
                              if(value.length != 10) {
                                return "Please enter valid Mobile Number";
                              }
                            } else {
                              if(!EmailValidator.validate(value)){
                                return "Please enter valid email id ";
                              }
                            }
                          }
                          return null;
                        },
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, emailFocus, passwordFocus);
                        },
                      ),
                    ),
                    isNumeric(emailController.text) || emailController.text.isEmpty
                        ? SizedBox.shrink()
                        : Obx(() {return Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: CommonTextFormField(
                        textEditingController: passwordController,
                        textInputType: TextInputType.text,
                        focusNode: passwordFocus,
                        textInputAction: TextInputAction.done,
                        obscureText: loginController.obscureTextLogin.value,
                        hintText: "Password",
                        onTap: () {
                          setState(() {
                            passwordFocus.context;
                          });
                        },
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          size: 15.0,
                          color: Colors.grey,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            loginController.passwordShow(loginController.obscureTextLogin.value);
                          },
                          child: new Container(
                            width: 40.0,
                            height: 40.0,
                            margin: new EdgeInsets.all(1.0),
                            child: Icon(
                              loginController.obscureTextLogin.value
                                  ? FontAwesomeIcons.solidEyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'The password field is required';
                          }
                          return null;
                        },
                      ),
                    );}),
                    Container(
                      margin: EdgeInsets.only(top: 25.0),
                      child: MaterialButton(
                        textColor: AppTheme.whiteColor,
                        padding: EdgeInsets.all(0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text("Next",
                              style: TextStyle(
                                color: AppTheme.whiteColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          if(isNumeric(emailController.text) && emailController.text.length == 10) {
                            if(_loginFormKey.currentState.validate()) {
                              loginController.signInWithPhone(emailController.text.trim());
                            }

                          } else {
                              if (_loginFormKey.currentState.validate()) {
                                loginController.loginInApp(
                                    emailController.text.trim(),
                                    passwordController.text.trim());
                              }
                          }

                          // signInWithPhone(phoneNoController.text);
                        },
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Get.to(RegisterScreen());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25.0, bottom: 30.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
