import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/components.dart';

import '../provider/sub_book_provider.dart';

class FromBookUserInfo extends StatefulWidget {
  const FromBookUserInfo({
    super.key,
    required this.name,
    required this.profilePic,
    required this.phoneNumber,
    required this.uid,
  });
  final String name;
  final String profilePic;
  final String phoneNumber;
  final String uid;

  @override
  State<FromBookUserInfo> createState() => _FromBookUserInfoState();
}

class _FromBookUserInfoState extends State<FromBookUserInfo> {
  int currentIssuedBooks = 0;
  int totalIssuedBooks = 0;

  @override
  void initState() {
    super.initState();

    DocumentReference<Object?> userReference =
        FirebaseFirestore.instance.collection('users').doc(widget.uid);
    UserRepository().getSubBooksCurrentCountUnderUser(userReference).then(
      (count) {
        currentIssuedBooks = count;
        debugPrint('SubBooks total count for the user: $count');
        setState(() {});
      },
    );
    UserRepository()
        .getSubBooksTotalCountUnderUser(userReference)
        .then((value) {
      totalIssuedBooks = value;
      debugPrint('SubBooks current count for the user: $value');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      child: Container(
        width: MediaQuery.of(context).size.width - 30.w,
        decoration: BoxDecoration(
            // color: const Color.fromARGB(255, 144, 217, 249),
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(4, 4),
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8)
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white54,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          height: 85.h,
                          width: 85.w,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.rectangle,
                            // borderRadius: BorderRadius.circular(10.r),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                bottomLeft: Radius.circular(10.r)),
                            image: DecorationImage(
                              image: NetworkImage(widget.profilePic),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        horGap(),
                        Container(
                          height: 85.h,
                          width: 1,
                          color: Colors.white54,
                        ),
                        horGap(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Name:",
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  widget.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Phone no:",
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "(${widget.phoneNumber})",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Current borrowed:",
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "$currentIssuedBooks",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total borrowed:",
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "$totalIssuedBooks",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
