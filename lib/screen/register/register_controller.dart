

import 'package:firebase_auth/firebase_auth.dart';
import 'package:practical_assignment/common/controller/loading_controller.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/function/common_function.dart';
import 'package:practical_assignment/common/utils/shared_preference_helper.dart';
import 'package:practical_assignment/firebase/user_repository.dart';
import 'package:practical_assignment/screen/dashboard/dashboard_screen.dart';
import 'package:practical_assignment/screen/verification_phone/verification_phone_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends LoadingController {
  var fcmToken = "".obs;
  var obscureTextLogin = true.obs;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerInApp(String name, String email, String password, {Function failed}) async {
    showLoading();

    UserRepository().register(name, email, password, fcmToken.value).then((User user){
      dismissLoading();
      if (user != null) {
        Get.offAll(() => DashboardScreen());
      }
    }).catchError((e) {
      dismissLoading();
      showToast(e.message);
    });

  }

  void passwordShow(bool show) {
    if(show) {
      obscureTextLogin(false);
    } else {
      obscureTextLogin(true);
    }
  }

  void getToken() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    fcmToken = sharedPrefs.getString(SharedPreferenceHelper.fcmToken).obs;
  }

  void signInWithPhone(String phoneNumber, String name) async {
    showLoading();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
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
        print('codeSent');
        dismissLoading();
        Get.offAll(() => VerificationPhoneScreen(phoneNumber, verificationId, name: name,));
        showToast("OTP has been sent to your phone number.");
      },
    );
  }
}