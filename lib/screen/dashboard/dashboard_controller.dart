
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practical_assignment/common/controller/loading_controller.dart';
import 'package:get/get.dart';

class DashboardController extends LoadingController {

  var currentIndex = 0.obs;
  var cart = 0.obs;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    getCartData();
    super.onInit();
  }

  void onTabTapped(int index) {
    currentIndex(index);
  }

  void getCartData() async {
    User _firebaseUser = _firebaseAuth.currentUser;
    CollectionReference _cartReference = FirebaseFirestore.instance.collection('Users').doc(_firebaseUser.uid).collection("cart");

    await _cartReference.get().then((value) {
      if(value != null) {
        cart(value.docs.length);
      }
    });
  }
}