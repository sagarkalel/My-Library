import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/app_state/app_state.dart';
import 'package:my_library/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/sub_book_provider.dart';
import '../../styles/components.dart';
import '../../styles/styles.dart';
import 'issued_books.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({
    super.key,
    required this.name,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
    required this.isUser,
  });
  final String name;
  final String phoneNumber;
  final String profilePic;
  final String uid;
  final bool isUser;

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  void initState() {
    super.initState();

    DocumentReference<Object?> userReference =
        FirebaseFirestore.instance.collection('users').doc(widget.uid);
    if (widget.isUser) {
      UserRepository().getSubBooksCurrentCountUnderUser(userReference).then(
        (count) {
          AppState().currentIssuedBooks = count;

          debugPrint(
              'SubBooks current count for the user from AppState : ${AppState().currentIssuedBooks}');
          setState(() {});
        },
      );
    }
    if (widget.isUser) {
      UserRepository()
          .getSubBooksTotalCountUnderUser(userReference)
          .then((value) {
        AppState().totalIssuedBooks = value;
        debugPrint('SubBooks current count for the user: $value');
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    DocumentReference<Object?> userReference =
        FirebaseFirestore.instance.collection('users').doc(ap.userModel.uid);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.blue.shade400),
          boxShadow: [
            BoxShadow(
                offset: const Offset(6, 6),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.03)),
            BoxShadow(
                offset: const Offset(-6, -6),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.03))
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        child: Column(
          children: [
            Text(
              "My Library",
              style: GoogleFonts.lora(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            verGap(),
            Container(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.4),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  children: [
                    verGap(),
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 224, 168),
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.profilePic,
                            ),
                            fit: BoxFit.cover),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: widget.profilePic != ''
                          ? null
                          : const Icon(
                              Icons.person_2_outlined,
                              size: 50,
                              color: Colors.black12,
                            ),
                    ),
                    verGap(),
                    verGap(),
                    Text(
                      widget.name,
                      style: Styles.normalStyle,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "(${widget.phoneNumber})",
                      style: Styles.smallText,
                    ),
                  ],
                ),
              ),
            ),
            verGap(),
            if (ap.userModel.userType == "user")
              purpleButton(
                AppState().currentIssuedBooks == 0
                    ? () {
                        Navigator.pop(context);
                        showSnackBar(context,
                            "You don't have any issued book currently!");
                      }
                    : () {
                        // Navigator.pop(context);
                        navigateSlide(
                          context,
                          IssuedBooks(
                            fromPage: "current",
                            userReference: userReference,
                          ),
                        );
                      },
                "Current issued books: ",
                AppState().currentIssuedBooks,
              ),
            if (ap.userModel.userType == "user")
              purpleButton(
                AppState().totalIssuedBooks == 0
                    ? () {
                        Navigator.pop(context);
                        showSnackBar(
                            context, "Still you have not issued any book!");
                      }
                    : () {
                        // Navigator.pop(context);
                        navigateSlide(
                          context,
                          IssuedBooks(
                            fromPage: "total",
                            userReference: userReference,
                          ),
                        );
                      },
                "Total issued books: ",
                AppState().totalIssuedBooks,
              ),
          ],
        ),
      ),
    );
  }

  Widget purpleButton(
    onPressed,
    title,
    number,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          backgroundColor: const Color.fromARGB(255, 248, 209, 255),
          disabledBackgroundColor: const Color.fromARGB(255, 248, 209, 255),
          disabledForegroundColor: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // "Current issued books: ",
              title,
              style: GoogleFonts.lora(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              number.toString(),
              style: GoogleFonts.lora(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
