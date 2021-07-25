import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/common/function/common_function.dart';
import 'package:practical_assignment/screen/verification_phone/verification_controller.dart';

class VerificationPhoneScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  final String name;

  VerificationPhoneScreen(this.phone, this.verificationId, {this.name});

  @override
  _VerificationPhoneScreenState createState() => _VerificationPhoneScreenState();
}

class _VerificationPhoneScreenState extends State<VerificationPhoneScreen> {
  final _verificationFormKey = GlobalKey<FormState>();
  String otp = "";
  Timer _timer;
  int _start = 60;
  bool isEnable = false;
  final TextEditingController otp1Controller = new TextEditingController();
  final TextEditingController otp2Controller = new TextEditingController();
  final TextEditingController otp3Controller = new TextEditingController();
  final TextEditingController otp4Controller = new TextEditingController();
  final TextEditingController otp5Controller = new TextEditingController();
  final TextEditingController otp6Controller = new TextEditingController();
  final FocusNode otp1Focus = new FocusNode();
  final FocusNode otp2Focus = new FocusNode();
  final FocusNode otp3Focus = new FocusNode();
  final FocusNode otp4Focus = new FocusNode();
  final FocusNode otp5Focus = new FocusNode();
  final FocusNode otp6Focus = new FocusNode();

  VerificationController verificationController = Get.put(VerificationController());

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            isEnable = true;
            timer.cancel();
            _start = 60;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    otp1Focus.addListener(() {
      otp1Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp1Controller.text.length,
      );
    });
    otp2Focus.addListener(() {
      otp2Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp2Controller.text.length,
      );
    });
    otp3Focus.addListener(() {
      otp3Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp3Controller.text.length,
      );
    });
    otp4Focus.addListener(() {
      otp4Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp4Controller.text.length,
      );
    });
    otp5Focus.addListener(() {
      otp5Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp5Controller.text.length,
      );
    });
    otp6Focus.addListener(() {
      otp6Controller.selection = new TextSelection(
        baseOffset: 0,
        extentOffset: otp6Controller.text.length,
      );
    });
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor.withOpacity(0.92),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _verificationFormKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontSize: 24.0,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'You will get a OTP via SMS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.blackColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 50.0, bottom: 50.0, left: 50.0, right: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // height: 50.0,
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp1Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp1Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                    color: AppTheme.blackColor,
                                    fontSize: 18.0,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp1Focus.context;
                                    });
                                    otp1Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp1Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      setState(() {
                                        _fieldFocusChange(context, otp1Focus, otp2Focus);
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp2Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp2Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 18.0
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp2Focus.context;
                                    });
                                    otp2Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp2Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      setState(() {
                                        _fieldFocusChange(context, otp2Focus, otp3Focus);
                                      });
                                    }
                                    if(text.isEmpty) {
                                      FocusScope.of(context).requestFocus(otp1Focus);
                                    }

                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp3Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp3Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 18.0
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp3Focus.context;
                                    });
                                    otp3Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp3Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      setState(() {
                                        _fieldFocusChange(context, otp3Focus, otp4Focus);
                                      });
                                    }
                                    if(text.isEmpty) {
                                      FocusScope.of(context).requestFocus(otp2Focus);
                                    }
                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp4Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp4Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 18.0
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp4Focus.context;
                                    });
                                    otp4Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp4Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      setState(() {
                                        _fieldFocusChange(context, otp4Focus, otp5Focus);
                                      });
                                    }
                                    if(text.isEmpty) {
                                      FocusScope.of(context).requestFocus(otp3Focus);
                                    }
                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp5Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp5Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 18.0
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp5Focus.context;
                                    });
                                    otp5Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp5Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      setState(() {
                                        _fieldFocusChange(context, otp5Focus, otp6Focus);
                                      });
                                    }
                                    if(text.isEmpty) {
                                      FocusScope.of(context).requestFocus(otp4Focus);
                                    }
                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            child: Container(
                              child: Center(
                                child: TextFormField(
                                  controller: otp6Controller,
                                  keyboardType: TextInputType.number,
                                  focusNode: otp6Focus,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  cursorColor: AppTheme.primaryColor,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: AppTheme.GreyColor),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.zero
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 18.0
                                  ),
                                  onTap: () {
                                    setState(() {
                                      otp6Focus.context;
                                    });
                                    otp6Controller.selection = new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: otp6Controller.text.length,
                                    );
                                  },
                                  onChanged: (text) {
                                    if(text.length == 1) {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                    }
                                    if(text.isEmpty) {
                                      FocusScope.of(context).requestFocus(otp5Focus);
                                    }
                                  },
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      showToast("Please enter valid otp !");
                                    }
                                    return null;
                                  },
                                  // maxLength: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryTextTheme.headline1.color,
                    padding: EdgeInsets.all(0),
                    child: Container(
                      margin: EdgeInsets.only(top: 50.0),
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                            color: AppTheme.whiteColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      if(_verificationFormKey.currentState.validate()
                          && otp1Controller.text.isNotEmpty && otp2Controller.text.isNotEmpty
                          && otp3Controller.text.isNotEmpty && otp4Controller.text.isNotEmpty
                          && otp5Controller.text.isNotEmpty && otp6Controller.text.isNotEmpty
                      ){
                        setState(() {
                          otp = otp1Controller.text.trim() +
                              otp2Controller.text.trim() + otp3Controller.text.trim() + otp4Controller.text.trim()
                              + otp5Controller.text.trim() + otp6Controller.text.trim();
                        });

                        await verificationController.getVerifyOtp(otp, widget.verificationId, widget.phone, widget.name, null);
                      }
                      else {
                        // return Fluttertoast.showToast(
                        //     msg: translator.translate('Please_enter_valid_otp'),
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.BOTTOM,
                        //     timeInSecForIosWeb: 1,
                        //     fontSize: 16.0);
                      }
                      return null;
                    },
                  ),
                  //------------------- Resend-------------------//
                  InkWell(
                    onTap: () async {
                      if(isEnable) {
                        setState(() {
                          isEnable = false;
                        });
                        startTimer();
                        verificationController.resendOtp(widget.phone);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isEnable ? AppTheme.blackColor : AppTheme.blackColor.withOpacity(0.5)
                        ),
                      ),
                    ),
                  ),
                  //--------------resend after few second ---------------//
                  !isEnable ? Text("after $_start seconds",
                    style: TextStyle(
                      color: AppTheme.blackColor,
                      fontSize: 15.0,
                    ),
                  ) : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
