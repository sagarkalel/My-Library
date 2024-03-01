import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/provider/book_provider.dart';
import 'package:my_library/screens/qr_scanner/view_qr_scanner_data.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/utils/utils.dart';
import 'package:my_library/widgets/components.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});
  @override
  State<QrScanner> createState() {
    return _StateQrScanner();
  }
}

class _StateQrScanner extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _focusNode = FocusNode();
  late QRViewController controller;
  int status = 0;
  bool showError = false;
  bool isFlashOn = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  bool validateQRCodeData(String qrData) {
    // Define the regex pattern for matching the expected format
    String pattern =
        r'^Book Name: .+, Writer Name: .+, Book ID: .+(, Description: .+)?, Book Reference: .+$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(qrData);
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String? qrData = scanData.code;

      controller.pauseCamera().then(
        (value) {
          if (validateQRCodeData(qrData!) == false) {
            setState(() {
              showError = true;
              status = 1;
            });
            showSnackBar(
              context,
              "Seems to be an invalid QR Code. Try with a different QR Code!",
              error: true,
            );
          } else {
            BookProvider()
                .doesBookExist(FirebaseFirestore.instance
                    .doc(getFieldValue(qrData, 'Book Reference')))
                .then((exist) {
              if (exist) {
                BookProvider()
                    .checkBookAvailabilityIntReturn(FirebaseFirestore.instance
                        .doc(getFieldValue(qrData, 'Book Reference')))
                    .then((numberOfBooks) {
                  if (numberOfBooks >= 1) {
                    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).clearSnackBars();

                    setState(() {
                      showError = false;
                      status = 2;
                    });
                    controller.stopCamera();
                    navigateSlide(
                      context,
                      ViewQrData(
                        numberOfBooks: numberOfBooks,
                        bookName: getFieldValue(qrData, 'Book Name'),
                        bookId: int.parse(getFieldValue(qrData, 'Book ID')),
                        writerName: getFieldValue(qrData, 'Writer Name'),
                        description: getFieldValue(qrData, 'Description'),
                        bookReference: getFieldValue(qrData, 'Book Reference'),
                      ),
                    );
                  } else {
                    setState(() {
                      showError = true;
                      status = 1;
                    });
                    showSnackBar(
                      context,
                      "We are sorry, this book is not available currently, already issued by someone!",
                      error: true,
                    );
                  }
                });
              } else {
                setState(() {
                  showError = true;
                  status = 1;
                });
                showSnackBar(
                  context,
                  "Sorrry! This book is currently not exist in library.",
                  error: true,
                );
              }
            });
          }
        },
      );
    });
  }

  String getFieldValue(String? qrData, String fieldName) {
    if (qrData == null) {
      return 'No Data';
    }

    RegExp regex = RegExp('$fieldName: ([^,]+)');
    Match? match = regex.firstMatch(qrData);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? 'No Value';
    } else {
      return 'No Value';
    }
  }

  Future<void> startScanning() {
    return controller.resumeCamera();
  }

  Future<void> stopScanning() {
    return controller.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan and issue book', style: Styles.title),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                controller.toggleFlash();
              },
              icon: Icon(
                isFlashOn ? Icons.flash_off : Icons.flash_on,
              ),
            )
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderWidth: 5.w,
                  borderRadius: 10.r,
                  overlayColor: Colors.black.withOpacity(0.75),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (status == 1)
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50.sp,
                      ),
                    if (status == 0)
                      Icon(
                        Icons.filter_center_focus,
                        color: Colors.orange,
                        size: 30.sp,
                      ),
                    if (status == 2)
                      Icon(
                        Icons.offline_pin,
                        color: Colors.green,
                        size: 50.sp,
                      ),
                    if (status == 1) verGap(),
                    if (status == 1)
                      OutlinedButton(
                        onPressed: () {
                          status = 0;
                          controller.resumeCamera();
                          setState(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(color: Colors.red, width: 1.w),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.qr_code_scanner),
                            horGap(),
                            Text(
                              "Scan again!",
                              style: Styles.normalStyle,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 120.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
