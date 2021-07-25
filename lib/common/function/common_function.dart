
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String value) {
  Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3);
}