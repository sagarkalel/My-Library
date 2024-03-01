import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/utils/styles.dart';
import '../../provider/sub_book_provider.dart';

class BookIssuedAllUsers extends StatefulWidget {
  const BookIssuedAllUsers({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.profilePic,
    required this.userRef,
    required this.uid,
  });
  final String name;
  final String phoneNumber;
  final String profilePic;
  final String userRef;
  final String uid;

  @override
  State<BookIssuedAllUsers> createState() => _BookIssuedAllUsersState();
}

class _BookIssuedAllUsersState extends State<BookIssuedAllUsers> {
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.w),
        decoration: BoxDecoration(
            // color: const Color.fromARGB(255, 244, 252, 255),
            color: Colors.blue.shade100,
            // color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(6, 6),
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6)
            ]),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white54,
              ),
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Container(
                height: 95.h,
                width: 90.w,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.profilePic,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "(${widget.phoneNumber})",
                    overflow: TextOverflow.ellipsis,
                    style: Styles.smallText,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current borrowed:",
                    style: GoogleFonts.lora(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    currentIssuedBooks.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      fontSize: 15.sp,
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
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    totalIssuedBooks.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
