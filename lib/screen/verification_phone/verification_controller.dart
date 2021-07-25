
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/controller/loading_controller.dart';
import 'package:practical_assignment/common/function/common_function.dart';
import 'package:practical_assignment/firebase/user_repository.dart';
import 'package:practical_assignment/screen/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationController extends LoadingController {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getVerifyOtp(String otp, String verificationId, String phone, String name, AuthCredential credential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showLoading();
    if(name != null) {
      UserRepository().signUpWithMobile(otp, verificationId, phone, name, credential).then((value) {
        if (value.uid != null) {
          dismissLoading();
          Get.offAll(DashboardScreen());
        }
      }).catchError((e) {
        dismissLoading();
        showToast(e.message);
      });
    } else {
      UserRepository().signInWithMobile(otp, verificationId, phone).then((value) {
        if (value.uid != null) {
          dismissLoading();
          Get.offAll(DashboardScreen());
        }
      }).catchError((e) {
        dismissLoading();
        showToast(e.message);
      });
    }

  }


  void resendOtp(String phoneNumber) async {
    showLoading();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        dismissLoading();
        print("Phone:- $credential");
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        } else if (e.code == "too-many-requests") {
          showToast(e.message);
        }
        dismissLoading();
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, [int code]) {
        dismissLoading();
        print('codeSent');
        showToast("OTP has been sent to your phone number.");
      },
    );
  }
}