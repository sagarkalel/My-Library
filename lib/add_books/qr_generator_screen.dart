import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/model/book_model.dart';
import 'package:my_library/provider/book_provider.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/styles/styles.dart';
import 'package:my_library/utils/utils.dart';

import '../add_books/download_qr_screen.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key}) : super(key: key);

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController writerNameController = TextEditingController();
  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfBooksController =
      TextEditingController(text: 1.toString());

  final _focusNode = FocusNode();
  final globalKey = GlobalKey();
  String qrData = '';

  @override
  void dispose() {
    bookNameController.dispose();
    writerNameController.dispose();
    bookIdController.dispose();
    descriptionController.dispose();
    numberOfBooksController.dispose();
    super.dispose();
  }

  Future<void> generateQRCode() async {
    setState(() {
      qrData =
          'Book Name: ${bookNameController.text}, Writer Name: ${writerNameController.text}, Book ID: ${bookIdController.text}, Description: ${descriptionController.text}, Book Reference: ';
    });
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add new book data',
            style: Styles.title,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      textField(
                          hintText: 'Book Name',
                          icon: Icons.menu_book_outlined,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: bookNameController),
                      const SizedBox(
                        height: 5,
                      ),
                      textField(
                          hintText: 'Writer Name',
                          icon: Icons.person_2,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: writerNameController),
                      SizedBox(
                        height: 5.h,
                      ),
                      textField(
                          hintText: 'Book ID',
                          icon: Icons.assignment_ind_rounded,
                          inputType: TextInputType.number,
                          maxLines: 1,
                          inputFormatterNumber: true,
                          controller: bookIdController),
                      SizedBox(
                        height: 5.h,
                      ),
                      textField(
                          hintText: 'Number of books',
                          icon: Icons.menu_book,
                          inputType: TextInputType.number,
                          maxLines: 1,
                          inputFormatterNumber: true,
                          controller: numberOfBooksController),
                      SizedBox(
                        height: 5.h,
                      ),
                      textField(
                          hintText: 'Book description',
                          icon: Icons.description,
                          inputType: TextInputType.text,
                          maxLines: 2,
                          controller: descriptionController),
                      SizedBox(
                        height: 5.h,
                      ),
                      Icon(
                        Icons.menu_book_outlined,
                        color: Colors.orange.shade50,
                        size: 210.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: RichText(
                  text: TextSpan(
                      style: GoogleFonts.ibmPlexSans(
                          color: Colors.black54, fontSize: 13.sp),
                      children: [
                        const TextSpan(text: "Note: Save this data to "),
                        TextSpan(
                            text: "generate QR-Code",
                            style: GoogleFonts.ibmPlexSans(color: Colors.red)),
                        const TextSpan(text: ", take a "),
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
                  if (bookNameController.text.length <= 3) {
                    showSnackBar(context, "Please enter valid book name");
                  } else if (bookIdController.text.length <= 3) {
                    showSnackBar(context, "Please enter valid Book ID");
                  } else if (writerNameController.text.length <= 3) {
                    showSnackBar(context, "Please enter valid writer's name");
                  } else if (numberOfBooksController.text.isEmpty ||
                      numberOfBooksController.text == '0') {
                    showSnackBar(context,
                        "Please enter valid number of books, books can't be 0");
                  } else {
                    showDialogCustom(
                      context,
                      content:
                          "Do you really want to save this data (add book in library) to generate QR-Code ?",
                      rightPadding: 20.0.w,
                      onPressed: () {
                        Navigator.pop(context);
                        generateQRCode().then(
                          (value) => {
                            BookProvider().addBookDataRefToFirebase(
                                context: context,
                                bookModel: BookModel(
                                  bookName: bookNameController.text,
                                  writerName: writerNameController.text,
                                  bookId: int.parse(bookIdController.text),
                                  description: descriptionController.text,
                                  numberOfBooks:
                                      int.parse(numberOfBooksController.text),
                                  isAvailable: true,
                                  addedTime: DateTime.now(),
                                ),
                                onSuccess: (bookReference) {
                                  debugPrint(
                                      "bookreference is ${bookReference.path}");
                                  navigateSlideUntil(
                                    context,
                                    DownloadQrScreen(
                                      bookName: bookNameController.text,
                                      writerName: writerNameController.text,
                                      bookId: int.parse(bookIdController.text),
                                      description: descriptionController.text,
                                      qrData:
                                          'Book Name: ${bookNameController.text}, Writer Name: ${writerNameController.text}, Book ID: ${bookIdController.text}, Description: ${descriptionController.text}, Book Reference: ${bookReference.path}',
                                    ),
                                  );
                                }),
                          },
                        );
                      },
                    );
                  }
                },
                text: "Save data to Generate QR Code",
                width: MediaQuery.of(context).size.width - 50.w,
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
