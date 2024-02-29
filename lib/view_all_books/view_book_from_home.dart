import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:my_library/provider/sub_book_provider.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import 'package:my_library/shimmer_loadings/view_books_shimmer.dart';
import 'package:my_library/view_all_users/users_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../styles/styles.dart';

class ViewbookFromHome extends StatefulWidget {
  const ViewbookFromHome({
    super.key,
    required this.bookName,
    required this.bookId,
    required this.writerName,
    required this.description,
    this.qrData = '',
    required this.bookReference,
  });

  final String bookName;
  final String writerName;
  final String description;
  final String qrData;
  final int bookId;
  final DocumentReference bookReference;

  @override
  State<ViewbookFromHome> createState() => _StateViewbookFromHome();
}

class _StateViewbookFromHome extends State<ViewbookFromHome> {
  bool isDownload = false;
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? imageData;
  bool isExpandQr = true;
  bool isSearchVisible = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  var allSubBook = [];
  bool isShimmer = true;
  bool emptyListOfBooks = true;

  @override
  void initState() {
    super.initState();
    isDownload = true;
    isExpandQr = true;
    isSearchVisible = false;
    UserRepository()
        .getSubBooksByBookReference(widget.bookReference)
        .then((value) {
      setState(() {
        if (value.isNotEmpty) {
          emptyListOfBooks = false;
          allSubBook = value;
        } else {
          emptyListOfBooks = true;
        }
      });
    }).then((value) => Future.delayed(const Duration(milliseconds: 500))
            .then((value) => setState(
                  () {
                    isShimmer = false;
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    var finalSubBooks = allSubBook
        .where((element) => element.userName
            .toLowerCase()
            .contains(_controller.text.toLowerCase()))
        .toList();

    return WillPopScope(
      onWillPop: () async {
        navigateScaleUntil(context, const HomePage());
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
          setState(() {
            isSearchVisible = false;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            title: !isSearchVisible
                ? Text(widget.bookName.toUpperCase(), style: Styles.title)
                : searchWidget(
                    onChange: (value) {
                      {
                        // Store the current cursor position
                        final cursorPosition = _controller.selection.baseOffset;
                        // Update the text in the controller
                        setState(() {
                          _controller.text = value;
                        });
                        // Move the cursor to the correct position
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: cursorPosition));
                      }
                    },
                    content: "Search by user's name...",
                    controller: _controller,
                    focusNode: _focusNode,
                    suffix: _controller.text != ''
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.text = "";
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ))
                        : null,
                  ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              if (!isSearchVisible)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _focusNode.unfocus();
                    setState(() {
                      isSearchVisible = true;
                      isExpandQr = false;
                    });
                  },
                ),
              if (isExpandQr == false)
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                    setState(() {
                      isSearchVisible = false;
                      isExpandQr = true;
                    });
                  },
                ),
              if (isExpandQr == true)
                IconButton(
                  icon: const Icon(Icons.hide_image_outlined),
                  onPressed: () {
                    setState(() {
                      isExpandQr = false;
                    });
                  },
                ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: 15.h,
              bottom: 0.h,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (isExpandQr == true)
                      Column(
                        children: [
                          Screenshot(
                            controller: _screenshotController,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(6, 6),
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "My Library",
                                      style: GoogleFonts.lora(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    QrImageView(
                                      data: widget.qrData,
                                      version: QrVersions.auto,
                                      size: MediaQuery.of(context).size.width *
                                          0.6,
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.20,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.bookName.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.lora(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.writerName,
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lora(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Book ID:",
                                                style: Styles.title2,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                widget.bookId.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lora(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              downLoadImage().then((value) {
                                setState(() {
                                  isDownload = true;
                                  showSnackBar(
                                      context, "Image downloaded successfully");
                                });
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                side: const BorderSide(color: Colors.red),
                              ),
                              elevation: 1,
                              backgroundColor: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Download QR-Code",
                                  style: GoogleFonts.lora(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Icon(
                                  Icons.download,
                                  color: Colors.orange,
                                )
                              ],
                            ),
                          ),
                          verGap(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: RichText(
                              text: TextSpan(
                                  style: GoogleFonts.ibmPlexSans(
                                      color: Colors.black54, fontSize: 13.sp),
                                  children: [
                                    const TextSpan(text: "Note: "),
                                    const TextSpan(text: "Please "),
                                    TextSpan(
                                        text: "download",
                                        style: GoogleFonts.ibmPlexSans(
                                            color: Colors.red)),
                                    const TextSpan(
                                        text: " this QR-Code, take a "),
                                    TextSpan(
                                        text: "printout",
                                        style: GoogleFonts.ibmPlexSans(
                                            color: Colors.red)),
                                    const TextSpan(text: " and "),
                                    TextSpan(
                                        text: "stick on book",
                                        style: GoogleFonts.ibmPlexSans(
                                            color: Colors.red)),
                                    const TextSpan(
                                        text:
                                            ", so that user can scan QR-Code and issue book"),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 1.h,
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width - 20.w,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    isShimmer
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 5.h,
                            ),
                            child: const ViewBooksShimmer(
                              itemCount: 4,
                            ),
                          )
                        : (finalSubBooks.isNotEmpty)
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: finalSubBooks.length,
                                itemBuilder: (context, index) {
                                  finalSubBooks.sort((a, b) =>
                                      b.fromDate!.compareTo(a.fromDate!));
                                  var subBook = finalSubBooks[index];
                                  return UsersLog(
                                    uid: subBook.uid,
                                    fromDate: DateFormat('dd-MM-yyyy')
                                        .format(subBook.fromDate!),
                                    toDate: (subBook.toDate == null)
                                        ? "Current!"
                                        : DateFormat('dd-MM-yyyy')
                                            .format(subBook.toDate!),
                                    status: subBook.status!,
                                  );
                                },
                              )
                            : emptyList(
                                content:
                                    "No User found associated with this book."),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downLoadImage() async {
    final image = await _screenshotController.capture();
    if (image == null) {
      return;
    } else {
      await saveImage(image);
    }
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final name = "mylibrary/${widget.bookName}/${DateTime.now()}";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result["filePath"];
  }
}
