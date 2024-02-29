import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/model/user_provider.dart';
import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/styles/styles.dart';
import 'package:my_library/susscessfully_registered/successfully_registered.dart';
import 'package:my_library/utils/utils.dart';
import 'package:provider/provider.dart';

class CreateAccountScren extends StatefulWidget {
  const CreateAccountScren({
    super.key,
    required this.phoneNumber,
  });
  final String phoneNumber;
  // final String uid;

  @override
  State<CreateAccountScren> createState() => _CreateAccountScrenState();
}

class _CreateAccountScrenState extends State<CreateAccountScren> {
  final nameController = TextEditingController();
  File? image;
  final FocusNode _focusNode = FocusNode();

  bool isUserTypeUser = true;
  bool isUserTypeAdmin = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<MyAuthProvider>(context, listen: true).isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 80.h,
                  ),
                  InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: image == null
                          ? Container(
                              height: 100.r,
                              width: 100.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.shade200,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(4, 4),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.030)),
                                ],
                              ),
                              child: Icon(
                                Icons.account_circle,
                                size: 50.sp,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              height: 100.r,
                              width: 100.r,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange.shade100,
                                  image: DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(4, 4),
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(0.030)),
                                  ]),
                            )),
                  verGap(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //name field here
                        Row(
                          children: [
                            Text(
                              "  Name:",
                              style: Styles.title2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        textField(
                          hintText: "John Smith",
                          icon: Icons.account_circle,
                          inputType: TextInputType.name,
                          maxLines: 1,
                          controller: nameController,
                        ),
                        //user type here
                        Row(
                          children: [
                            Text(
                              "  User type:",
                              style: Styles.title2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),

                        CheckboxListTile(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r))),
                          tileColor: Colors.orange.shade50,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            'User',
                            style: Styles.normalStyle,
                          ),
                          value: isUserTypeUser,
                          onChanged: (value) {
                            setState(() {
                              isUserTypeUser = value!;
                              if (isUserTypeUser && isUserTypeAdmin) {
                                isUserTypeAdmin = false;
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r))),
                          tileColor: Colors.orange.shade50,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('Admin', style: Styles.normalStyle),
                          value: isUserTypeAdmin,
                          onChanged: (value) {
                            setState(() {
                              isUserTypeAdmin = value!;
                              if (isUserTypeAdmin && isUserTypeUser) {
                                isUserTypeUser = false;
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Hero(
                          tag: "saved_data",
                          child: longButton(
                              onPressed: () async {
                                final ConnectivityResult connectivityResult =
                                    await Connectivity().checkConnectivity();

                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  showSnackBar(context,
                                      "Please check your interent connection!");
                                } else {
                                  storeData();
                                }
                              },
                              text: isLoading == true ? "Saving.." : "Continue",
                              width: MediaQuery.of(context).size.width - 50.w,
                              isLoading: isLoading),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// store user data to database
  void storeData() async {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      userType: isUserTypeAdmin ? "admin" : "user",
      profilePic: "",
      createdAt: "",
      phoneNumber: widget.phoneNumber,
      uid: "",
    );

    if (image != null) {
      ap.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: () {
// once data is saved we need to store it loacally also
            ap.saveUserDataToSP().then(
                  (value) => ap.setSignIn().then(
                        (value) => navigateScaleUntil(
                          context,
                          const Registered(),
                        ),
                      ),
                );
          });
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }

  //for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }
}
