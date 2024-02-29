import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/styles/styles.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import 'phone_num_input_container.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final FocusNode _focusNode = FocusNode();
  bool loading = false;
  final TextEditingController phoneNumberController = TextEditingController();
  String phone = '';
  bool isResend = false;
  int start = 59;
  bool firstSend = false;
  int lengthOfNum = 0;

  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SizedBox(
              width: double.infinity,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const SizedBox(
                          //   height: 60,
                          // ),
                          Container(
                            height: 250.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.shade50),
                            child: Icon(
                              Icons.phone_android,
                              size: 190.sp,
                              color: const Color.fromARGB(255, 246, 206, 137),
                            ),
                          ),
                          verGap(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0.w,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Register',
                                  style: Styles.title,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Add your phone number here, we'll send you a verification code.",
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
                            height: 40.h,
                          ),
                          PhoneInputContainer(
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                                lengthOfNum = phone.length;
                                phoneController.text = value;
                              });
                            },
                            onSend:
                                (start == 59 || start == 0) && lengthOfNum == 10
                                    ? () async {
                                        onSend();
                                      }
                                    : null,
                            firstSend: firstSend,
                            start: start,
                            lengthOfNum: lengthOfNum,
                            controller: phoneController,
                          ),
                          verGap(),
                          if (firstSend)
                            Row(
                              children: [
                                horGap(),
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    color: Colors.grey,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: '  resend code in ',
                                        style: Styles.normalStyle),
                                    TextSpan(
                                        text:
                                            " 00:${formattedNumber = formattedNumber}  ",
                                        style: GoogleFonts.lora(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            color: const Color.fromARGB(
                                                255, 62, 104, 137)))
                                  ]),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    color: Colors.grey,
                                  ),
                                ),
                                horGap(),
                              ],
                            ),
                          verGap(),

                          longButton(
                            onPressed: () async {
                              final ConnectivityResult connectivityResult =
                                  await Connectivity().checkConnectivity();

                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                showSnackBar(context,
                                    "Please check your interent connection!");
                              } else {
                                (phoneController.text.trim().length <= 9)
                                    ? showSnackBar(context,
                                        "Please enter 10-Digit phone Number")
                                    : sendOtp(phoneController.text.trim());
                              }
                            },
                            isLoading: isLoading,
                            text: isLoading == true ? "Sending..." : 'Send OTP',
                            width: MediaQuery.of(context).size.width - 50.w,
                          ),
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

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // String formattedNumber = start.toString().padLeft(2, '0');

    Timer.periodic(onsec, (timer) {
      if (start == 0) {
        if (mounted) {
          setState(() {
            isResend = false;
          });
          timer.cancel();
        }
      } else if (mounted) {
        setState(() {
          start--;
        });
      }
    });
  }

  void onSend() async {
    startTimer();
    start = 59;
    isResend = true;
    firstSend = true;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '{+91$phone}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        startTimer();
        start = 59;
        firstSend = true;
        isResend = true;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    setState(() {});
    // navigateScale(context, const HomePage());
  }

  void sendOtp(phoneNumber) async {
    FocusScope.of(context).requestFocus(_focusNode);
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    // String phoneNumber = phoneController.text.trim();

    ap.signInWithPhone(
        context, "+${selectedCountryCode.phoneCode}$phoneNumber");
  }
}
