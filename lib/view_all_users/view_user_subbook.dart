import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/components.dart';
import '../styles/styles.dart';

class UsersSubBook extends StatelessWidget {
  const UsersSubBook({
    super.key,
    required this.bookName,
    required this.writerName,
    required this.bookId,
    required this.status,
    required this.color,
    required this.fromDate,
    required this.toDate,
  });
  final String bookName;
  final bool status;
  final String writerName;
  final String bookId;
  final Color color;
  final String fromDate;
  final String toDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 15.w, right: 15.w, top: 6.h),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
            color: color,
            // color:Colors.amber.shade200,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(4, 4),
                  color: Colors.black.withOpacity(0.13),
                  blurRadius: 8)
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Icon(
                    Icons.qr_code_2,
                    color: const Color.fromARGB(135, 89, 1, 1),
                    size: 90.sp,
                  ),
                  Container(
                    color: Colors.orange,
                    height: 80.h,
                    width: 1.w,
                  ),
                  horGap(),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Book:",
                              style: Styles.title2,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                bookName,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.descrption,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Book ID:",
                              style: Styles.title2,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                bookId,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.descrption,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Auther:",
                              style: Styles.title2,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                writerName,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.descrption,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Status:",
                              style: Styles.title2,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            if (status == false)
                              Row(
                                children: [
                                  Container(
                                    height: 25.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Returned",
                                        style: GoogleFonts.lora(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (status == true)
                              Row(
                                children: [
                                  Container(
                                    height: 25.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Owned",
                                        style: GoogleFonts.lora(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
