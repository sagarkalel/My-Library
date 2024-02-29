import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget verGap() {
  return SizedBox(
    height: 15.h,
  );
}

Widget horGap() {
  return SizedBox(
    width: 15.w,
  );
}

void navigate(context, var page) {
  Navigator.push(context, MaterialPageRoute(builder: (builder) {
    return page;
  }));
}

void navigateSlide(context, var page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        _,
        __,
        ___,
      ) =>
          page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Specify the starting position
            end: Offset.zero, // Specify the ending position
          ).animate(animation),
          child: child,
        );
      },
    ),
  );
}

void navigateSlideUntil(context, var page) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        _,
        __,
        ___,
      ) =>
          page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Specify the starting position
            end: Offset.zero, // Specify the ending position
          ).animate(animation),
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

Widget longButton({
  required onPressed,
  required String text,
  bool isLoading = false,
  icon = Icons.logout,
  bool isIcon = false,
  required width,
}) {
  return SizedBox(
    height: 40.h,
    width: width,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.black38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(color: Colors.white),
                ),
                horGap(),
              ],
            ),
          if (isIcon)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.sp,
                ),
                horGap(),
              ],
            ),
          Text(
            text,
            style: GoogleFonts.lora(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

void navigateScale(context, page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 50),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    ),
  );
}

void navigateScaleUntil(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    ),
    (route) => false,
  );
}

void showDialogCustom(
  context, {
  required onPressed,
  required rightPadding,
  required content,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: rightPadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.amber,
                      size: 75.sp,
                    ),
                    Text(
                      "Attention!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    ),
                    verGap(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    verGap(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Hero(
                          tag: "cancel",
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.lora(
                                    color: Colors.white, fontSize: 16.sp),
                              )),
                        ),
                        Container(
                          width: 1.w,
                          height: 35.h,
                          color: Colors.grey,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r))),
                            onPressed: onPressed,
                            child: Text(
                              "Confirm",
                              style: GoogleFonts.lora(
                                  color: Colors.white, fontSize: 16.sp),
                            )),
                      ],
                    ),
                    verGap(),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}

Widget floatingActionCustomButton(
    {required onPressed, required text, required icon}) {
  return FloatingActionButton.extended(
    backgroundColor: const Color.fromARGB(255, 235, 116, 69),
    onPressed: onPressed,
    foregroundColor: Colors.white,
    label: Text(text),
    icon: Icon(icon),
  );
}

Widget textField({
  required String hintText,
  required IconData icon,
  required TextInputType inputType,
  required int maxLines,
  required TextEditingController controller,
  bool inputFormatterNumber = false,
  bool readOnly = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: TextFormField(
      cursorColor: Colors.orange,
      readOnly: readOnly,
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      style: GoogleFonts.lora(
          fontSize: 18.sp, fontWeight: FontWeight.w400, color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.orange),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.lora(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400),
          alignLabelWithHint: true,
          fillColor: Colors.orange.shade50,
          filled: true),
      inputFormatters: inputFormatterNumber
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : [],
    ),
  );
}

Widget emptyList({required String content}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
                offset: const Offset(4, 4),
                color: Colors.red.shade100,
                blurRadius: 3)
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 22.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget searchWidget({
  required onChange,
  required content,
  required controller,
  required focusNode,
  required suffix,
}) {
  return SizedBox(
    height: 40.h,
    child: TextFormField(
      autofocus: true,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChange,
      decoration: InputDecoration(
        fillColor: Colors.orange.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 10.w, // Adjust the vertical padding as needed
        ),
        suffixIcon: suffix,
        hintText: content,
      ),
      style: GoogleFonts.lora(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
    ),
  );
}

Country selectedCountryCode = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "");
