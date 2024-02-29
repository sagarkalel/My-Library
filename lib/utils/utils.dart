import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_library/styles/styles.dart';

void showSnackBar(
  BuildContext context,
  String content, {
  bool done = false,
  bool error = false,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (done)
            const Icon(
              Icons.offline_pin_rounded,
              color: Colors.green,
            ),
          if (error)
            const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Text(
              content,
              style: Styles.normalStyle,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 246, 214, 166),
    ),
  );
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(
      context,
      e.toString(),
    );
  }
  return image;
}
