

import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {

  void showLoading() {
    SVProgressHUD.show();
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear);
  }

  void dismissLoading() {
    SVProgressHUD.dismiss();
  }
}