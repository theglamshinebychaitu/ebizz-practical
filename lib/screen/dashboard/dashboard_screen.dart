import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/screen/dashboard/dashboard_controller.dart';
import 'package:practical_assignment/screen/home_menu/home_menu_screen.dart';
import 'package:practical_assignment/screen/profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {

  DashboardController dashboardController = Get.put(DashboardController());

  final List<Widget> _children = [
    HomeMenuScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        return Scaffold(
          appBar: AppBar(
            title: Text(dashboardController.currentIndex.value == 0 ? "Shop Now" : "My Profile", style: TextStyle(
              fontSize: 18.0,
              color: AppTheme.whiteColor
            ),),
            backgroundColor: AppTheme.primaryColor,
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [

                    Container(
                      margin: EdgeInsets.only(right: 10.0, top: 10.0),
                      child: Icon(FontAwesomeIcons.shoppingCart,
                        size: 25.0,
                        color: AppTheme.whiteColor,
                      ),
                    ),
                    Container(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: AppTheme.redColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Text(
                          dashboardController.cart.value.toString(),
                          style: TextStyle(color: AppTheme.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              onTap: dashboardController.onTabTapped,
              currentIndex: dashboardController.currentIndex.value,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/home.png",
                    height: 27,
                    width: 27,
                    color: AppTheme.blackColor,

                  ),
                  activeIcon: Image.asset(
                    "assets/images/home.png",
                    height: 27,
                    width: 27,
                    color: AppTheme.primaryColor,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/user.png",
                    height: 27,
                    width: 27,
                    color: AppTheme.blackColor,
                  ),
                  activeIcon: Image.asset(
                    "assets/images/user.png",
                    height: 27,
                    width: 27,
                    color: AppTheme.primaryColor,
                  ),
                  label: "",
                ),
              ]),
          body: IndexedStack(
            index: dashboardController.currentIndex.value,
            children: _children,
          )
          //_children[_currentIndex],
        );
      },
    );
  }
}
