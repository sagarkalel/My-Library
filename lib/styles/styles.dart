import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle normalStyle = GoogleFonts.lora(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      decoration: TextDecoration.none);
  static TextStyle normalStyleBold = GoogleFonts.lora(
      fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black);

  static TextStyle title = GoogleFonts.ibmPlexSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      decoration: TextDecoration.none);
  static TextStyle title2 = GoogleFonts.ibmPlexSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle smallText = GoogleFonts.lora(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black54);

  static TextStyle smallText2 = GoogleFonts.lora(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle descrption = GoogleFonts.lora(
      fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle textfild = GoogleFonts.lora(
      fontSize: 22.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle textfildHint = GoogleFonts.lora(
      fontSize: 22.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade400);
}
