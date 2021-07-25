
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/controller/loading_controller.dart';
import 'package:practical_assignment/firebase/user_repository.dart';
import 'package:practical_assignment/model/product_model.dart';
import 'package:practical_assignment/screen/dashboard/dashboard_controller.dart';

class HomeController extends LoadingController {

  RxList<ProductModel> listOfProduct = new RxList<ProductModel>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DashboardController dashboardController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    getProducts();
    super.onInit();
  }


  void getProducts() {
    UserRepository().getAllproductList().then((value) async {
      listOfProduct(value);
    });
  }

  void doLike(String productId) async {
    User _firebaseUser = _firebaseAuth.currentUser;
    CollectionReference _likeReference = FirebaseFirestore.instance.collection('Users').doc(_firebaseUser.uid).collection("like");

    await _likeReference.doc(productId).get().then((value) async {
      if(!value.exists) {
        await _likeReference.doc(productId).set({'productId': productId});
        update();
        getProducts();
      } else {
        await _likeReference.doc(productId).delete();
        update();
        getProducts();
      }
    });
    update();
  }

  void doCart(String productId) async {
    User _firebaseUser = _firebaseAuth.currentUser;
    CollectionReference _cartReference = FirebaseFirestore.instance.collection('Users').doc(_firebaseUser.uid).collection("cart");

    await _cartReference.doc(productId).get().then((value) async {
      if(!value.exists) {
        await _cartReference.doc(productId).set({'productId': productId});
        dashboardController.getCartData();
        update();
        getProducts();
      } else {
        await _cartReference.doc(productId).delete();
        dashboardController.getCartData();
        update();
        getProducts();
      }
    });
  }

}