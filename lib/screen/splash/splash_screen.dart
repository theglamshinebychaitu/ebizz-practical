import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/common/utils/shared_preference_helper.dart';
import 'package:practical_assignment/screen/dashboard/dashboard_screen.dart';
import 'package:practical_assignment/screen/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    startTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("assets/images/shopping-bag.png", height: 100.0, width: 100.0,)),
        ),
      );
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    await SharedPreferenceHelper.getIsLogin().then((value) {
      if (value == "true") {
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
