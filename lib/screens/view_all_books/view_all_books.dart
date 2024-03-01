import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/provider/book_provider.dart';
import 'package:my_library/shimmer_loadings/home_books_shimmer.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';
import 'package:provider/provider.dart';
import '../home_page/all_books_user.dart';
import '../../provider/auth_provider.dart';
import 'view_book_from_home.dart';

class ViewAllBooks extends StatefulWidget {
  const ViewAllBooks({super.key});

  @override
  State<ViewAllBooks> createState() => _ViewAllBooksState();
}

class _ViewAllBooksState extends State<ViewAllBooks> {
  bool isListEmpty = false;
  var bookList = [];
  bool isSearchVisible = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isShimmer = true;
  @override
  void initState() {
    super.initState();
    BookProvider()
        .fetchBooksNew()
        .then((value) => setState(
              () {
                if (value.isNotEmpty) {
                  value.sort((a, b) => b.addedTime.compareTo(a.addedTime));

                  isListEmpty = false;
                  bookList = value;
                } else {
                  isListEmpty = true;
                  bookList = value;
                }
              },
            ))
        .then((value) => Future.delayed(const Duration(milliseconds: 500))
            .then((value) => setState(
                  () {
                    isShimmer = false;
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    var allbooks = bookList
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
              ? Text('All books', style: Styles.title)
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
        body: Hero(
            tag: "viewAllBooks",
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: isShimmer
                  ? HomeBooksShimmer(
                      color: Colors.amber.shade100,
                      itemCount: 8,
                    )
                  : (allbooks.isNotEmpty)
                      ? ListView.builder(
                          itemCount: allbooks.length,
                          itemBuilder: (context, index) {
                            if (allbooks.isNotEmpty) {
                              var book = allbooks[index];
                              return GestureDetector(
                                onTap: () {
                                  navigateSlide(
                                    context,
                                    ViewbookFromHome(
                                      bookName: book.bookName,
                                      bookReference: book.bookReference!,
                                      bookId: book.bookId!,
                                      writerName: book.writerName,
                                      description: book.description!,
                                      qrData:
                                          "Book Name: ${book.bookName}, Writer Name: ${book.writerName}, Book ID: ${book.bookId!}, Description: ${book.description!}, Book Reference: ${book.bookReference!.path}",
                                    ),
                                  );
                                },
                                child: AllBooksUser(
                                  // color: Colors.red.shade100,
                                  isAdmin: ap.userModel.userType == "user"
                                      ? false
                                      : true,
                                  color:
                                      const Color.fromARGB(255, 255, 241, 240),
                                  description: book.description!,
                                  isAvailable: book.isAvailable!,
                                  bookName: book.bookName,
                                  writerName: book.writerName,
                                  bookId: book.bookId!.toString(),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          })
                      : emptyList(
                          content: "Sorry!, book not found with this name."),
            )),
      ),
    );
  }
}
