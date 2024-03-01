// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/screens/susscessfully_registered/successfully_registered.dart';
import 'package:my_library/screens/user_info/create_account.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import 'pincode_otp.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpValue;
  final FocusNode _focusNode = FocusNode();
  int start = 59;
  int resendLoader = 0;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    startTimer();
    start = 59;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formattedNumber = start.toString().padLeft(2, '0');
    final isLoading =
        Provider.of<MyAuthProvider>(context, listen: true).isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SizedBox(
              height: double.infinity,
              width: MediaQuery.of(context).size.width - 30.w,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      color: Colors.orange,
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const SizedBox(
                          //   height: 50,
                          // ),

                          Container(
                            height: 250.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.shade50),
                            child: Icon(
                              Icons.sms_rounded,
                              size: 180.sp,
                              color: const Color.fromARGB(255, 246, 206, 137),
                            ),
                          ),
                          verGap(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.h),
                            child: Column(
                              children: [
                                Text(
                                  'Verification',
                                  style: Styles.title,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Enter then OTP sent to your registered phone number.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lora(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          OtpPincode(
                            onChange: (value) {
                              otpValue = value;
                              setState(() {});
                            },
                            pinCodeController: pinCodeController,
                          ),

                          Hero(
                            tag: "saved_data",
                            child: longButton(
                                onPressed: () async {
                                  final ConnectivityResult connectivityResult =
                                      await Connectivity().checkConnectivity();

                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    showSnackBar(context,
                                        "Please check your interent connection!");
                                  } else {
                                    !(otpValue!.length <= 5 || otpValue == null)
                                        ? verifyOtp(context, otpValue!,
                                            widget.phoneNumber)
                                        : showSnackBar(context,
                                            "Please enter 6-Digit OTP");
                                  }

                                  // navigateScale(context, const HomePage());
                                },
                                text: isLoading == true
                                    ? "Verifying..."
                                    : 'Verify',
                                width: MediaQuery.of(context).size.width - 50.w,
                                isLoading: isLoading),
                          ),
                          verGap(),
                          verGap(),
                          Text(
                            "Didn't receive any code?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black38),
                          ),
                          verGap(),
                          !(start == 0 || start == 59)
                              ? RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: '  resend code in ',
                                        style: Styles.normalStyle),
                                    TextSpan(
                                      text:
                                          " 00:${formattedNumber = formattedNumber}  ",
                                      style: GoogleFonts.lora(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: const Color.fromARGB(
                                            255, 62, 104, 137),
                                      ),
                                    ),
                                  ]),
                                )
                              : InkWell(
                                  onTap: !(start == 0 || start == 59)
                                      ? null
                                      : () {
                                          reSendOtp(widget.phoneNumber);
                                          resendLoader = 1;
                                          setState(() {});
                                        },
                                  child: Text(
                                    "Resend",
                                    style: GoogleFonts.lora(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      color: const Color.fromARGB(
                                          255, 62, 104, 137),
                                    ),
                                  ),
                                ),
                          verGap(),
                          if (resendLoader == 1)
                            SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ),
                          if (resendLoader == 2)
                            Icon(
                              Icons.download_done_sharp,
                              color: Colors.orange,
                              size: 24.sp,
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void reSendOtp(phoneNumber) async {
    // final ap = Provider.of<MyAuthProvider>(context, listen: false);
    // String phoneNumber = phoneController.text.trim();
    resendOtp(context, phoneNumber);
  }

  void verifyOtp(BuildContext context, String userOtp, String phoneNumber) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        //first will check whether user is exist in database or not
        ap.checkExistingUser().then((value) async {
          if (value == true) {
            //user exists in our app

            ap.getUserDataFromFirestore().then(
                  (value) => ap.saveUserDataToSP().then(
                        (value) => ap.setSignIn().then(
                              (value) => navigateScaleUntil(
                                context,
                                const Registered(),
                              ),
                            ),
                      ),
                );
          } else {
            // new user
            navigateSlideUntil(
                context,
                CreateAccountScren(
                  phoneNumber: phoneNumber,
                ));
          }
        });
      },
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // String formattedNumber = start.toString().padLeft(2, '0');

    Timer.periodic(onsec, (timer) {
      if (start == 0) {
        if (mounted) {
          // setState(() {
          //   isResend = false;
          // });
          timer.cancel();
        }
      } else if (mounted) {
        setState(() {
          start--;
        });
      }
    });
  }

  void resendOtp(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            debugPrint(widget.phoneNumber);
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
            setState(() {
              resendLoader = 0;
            });
            // isResend = false;
            // notifyListeners();
          },
          verificationFailed: (error) {
            // _isLoading = false;
            // notifyListeners();
            setState(() {
              resendLoader = 0;
            });
            debugPrint(widget.phoneNumber);
            throw Exception(error.message);
          },
          codeSent: ((verificationId, forceResendingToken) {
            debugPrint(widget.phoneNumber);
            setState(() {
              pinCodeController.text = '';
              startTimer();
              start = 59;
              resendLoader = 2;
              resendLoaderDelay();
            });
            // _isLoading = false;
            // notifyListeners();
            debugPrint('otp sent successfully');
          }),
          codeAutoRetrievalTimeout: (verificationId) {
            // _isLoading = false;
            // notifyListeners();
            setState(() {
              resendLoader = 0;
            });
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
      debugPrint(widget.phoneNumber);
      setState(() {
        resendLoader = 0;
      });
      // _isLoading = false;
      // notifyListeners();
    }
  }

  void resendLoaderDelay() {
    Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {
          resendLoader = 0;
        }));
  }
}
