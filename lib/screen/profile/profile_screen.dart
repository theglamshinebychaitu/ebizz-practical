import 'dart:io';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/common/widget/common_text_form_field.dart';
import 'package:practical_assignment/screen/profile/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _profileFormKey = GlobalKey<FormState>();

  final FocusNode nameFocus = new FocusNode();
  final FocusNode mobileFocus = new FocusNode();
  final FocusNode ageFocus = new FocusNode();
  final FocusNode dobFocus = new FocusNode();
  final FocusNode emailFocus = new FocusNode();

  ProfileController profileController = Get.put(ProfileController());
  XFile image;

  @override
  Widget build(BuildContext context) {
    profileController.getData();
    return Scaffold(
      backgroundColor: AppTheme.blackColor.withOpacity(0.1),
      body: SingleChildScrollView(
          child: Obx(() {
            return Form(
              key: _profileFormKey,
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      height: 100.0,
                                      width: 100.0,
                                      child: image != null  ? CircleAvatar(
                                        backgroundImage: FileImage(File(image.path)),
                                      ) : profileController.imageUrl.value != "" && profileController.imageUrl.value != "null" && profileController.imageUrl.value != null? CircleAvatar(backgroundImage: NetworkImage(profileController.imageUrl.value),) :
                                      CircleAvatar(
                                        child: Text(profileController.nameController.value.text.isNotEmpty ? profileController.nameController.value.text.toString().split("")[0] : "A", style: TextStyle(color: Colors.white, fontSize: 30.0),),
                                        backgroundColor: Theme.of(context).primaryColor,
                                      )

                                    // CircleAvatar(
                                    //   backgroundImage: _image != null ? FileImage(_image),
                                    //   child: _image != null ? FileImage(_image) : imageUrl.isNotEmpty ? NetworkImage(imageUrl) : Text(groupNameController.text.isNotEmpty ? groupNameController.text.toString().split("")[0] : "A", style: TextStyle(color: Colors.white, fontSize: 30.0),),
                                    //   backgroundColor: Theme.of(context).primaryColor,
                                    // ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: new Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                new ListTile(
                                                  leading: new Icon(Icons.camera),
                                                  title: new Text('Camera'),
                                                  onTap: () {
                                                    getImage(ImageSource.camera);
                                                    // this is how you dismiss the modal bottom sheet after making a choice
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                new ListTile(
                                                  leading: new Icon(Icons.image),
                                                  title: new Text('Gallery'),
                                                  onTap: () {
                                                    getImage(ImageSource.gallery);
                                                    // dismiss the modal sheet
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(top: 70.0, left: 70.0),
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                                        ),
                                        child: Icon(Icons.edit)),
                                  )
                                ],
                              )

                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: CommonTextFormField(
                        textEditingController: profileController.nameController.value,
                        focusNode: nameFocus,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        hintText: 'Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter name";
                          }
                          return null;
                        },
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, nameFocus, emailFocus);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: IgnorePointer(
                        ignoring: profileController.emailController.value.text.isNotEmpty ? true : false,
                        child: CommonTextFormField(
                          textEditingController: profileController.emailController.value,
                          focusNode: emailFocus,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (term) {_fieldFocusChange(context, emailFocus, passwordFocus);},
                          hintText: 'Email id',
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Email ID";
                            } else if(!EmailValidator.validate(value)){
                              return "Please enter valid email id ";
                            }

                            return null;
                          },
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, emailFocus, mobileFocus);
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: IgnorePointer(
                        ignoring: profileController.mobileController.value.text.isNotEmpty ? true : false,
                        child: CommonTextFormField(
                          textEditingController: profileController.mobileController.value,
                          focusNode: mobileFocus,
                          textInputType: TextInputType.number,
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (term) {_fieldFocusChange(context, emailFocus, passwordFocus);},
                          hintText: 'Mobile number',
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter mobile number";
                            } else if(value.length != 10){
                              return "Please enter valid mobile number ";
                            }

                            return null;
                          },
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, mobileFocus, ageFocus);
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: CommonTextFormField(
                        textEditingController: profileController.ageController.value,
                        focusNode: ageFocus,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        hintText: 'Age',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: CommonTextFormField(
                            textEditingController: profileController.dobController.value,
                            focusNode: dobFocus,
                            textInputType: TextInputType.datetime,
                            textInputAction: TextInputAction.done,
                            hintText: 'Date of birth',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 20.0),
                      decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text('Gender'),
                            value: profileController.gender.value != "" ? profileController.gender.value : null,
                            onChanged: (newValue) {
                              profileController.gender(newValue);
                            },
                            items: profileController.getList(profileController.genderList),
                          ),
                        ),
                      ),
                    ),


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
                            child: Text("Update Profile",
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

                          if (_profileFormKey.currentState.validate()) {
                            profileController.updateMyAccount(
                                profileController.nameController.value.text,
                                profileController.gender.value,
                                profileController.ageController.value.text,
                                profileController.mobileController.value.text,
                                profileController.emailController.value.text,
                                profileController.dobController.value.text,
                                image
                            );
                          }

                        },
                      ),
                    ),
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
                            child: Text("Logout",
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
                          profileController.logout();
                        },
                      ),
                    ),

                  ],
                ),
              ),
            );
          })
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    var imageData = await _picker.pickImage(
        source: source, maxHeight: 200.0, maxWidth: 200.0);

    if (imageData != null) {
      setState(() {
        image = imageData;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: profileController.selectedDate.value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != profileController.selectedDate.value)
      profileController.selectedDate(picked);
    profileController.dobController.value.text = "${picked.day}/${picked.month}/${picked.year}";
  }


  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

