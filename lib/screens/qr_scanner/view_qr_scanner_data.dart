import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/model/sub_book_model.dart';
import 'package:my_library/provider/book_provider.dart';
import 'package:my_library/provider/sub_book_provider.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/utils/utils.dart';
import 'package:my_library/widgets/components.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class ViewQrData extends StatefulWidget {
  const ViewQrData({
    super.key,
    this.bookName = "Unknown!",
    this.bookId = 0,
    this.writerName = "Unknown!",
    this.description = "No decription found!",
    this.bookReference = "no reference",
    this.numberOfBooks = 1,
  });

  final String bookName;
  final int bookId;
  final String writerName;
  final String description;
  final String bookReference;
  final int numberOfBooks;

  @override
  State<ViewQrData> createState() => _ViewQrDataState();
}

class _ViewQrDataState extends State<ViewQrData> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    DocumentReference currentUserReference =
        FirebaseFirestore.instance.collection("users").doc(ap.uid);
    DocumentReference bookDocumentReference =
        FirebaseFirestore.instance.doc(widget.bookReference);

    return WillPopScope(
      onWillPop: () async {
        navigateSlideUntil(context, const HomePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book data", style: Styles.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              navigateSlideUntil(context, const HomePage());
            },
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(6, 6),
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Book name: ",
                              style: Styles.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(
                              child: Text(
                                widget.bookName,
                                style: Styles.normalStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        verGap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Book ID: ",
                              style: Styles.title,
                            ),
                            Expanded(
                              child: Text(
                                widget.bookId.toString(),
                                style: Styles.normalStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        verGap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Writer's name: ",
                              style: Styles.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(
                              child: Text(
                                widget.writerName,
                                style: Styles.normalStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        verGap(),
                        SizedBox(
                          height: 60.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Book's description: ",
                                style: Styles.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: Text(
                                    widget.description == "No Value"
                                        ? "No decription found!"
                                        : widget.description,
                                    maxLines: 3,
                                    style: Styles.normalStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verGap(),
                ElevatedButton(
                  onPressed: () {
                    showDialogCustom(context, onPressed: () async {
                      Navigator.pop(context);
                      final ConnectivityResult connectivityResult =
                          await Connectivity().checkConnectivity();

                      if (connectivityResult == ConnectivityResult.none) {
                        showSnackBar(
                            context, "Please check your interent connection!");
                      } else {
                        UserRepository()
                            .addSubBookDocumentUpdated(
                                currentUserReference,
                                SubBookModel(
                                  userName: ap.userModel.name,
                                  uid: ap.userModel.uid,
                                  bookId: widget.bookId,
                                  bookName: widget.bookName,
                                  writerName: widget.writerName,
                                  fromDate: DateTime.now(),
                                  status: true,
                                  bookReference: bookDocumentReference,
                                ))
                            .then((value) => BookProvider()
                                    .updateBookAvailabilityByNumberOfBooks(
                                  bookDocumentReference,
                                  widget.numberOfBooks,
                                ))
                            .then((value) {
                          showSnackBar(
                            context,
                            "Successfully issued this ${widget.bookName} book",
                            done: true,
                          );
                          navigateSlideUntil(context, const HomePage());
                        });
                      }
                    },
                        rightPadding: 20.0.w,
                        content: "Do you really want to issue this book?");
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Issue now',
                    style: GoogleFonts.lora(fontSize: 18.sp),
                  ),
                ),
                verGap(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
