import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical_assignment/common/controller/loading_controller.dart';
import 'package:practical_assignment/common/function/common_function.dart';
import 'package:practical_assignment/common/utils/shared_preference_helper.dart';
import 'package:practical_assignment/firebase/user_repository.dart';
import 'package:practical_assignment/screen/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends LoadingController {

  Rx<TextEditingController> nameController = new TextEditingController().obs;
  Rx<TextEditingController> mobileController = new TextEditingController().obs;
  Rx<TextEditingController> ageController = new TextEditingController().obs;
  Rx<TextEditingController> emailController = new TextEditingController().obs;
  Rx<TextEditingController> dobController = new TextEditingController().obs;
  var gender = "".obs;
  RxList<String> genderList = ['Male', 'Female'].obs;
  var imageUrl = "".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameController.value.text = preferences.getString(SharedPreferenceHelper.name);
    gender(preferences.getString(SharedPreferenceHelper.gender));
    ageController.value.text = preferences.getString(SharedPreferenceHelper.age);
    mobileController.value.text = preferences.getString(SharedPreferenceHelper.mobileNumber);
    emailController.value.text = preferences.getString(SharedPreferenceHelper.email != "null" ? SharedPreferenceHelper.email : "");
    dobController.value.text = preferences.getString(SharedPreferenceHelper.dob);
    imageUrl(preferences.getString(SharedPreferenceHelper.profileImage));
  }

  void updateMyAccount(String name, String gender, String age,
      String mobile,  String email, String dob, XFile image) async {
    showLoading();

    await UserRepository().updateMyAccountInfo(name, gender, age, mobile, email, dob, image).then((value) {
      if(value) {
        dismissLoading();
        showToast("Profile information updated");
        getData();
      }
    }).catchError((onError) {
      dismissLoading();
      showToast(onError.message);
    });
  }

  List<DropdownMenuItem<String>> getList(List list) {
    List<DropdownMenuItem<String>> items = new List();

    list.toSet().toList().forEach((value) {
      items.add(
        DropdownMenuItem(
          value: value,
          child: Text(
            value,
          ),
        ),
      );
    });
    return items;
  }

  void logout() {
    showLoading();
    UserRepository().signOut().then((value) {
      dismissLoading();
      Get.reset();
      Get.offAll(() => LoginScreen());
    }).catchError((e) => print(e));
  }

}