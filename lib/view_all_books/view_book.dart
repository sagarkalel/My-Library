import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/provider/book_provider.dart';
import 'package:my_library/provider/sub_book_provider.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/utils/utils.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../styles/styles.dart';

class Viewbook extends StatefulWidget {
  const Viewbook({
    super.key,
    required this.bookName,
    required this.bookId,
    required this.writerName,
    required this.qrData,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.bookReference,
  });
  final String bookName;
  final String writerName;
  final String fromDate;
  final String toDate;
  final String qrData;
  final int bookId;
  final bool status;
  final DocumentReference bookReference;

  @override
  State<Viewbook> createState() => _ViewbookState();
}

class _ViewbookState extends State<Viewbook> {
  int numberOfBooks = 0;
  @override
  void initState() {
    super.initState();
    BookProvider()
        .checkBookAvailabilityIntReturn(widget.bookReference)
        .then((value) => setState(
              () {
                numberOfBooks = value;
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 201, 224, 253),
          border: Border.all(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 203, 249, 181),
                color: const Color.fromARGB(255, 245, 255, 195),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  if (!widget.status)
                    Column(
                      children: [
                        Text(
                          'My library',
                          style: Styles.smallText2,
                        ),
                        Icon(
                          Icons.qr_code_2,
                          size: 85.sp,
                        ),
                      ],
                    ),
                  if (widget.status)
                    Column(
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 70.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialogCustom(context, onPressed: () async {
                              Navigator.pop(context);
                              final ConnectivityResult connectivityResult =
                                  await Connectivity().checkConnectivity();

                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                // ignore: use_build_context_synchronously
                                showSnackBar(context,
                                    "Please check your interent connection!");
                              } else {
                                UserRepository()
                                    .updateSubBookFormId(widget.bookId,
                                        DateTime.now(), false, ap.userModel.uid)
                                    .then((value) => BookProvider()
                                        .updateBookAvailabilityByNumberOfBooksPlus(
                                            widget.bookReference,
                                            numberOfBooks))
                                    .then((value) {
                                  navigateSlideUntil(context, const HomePage());
                                  showSnackBar(
                                    context,
                                    "Book returned successfully!",
                                    done: true,
                                  );
                                });
                              }
                            },
                                rightPadding: 20.0.w,
                                content:
                                    "Do you really want to return this book?");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 223, 95, 86),
                                borderRadius: BorderRadius.circular(6.r)),
                            child: Padding(
                              padding: EdgeInsets.all(5.0.r),
                              child: Text(
                                "Return",
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book name: ',
                        style: Styles.normalStyleBold,
                      ),
                      Expanded(
                        child: Text(
                          widget.bookName.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.descrption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auther\'s name: ',
                        style: Styles.normalStyleBold,
                      ),
                      Expanded(
                        child: Text(
                          widget.writerName.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.descrption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Row(
                    children: [
                      Text(
                        'Book ID: ',
                        style: Styles.normalStyleBold,
                      ),
                      Expanded(
                        child: Text(
                          widget.bookId.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Styles.descrption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Row(
                    children: [
                      Text(
                        'From: ',
                        style: Styles.normalStyleBold,
                      ),
                      Expanded(
                        child: Text(
                          widget.fromDate,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.descrption,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'To: ',
                        style: Styles.normalStyleBold,
                      ),
                      Expanded(
                        child: Text(
                          widget.toDate,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.descrption,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
