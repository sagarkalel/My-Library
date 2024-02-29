import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/screens/home_page/user_profile_card.dart';
import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/susscessfully_registered/splash_screen.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  @override
  const MenuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    return Drawer(
      elevation: 16,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 100.h,
            ),
            UserProfileCard(
              isUser: ap.userModel.userType == "user" ? true : false,
              name: ap.userModel.name,
              uid: ap.uid,
              phoneNumber: ap.userModel.phoneNumber,
              profilePic: ap.userModel.profilePic,
            ),
            SizedBox(
              height: 50.h,
            ),
            Hero(
              tag: "cancel",
              child: longButton(
                onPressed: () {
                  showDialogCustom(context,
                      content: "Do you really want to logout ?",
                      rightPadding: MediaQuery.of(context).size.width * 0.25,
                      onPressed: () {
                    ap.userSignOut().then(
                          (value) => navigateScaleUntil(
                            context,
                            const SplashScreen(),
                          ),
                        );
                    Navigator.pop(context);
                  });
                },
                text: 'Logout',
                isIcon: true,
                width: MediaQuery.of(context).size.width - 50.w,
              ),
            ),
            const Spacer(),
            Text(
              'My Library v1',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Designed&Developed by: SagarHaridasKalel',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 208, 134, 23),
              ),
            )
          ],
        ),
      ),
    );
  }
}
