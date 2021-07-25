
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical_assignment/common/function/common_function.dart';
import 'package:practical_assignment/common/utils/shared_preference_helper.dart';
import 'package:practical_assignment/model/product_model.dart';
import 'package:practical_assignment/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _firebaseUser;
  CollectionReference _userCollectionReference = FirebaseFirestore.instance.collection('Users');
  CollectionReference _productCollectionReference = FirebaseFirestore.instance.collection('Product');
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<User> register(String name, String email, String password, String fcmToken) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {

      UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebaseUser = authResult.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      UserProfile _userObj = new UserProfile(
        userId: _firebaseUser.uid,
        name: name,
        email: email,
        mobileNumber: "",
        fcmToken: fcmToken,
      );

      Map<String,dynamic> map = _userObj.toJson();
      await _userCollectionReference
          .doc(_firebaseUser.uid)
          .set(map)
          .then((result) => {debugPrint("Success")})
          .catchError((onError) => {debugPrint(onError.toString())});

      await _userCollectionReference.doc(_firebaseUser.uid).get().then((docSnap) {

        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

        prefs.setString(SharedPreferenceHelper.userId, data.containsKey('userId') ? data['userId'].toString() : "");
        prefs.setString(SharedPreferenceHelper.name, data.containsKey('name')? data['name'].toString() : "");
        prefs.setString(SharedPreferenceHelper.gender, data.containsKey('gender')  ? data['gender'].toString() : "");
        prefs.setString(SharedPreferenceHelper.age, data.containsKey('age')  ? data['age'].toString() : "");
        prefs.setString(SharedPreferenceHelper.mobileNumber, data.containsKey('mobileNumber')  ? data['mobileNumber'].toString() : "");
        prefs.setString(SharedPreferenceHelper.email, data.containsKey('email') ? data['email'].toString() : "");
        prefs.setString(SharedPreferenceHelper.dob, data.containsKey('dob') ? data['dob'].toString() : "");
        prefs.setString(SharedPreferenceHelper.profileImage, data.containsKey('profileImage') ? data['profileImage'].toString() : "");

      });

      await SharedPreferenceHelper.setLogin("true");
    } else {
      print("No internet connection");
    }

    return _firebaseAuth.currentUser;
  }

  Future<User> login(String email, String password) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {

      UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _firebaseUser = authResult.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await _userCollectionReference.doc(_firebaseUser.uid).get().then((docSnap) {

        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

        prefs.setString(SharedPreferenceHelper.userId, data.containsKey('userId') ? data['userId'].toString() : "");
        prefs.setString(SharedPreferenceHelper.name, data.containsKey('name')? data['name'].toString() : "");
        prefs.setString(SharedPreferenceHelper.gender, data.containsKey('gender')  ? data['gender'].toString() : "");
        prefs.setString(SharedPreferenceHelper.age, data.containsKey('age')  ? data['age'].toString() : "");
        prefs.setString(SharedPreferenceHelper.mobileNumber, data.containsKey('mobileNumber')  ? data['mobileNumber'].toString() : "");
        prefs.setString(SharedPreferenceHelper.email, data.containsKey('email') ? data['email'].toString() : "");
        prefs.setString(SharedPreferenceHelper.dob, data.containsKey('dob') ? data['dob'].toString() : "");
        prefs.setString(SharedPreferenceHelper.profileImage, data.containsKey('profileImage') ? data['profileImage'].toString() : "");
      });

      await SharedPreferenceHelper.setLogin("true");

    } else {
      showToast("Please check your internet connections!!!");
    }

    return _firebaseAuth.currentUser;
  }

  Future<User> signUpWithMobile(String otp, String verificationId, String phone,
      String name, AuthCredential credential) async {

//    if(type.toLowerCase() == "manual") {
      UserCredential authResult;
      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp,)).then((value) {
        if(value != null) {
          authResult = value;
        }
      }).catchError((e) {
        if(e.code == "invalid-verification-code") {
          showToast('Invalid Otp! Please enter valid otp');
        } else if(e.code == "invalid-verification-id") {
          showToast('Please try again after sometimes!');
        }
      });


      if(authResult != null) {
        _firebaseUser = authResult.user;
      }
//    }

//    else
//    {
//      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
//      _firebaseUser = authResult.user;
//    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String fcmToken = await _fcm.getToken();

    print("Document is not exist");
    UserProfile _userObj = new UserProfile(
      userId: _firebaseUser.uid,
      name: name,
      mobileNumber: phone,
      email: "",
      fcmToken: "",
    );

    await _userCollectionReference
        .doc(_firebaseUser.uid)
        .set(_userObj.toJson())
        .then((result) => {debugPrint("Success")})
        .catchError((onError) => {debugPrint(onError.toString())});

    await _userCollectionReference.where("mobileNumber",isEqualTo: phone).get().then((value) async {
      if(value.docs.isNotEmpty){
        print("Document is exist");
        await _userCollectionReference.doc(_firebaseUser.uid).get().then((docSnap) {
          prefs.setString(SharedPreferenceHelper.userId, _firebaseUser.uid);
          prefs.setString(SharedPreferenceHelper.name, name);
          prefs.setString(SharedPreferenceHelper.age, "");
          prefs.setString(SharedPreferenceHelper.gender, "");
          prefs.setString(SharedPreferenceHelper.mobileNumber, phone);
          prefs.setString(SharedPreferenceHelper.email, "");
        });
        await SharedPreferenceHelper.setLogin("true");
        showToast("Successfully register");

      } else {
        print("Document is not exist");
        showToast("You are not registered yet!!!");
      }
    });

    return _firebaseAuth.currentUser;
  }

  Future<User> signInWithMobile(String otp, String verificationId, String phone) async {
    UserCredential authResult;
    await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp,)).then((value) {
      if(value != null) {
        authResult = value;
      }
    }).catchError((e) {
      if(e.code == "invalid-verification-code") {
        showToast('Invalid Otp! Please enter valid otp');
      } else if(e.code == "invalid-verification-id") {
        showToast('Please try again after sometimes!');
      }
    });
    if(authResult != null) {
      _firebaseUser = authResult.user;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String fcmToken = await _fcm.getToken();
    // await _userCollectionReference.doc(_firebaseUser.uid).get().then((value) async {
    //   if(value.exists){
    await _userCollectionReference.where("mobileNumber",isEqualTo: phone).get().then((value) async {
      if(value.docs.isNotEmpty){
        print("Document is exist");

        // await _userCollectionReference
        //     .doc(_firebaseUser.uid)
        //     .update({'fcm_token': fcmToken})
        //     .then((result) => {debugPrint("Successfully updated token")})
        //     .catchError((onError) => {debugPrint(onError.toString())});
        await _userCollectionReference.where("userId",isEqualTo: _firebaseUser.uid).get().then((docSnap) {

          Map<String, dynamic> data = docSnap.docs[0].data() as Map<String, dynamic>;

          //await _userCollectionReference.doc(_firebaseUser.uid).get().then((docSnap) {
          prefs.setString(SharedPreferenceHelper.userId, data.containsKey('userId') ? data['userId'].toString() : "");
          prefs.setString(SharedPreferenceHelper.name, data.containsKey('name')? data['name'].toString() : "");
          prefs.setString(SharedPreferenceHelper.gender, data.containsKey('gender')  ? data['gender'].toString() : "");
          prefs.setString(SharedPreferenceHelper.age, data.containsKey('age')  ? data['age'].toString() : "");
          prefs.setString(SharedPreferenceHelper.mobileNumber, data.containsKey('mobileNumber')  ? data['mobileNumber'].toString() : "");
          prefs.setString(SharedPreferenceHelper.email, data.containsKey('email') ? data['email'].toString() : "");
          prefs.setString(SharedPreferenceHelper.dob, data.containsKey('dob') ? data['dob'].toString() : "");
          prefs.setString(SharedPreferenceHelper.profileImage, data.containsKey('profileImage') ? data['profileImage'].toString() : "");

        });
        await SharedPreferenceHelper.setLogin("true");
        showToast("Successfully login");

      } else {
        print("Document is not exist");
        showToast("You are not registered yet!!!");
        // UserProfile _userObj = new UserProfile(
        //   userId: _firebaseUser.uid,
        //   firstName: "",
        //   email: "",
        //   mobile : phone,
        //   fcmToken: fcmToken,
        //   notificationStatus: "true",
        //   type: "doctor",
        // );
        // await _userCollectionReference
        //     .doc(_firebaseUser.uid)
        //     .set(_userObj.toJson())
        //     .then((result) => {debugPrint("Success")})
        //     .catchError((onError) => {debugPrint(onError.toString())});
      }
    });

    return _firebaseAuth.currentUser;
  }

  //Update Account Info
  Future<bool> updateMyAccountInfo(String name, String gender, String age,
      String mobile, String email, String dob, XFile image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId;
    String url = "";
    bool success = false;

    _firebaseUser = _firebaseAuth.currentUser;
    userId = _firebaseUser.uid;

    DocumentReference _docReference = _userCollectionReference.doc(userId);

    if (image != null) {
      Reference ref = FirebaseStorage.instance.ref().child(
          '${_firebaseUser.uid}/profile_image/${userId}_profile_image.jpg');
      final UploadTask uploadTask = ref.putFile(File(image.path));
      var downUrl = await ref.getDownloadURL();
      url = downUrl.toString();
      await _docReference.update(
          { 'name': name,
            'gender': gender,
            'age': age,
            'mobileNumber': mobile,
            'email': email,
            'dob': dob,
            'profileImage': url != "" ? url : ""
          }).then((value) async {
        success = true;
        prefs.setString(SharedPreferenceHelper.name, name);
        prefs.setString(SharedPreferenceHelper.gender, gender);
        prefs.setString(SharedPreferenceHelper.age, age);
        prefs.setString(SharedPreferenceHelper.mobileNumber, mobile);
        prefs.setString(SharedPreferenceHelper.email, email);
        prefs.setString(SharedPreferenceHelper.dob, dob);
        prefs.setString(SharedPreferenceHelper.profileImage, url);
      }).catchError((e) {
        success = false;
      });
/*      uploadTask.whenComplete(() async {
        await ref.getDownloadURL().then((value) async {
          url = value;
          await _docReference.update(
              { 'name': name,
                'gender': gender,
                'age': age,
                'mobileNumber': mobile,
                'email': email,
                'dob': dob,
                'profileImage': url != "" ? url : ""
              }).then((value) async {
            success = true;
            prefs.setString(SharedPreferenceHelper.name, name);
            prefs.setString(SharedPreferenceHelper.gender, gender);
            prefs.setString(SharedPreferenceHelper.age, age);
            prefs.setString(SharedPreferenceHelper.mobileNumber, mobile);
            prefs.setString(SharedPreferenceHelper.email, email);
            prefs.setString(SharedPreferenceHelper.dob, dob);
            prefs.setString(SharedPreferenceHelper.profileImage, url);
          }).catchError((e) {
            success = false;
          });
        });

      });*/
    } else {
      await _docReference.update(
          { 'name': name,
            'gender': gender,
            'age': age,
            'mobileNumber': mobile,
            'email': email,
            'dob': dob,
            'profileImage': url != "" ? url : ""
          }).then((value) async {
        success = true;
        prefs.setString(SharedPreferenceHelper.name, name);
        prefs.setString(SharedPreferenceHelper.gender, gender);
        prefs.setString(SharedPreferenceHelper.age, age);
        prefs.setString(SharedPreferenceHelper.mobileNumber, mobile);
        prefs.setString(SharedPreferenceHelper.email, email);
        prefs.setString(SharedPreferenceHelper.dob, dob);
        prefs.setString(SharedPreferenceHelper.profileImage, url);
      }).catchError((e) {
        success = false;
      });
    }

    return success;
  }

  Future signOut() async {
    _firebaseUser = await _firebaseAuth.currentUser;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut().whenComplete(() {
      preferences.clear();
    }).catchError((error) {
      print("Error in singOut:- $error");
    });
  }

  Future<List<ProductModel>> getAllproductList() async {

    _firebaseUser = _firebaseAuth.currentUser;

    CollectionReference _cartReference = _userCollectionReference.doc(_firebaseUser.uid).collection("cart");
    CollectionReference _likeReference = _userCollectionReference.doc(_firebaseUser.uid).collection("like");
    List<ProductModel> productList = new List<ProductModel>();
    List<ProductModel> filteredProductList = new List<ProductModel>();
    _firebaseUser = _firebaseAuth.currentUser;
    var userId = _firebaseUser.uid;
    final result = await _productCollectionReference.get();
    bool like = false;
    bool cart = false;

    result.docs.forEach((element) async {
      try {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        productList.add(
            ProductModel(
                productId: data['productId'],
                productName: data['productName'],
                isLiked: like,
                isCart: cart,
            )
        );
      } catch (e, s) {
        print(s);
      }
    });

    for(int i = 0; i < productList.length; i++) {
      bool like = false;
      bool cart = false;
      await _likeReference.doc(productList[i].productId).get().then((value) {
        if(value.exists) {
          like = true;
        }
      });
      await _cartReference.doc(productList[i].productId).get().then((value) {
        if(value.exists) {
          cart = true;
        }
      });
      filteredProductList.add(
          ProductModel(
              productId: productList[i].productId,
              productName: productList[i].productName,
              isLiked: like,
              isCart: cart
          )
      );
    }
    return filteredProductList;
  }


}