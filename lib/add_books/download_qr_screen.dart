import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../styles/styles.dart';

class DownloadQrScreen extends StatefulWidget {
  const DownloadQrScreen({
    super.key,
    required this.bookName,
    required this.bookId,
    required this.writerName,
    required this.description,
    required this.qrData,
  });

  final String bookName;
  final String writerName;
  final String description;
  final String qrData;
  final int bookId;

  @override
  State<DownloadQrScreen> createState() => _StateDownloadQrScreen();
}

class _StateDownloadQrScreen extends State<DownloadQrScreen> {
  bool isDownload = false;
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    isDownload = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDownload == false) {
          showSnackBar(context,
              "Please download QR-Code first, take a printout and stick on book");
        } else {
          navigateScaleUntil(context, const HomePage());
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add book', style: Styles.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (isDownload == false) {
                showSnackBar(context,
                    "Please download QR-Code first, take a printout and stick on book");
              } else {
                navigateScaleUntil(context, const HomePage());
              }
            },
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(15.r),
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
                        horizontal: 10.0.h, vertical: 10.0.h),
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
                          size: MediaQuery.of(context).size.width * 0.6,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.20,
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
                      showSnackBar(context, "Image downloaded successfully");
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
                    Icon(
                      isDownload ? Icons.file_download_done : Icons.download,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
              const Spacer(),
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
                            style: GoogleFonts.ibmPlexSans(color: Colors.red)),
                        const TextSpan(text: " this QR-Code, take a "),
                        TextSpan(
                            text: "printout",
                            style: GoogleFonts.ibmPlexSans(color: Colors.red)),
                        const TextSpan(text: " and "),
                        TextSpan(
                            text: "stick on book",
                            style: GoogleFonts.ibmPlexSans(color: Colors.red)),
                        const TextSpan(
                            text:
                                ", so that user can scan QR-Code and issue book"),
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              verGap(),
              longButton(
                onPressed: () {
                  if (isDownload == false) {
                    showSnackBar(context,
                        "Please download QR-Code first, take a printout and stick on book");
                  } else {
                    navigateScaleUntil(context, const HomePage());
                  }
                },
                text: "Go Home",
                isIcon: true,
                icon: Icons.home_outlined,
                width: MediaQuery.of(context).size.width * 0.85,
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
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
