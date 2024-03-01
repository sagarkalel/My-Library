import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';
import '../../model/user_provider.dart';
import '../../provider/sub_book_provider.dart';

class UsersLog extends StatefulWidget {
  const UsersLog({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.uid,
  });

  final String fromDate;
  final String toDate;
  final bool status;

  final String uid;

  @override
  State<UsersLog> createState() => _UsersLogState();
}

class _UsersLogState extends State<UsersLog> {
  int currentIssuedBooks = 0;
  int totalIssuedBooks = 0;
  String name = 'Unknown!';
  String profilePic = '';
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
    // getUserModelByUid(widget.uid).then((value) => setState(
    //       () {
    //         name = value!.name;
    //         profilePic = value.profilePic;
    //       },
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    getUserModelByUid(widget.uid).then((value) => setState(
          () {
            name = value!.name;
            profilePic = value.profilePic;
          },
        ));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(-4, -4),
                  )
                ],
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        horGap(),
                        Container(
                          height: 75.r,
                          width: 75.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 254, 224, 168),
                            // borderRadius: BorderRadius.only(
                            //   topLeft: Radius.circular(10),
                            // ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: profilePic == ''
                              ? Icon(
                                  Icons.account_circle,
                                  size: 55.sp,
                                  color: Colors.black26,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(profilePic),
                                ),
                        ),
                        horGap(),
                        horGap(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'From: ',
                                  style: Styles.title2,
                                ),
                                Text(
                                  widget.fromDate,
                                  style: Styles.descrption,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'To: ',
                                  style: Styles.title2,
                                ),
                                Text(
                                  widget.toDate,
                                  style: Styles.descrption,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Current issued books: ',
                                  style: Styles.title2,
                                ),
                                Text(
                                  currentIssuedBooks.toString(),
                                  style: Styles.descrption,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total issued books: ',
                                  style: Styles.title2,
                                ),
                                Text(
                                  totalIssuedBooks.toString(),
                                  style: Styles.descrption,
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
                    Row(
                      children: [
                        Text(
                          '(${name.toUpperCase()})',
                          style: GoogleFonts.lora(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.status == false)
                          Row(
                            children: [
                              horGap(),
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
                        if (widget.status == true)
                          Row(
                            children: [
                              horGap(),
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
