import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/screens/phone_auth/phone_auth_page.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 35.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.width - 150.w,
                    width: MediaQuery.of(context).size.width - 30.w,
                    child: Image.network(
                        "https://www.easydotstechno.com/Data/img/lib.png")),
                verGap(),
                Text(
                  "Let's get started",
                  style: Styles.title,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Never a better time that now to start.",
                  style: GoogleFonts.lora(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38),
                ),
                SizedBox(
                  height: 40.h,
                ),
                longButton(
                  onPressed: () {
                    navigateSlide(
                      context,
                      const PhoneAuthPage(),
                    );
                  },
                  text: "Get started",
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
