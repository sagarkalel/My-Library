import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBooksUser extends StatelessWidget {
  const AllBooksUser({
    super.key,
    required this.bookName,
    required this.writerName,
    required this.bookId,
    this.description,
    required this.isAvailable,
    required this.color,
    this.numberOfBooks = 0,
    required this.isAdmin,
  });
  final String bookName;
  final bool isAvailable;
  final String writerName;
  final String bookId;
  final String? description;
  final Color color;
  final int numberOfBooks;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 15.w, right: 15.w, top: 6.h),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
            // color: color,
            color: Colors.amber.shade100,
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
                  Icon(
                    Icons.qr_code_2,
                    color: const Color.fromARGB(135, 89, 1, 1),
                    size: 90.sp,
                  ),
                  Container(
                    color: Colors.orange,
                    height: 80,
                    width: 1.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Book:",
                              style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                bookName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Book ID:",
                              style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                bookId,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Auther:",
                              style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                writerName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Availability:",
                              style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                isAvailable
                                    ? (isAdmin)
                                        ? "Available ($numberOfBooks)"
                                        : "Available"
                                    : "Not Available",
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.lora(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
