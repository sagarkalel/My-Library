import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_library/model/user_provider.dart';
import 'package:my_library/screens/phone_auth/otp_screen.dart';
import 'package:my_library/utils/utils.dart';
import 'package:my_library/widgets/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  MyAuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin123") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin123", true);
    _isSignedIn = true;
    notifyListeners();
  }

//sign in
  void signInWithPhone(
    BuildContext context,
    String phoneNumber,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
            _isLoading = false;
            notifyListeners();
          },
          verificationFailed: (error) {
            _isLoading = false;
            notifyListeners();
            throw Exception(error.message);
          },
          codeSent: ((verificationId, forceResendingToken) {
            navigateSlide(
                context,
                OtpScreen(
                  verificationId: verificationId,
                  phoneNumber: phoneNumber,
                ));
            _isLoading = false;
            notifyListeners();
            debugPrint('otp sent successfully');
          }),
          codeAutoRetrievalTimeout: (verificationId) {
            _isLoading = false;
            notifyListeners();
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.toString(),
        error: true,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

// verify otp

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
//user
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        // carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message.toString(),
        error: true,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

//DATABASE OPERATIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      debugPrint("user exists and uid is $_uid");
      return true;
    } else {
      debugPrint("new user $_uid");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
//uploading image to firebase storage
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) => {
            userModel.profilePic = value,
            userModel.createdAt =
                DateTime.now().millisecondsSinceEpoch.toString(),
            userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!,
            userModel.uid = _firebaseAuth.currentUser!.uid,
          });
      _userModel = userModel;

      //uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) => {
                onSuccess(),
                _isLoading = false,
                notifyListeners(),
              });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message.toString(),
        error: true,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

// get data from firestore database
  Future getUserDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        userType: snapshot['userType'],
        profilePic: snapshot['profilePic'],
        createdAt: snapshot['createdAt'],
        phoneNumber: snapshot['phoneNumber'],
        uid: snapshot['uid'],
      );
      _uid = userModel.uid;
    });
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //STORING DATA LOCALLY

  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  //retrieving data from sharedpreference
  Future getUserDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  //logout user
  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
