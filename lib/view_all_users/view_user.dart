import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_library/provider/sub_book_provider.dart';
import 'package:my_library/shimmer_loadings/home_books_shimmer.dart';
import 'package:my_library/styles/components.dart';
import '../styles/styles.dart';
import 'view_user_subbook.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.uid,
  });
  final String name;
  final String phoneNumber;
  final String uid;

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  var allSubBooks = [];
  bool isListEmpty = false;
  bool isSearchVisible = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isShimmer = true;
  @override
  void initState() {
    super.initState();
    UserRepository().getSubBooksForUser(widget.uid).then((value) {
      debugPrint("value lenght is ${value.length.toString()}");
      setState(() {
        if (value.isNotEmpty) {
          allSubBooks = value;
          isListEmpty = false;
        } else {
          isListEmpty = true;
          allSubBooks = value;
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
    var finalAllbooks = allSubBooks
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
              ? Text(widget.name.toUpperCase(), style: Styles.title)
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
          ],
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verGap(),
              isShimmer
                  ? Expanded(
                      child: HomeBooksShimmer(
                        color: Colors.red.shade100,
                        itemCount: 5,
                      ),
                    )
                  : (finalAllbooks.isNotEmpty)
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: finalAllbooks.length,
                              itemBuilder: (context, index) {
                                finalAllbooks.sort((a, b) =>
                                    b.fromDate!.compareTo(a.fromDate!));
                                final book = finalAllbooks[index];
                                return UsersSubBook(
                                  color: Colors.red.shade100,

                                  // color: const Color.fromARGB(255, 255, 241, 240),
                                  fromDate: DateFormat('dd-MM-yyyy')
                                      .format(book.fromDate!),
                                  toDate: (book.toDate == null)
                                      ? "Current!"
                                      : DateFormat('dd-MM-yyyy')
                                          .format(book.toDate!),
                                  status: book.status!,
                                  bookName: book.bookName ?? '',
                                  writerName: book.writerName ?? '',
                                  bookId: book.bookId!.toString(),
                                );
                              }),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child:
                              emptyList(content: 'Sorry!, result not found.'),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
