import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_library/provider/sub_book_provider.dart';
import 'package:my_library/shimmer_loadings/view_books_shimmer.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/view_all_books/view_book.dart';

import '../../model/sub_book_model.dart';

import '../../styles/styles.dart';

class IssuedBooks extends StatefulWidget {
  const IssuedBooks({
    super.key,
    required this.fromPage,
    required this.userReference,
  });
  final String fromPage;
  final DocumentReference userReference;

  @override
  State<IssuedBooks> createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {
  var allSubBooks = [];
  bool isSearchVisible = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool listEmpty = false;
  bool isShimmer = true;
  @override
  void initState() {
    super.initState();
    UserRepository()
        .getSubCollectionDocuments(widget.userReference)
        .then((value) => setState(
              () {
                if (value.isNotEmpty) {
                  value.sort((a, b) => b.fromDate!.compareTo(a.fromDate!));
                  allSubBooks = value;
                } else {
                  setState(() {
                    listEmpty = true;
                  });
                }
              },
            ))
        .then((value) => setState(
              () {
                Future.delayed(const Duration(microseconds: 1500)).then(
                  (value) => setState(
                    () {
                      isShimmer = false;
                    },
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromPage == "current") {
      allSubBooks = allSubBooks
          .where(
            (element) => element.status == true,
          )
          .toList();
    }
    var finalSubBooks = allSubBooks
        .where((element) => element.bookName
            .toLowerCase()
            .contains(_controller.text.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
        setState(() {
          isSearchVisible = false;
        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: !isSearchVisible
                ? Text(
                    widget.fromPage == "total"
                        ? "Total issued books"
                        : 'Current issued books',
                    style: Styles.title)
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
                    content: "Search by book name...",
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
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _focusNode.unfocus();
                  setState(() {
                    isSearchVisible = true;
                  });
                },
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
          body: isShimmer
              ? Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: const ViewBooksShimmer(
                    itemCount: 4,
                    isScroll: true,
                  ),
                )
              : Column(
                  children: [
                    verGap(),
                    finalSubBooks.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child:
                                emptyList(content: "Sorry!, data not found."),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: finalSubBooks.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  SubBookModel subBook = finalSubBooks[index];

                                  return Viewbook(
                                    bookName: subBook.bookName ?? '',
                                    bookId: subBook.bookId ?? 0,
                                    bookReference: subBook.bookReference!,
                                    writerName: subBook.writerName ?? '',
                                    status: subBook.status!,
                                    fromDate: DateFormat('dd-MM-yyyy')
                                        .format(subBook.fromDate!),
                                    toDate: (subBook.toDate == null)
                                        ? "Current!"
                                        : DateFormat('dd-MM-yyyy')
                                            .format(subBook.toDate!),
                                    qrData:
                                        "Please scan code from book, this QR-code is expired!",
                                  );
                                }),
                          ),
                  ],
                )),
    );
  }
}
