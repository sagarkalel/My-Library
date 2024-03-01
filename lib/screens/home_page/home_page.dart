// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/screens/add_books/qr_generator_screen.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';
import 'package:provider/provider.dart';
import '../all_users/issued_books_by_all_users.dart';
import '../../firebase_functions/book_collection.dart';
import '../../model/user_provider.dart';
import '../../provider/auth_provider.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import '../../shimmer_loadings/home_books_shimmer.dart';
import '../../shimmer_loadings/home_user_card_shimmer.dart';
import '../../utils/utils.dart';
import '../view_all_books/view_all_books.dart';
import '../view_all_books/view_book_from_home.dart';
import '../view_all_users/view_all_users.dart';
import '../view_all_users/view_user.dart';
import 'all_books_user.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  @override
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => StateHomePage();
}

class StateHomePage extends State<HomePage> {
  bool availabilityForUser = false;
  bool isSearchVisible = false;
  var allUsers = [];
  bool noUserFound = false;
  var allBooksAdmin = [];
  bool noBooks = false;
  var allBooksUser = [];
  bool isShimmer = true;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    getUsersFuture().then(
      (value) => setState(
        () {
          if (value.isNotEmpty) {
            value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            allUsers =
                value.where((element) => element.userType == "user").toList();
          }
        },
      ),
    );
    getBooksFuture()
        .then(
          (value) => setState(
            () {
              if (value.isNotEmpty) {
                value.sort((a, b) => b.addedTime.compareTo(a.addedTime));
                allBooksAdmin = value;
                allBooksUser = value;
                noBooks = false;
              } else {
                noBooks = true;
              }
            },
          ),
        )
        .then((value) => setState(
              () {
                Future.delayed(const Duration(seconds: 1)).then(
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    debugPrint("with of device is ${MediaQuery.of(context).size}");
    final ap = Provider.of<MyAuthProvider>(context, listen: false);

    var allBooksBoolUsers = allBooksUser
        .where((book) => book.isAvailable == availabilityForUser)
        .toList();
    var searchBooksForUser = availabilityForUser
        ? allBooksBoolUsers
            .where((element) => element.bookName
                .toLowerCase()
                .contains(_controller.text.toLowerCase()))
            .toList()
        : allBooksUser
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
        drawer: const MenuDrawer(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: ap.userModel.userType == "user"
            ? floatingActionCustomButton(
                onPressed: () async {
                  final ConnectivityResult connectivityResult =
                      await Connectivity().checkConnectivity();

                  if (connectivityResult == ConnectivityResult.none) {
                    showSnackBar(
                        context, "Please check your interent connection!");
                  } else {
                    navigateSlide(context, const QrScanner());
                  }
                },
                text: "Issue new",
                icon: Icons.qr_code_scanner)
            : floatingActionCustomButton(
                onPressed: () async {
                  final ConnectivityResult connectivityResult =
                      await Connectivity().checkConnectivity();

                  if (connectivityResult == ConnectivityResult.none) {
                    showSnackBar(
                        context, "Please check your interent connection!");
                  } else {
                    navigateSlide(context, const QrGenerator());
                  }
                },
                text: "Add new",
                icon: Icons.library_add),
        appBar: AppBar(
          title: ap.userModel.userType == "user"
              ? (!isSearchVisible
                  ? Text('My Library', style: Styles.title)
                  : searchWidget(
                      onChange: (value) {
                        {
                          // Store the current cursor position
                          final cursorPosition =
                              _controller.selection.baseOffset;
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
                    ))
              : Text('My Library', style: Styles.title),
          actions: [
            if (ap.userModel.userType == "user")
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
        body: SizedBox(
          child: Column(
            children: [
              if (ap.userModel.userType == "user")
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    top: 15.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'All books:',
                        style: Styles.title2,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: availabilityForUser == false
                            ? null
                            : () {
                                setState(() {
                                  availabilityForUser = false;
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.w, vertical: 3.h),
                            child: Row(
                              children: [
                                Text(
                                  "All ",
                                  style: Styles.smallText2,
                                ),
                                Icon(
                                  availabilityForUser == false
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      horGap(),
                      GestureDetector(
                        onTap: availabilityForUser
                            ? null
                            : () {
                                setState(() {
                                  availabilityForUser = true;
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.w, vertical: 3.h),
                            child: Row(
                              children: [
                                Text(
                                  'Available only ',
                                  style: Styles.smallText2,
                                ),
                                Icon(
                                  availabilityForUser == true
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (ap.userModel.userType == "admin")
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, top: 15.h),
                      child: Row(
                        children: [
                          Text(
                            'Borrowers:',
                            style: Styles.title2,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateScale(context, const ViewAllUsers());
                            },
                            child: Hero(
                              tag: 'viewAllButton2',
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0.w, vertical: 6),
                                  child: Text(
                                    'View all',
                                    style: Styles.smallText2,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    verGap(),
                    isShimmer
                        ? SizedBox(
                            height: MediaQuery.of(context).size.width * 0.6,
                            width: MediaQuery.of(context).size.width - 30.w,
                            child: const HomeUserCardShimmer(
                              itemCount: 5,
                            ),
                          )
                        : (!noUserFound)
                            ? SizedBox(
                                height: MediaQuery.of(context).size.width * 0.6,
                                width: MediaQuery.of(context).size.width - 30.w,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allUsers.length,
                                  itemBuilder: (context, index) {
                                    allUsers.sort((a, b) =>
                                        b.createdAt.compareTo(a.createdAt));
                                    final user = allUsers[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: index == allUsers.length - 1
                                            ? 0.0
                                            : 16.0.w,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          navigateSlide(
                                              context,
                                              ViewUser(
                                                uid: user.uid,
                                                phoneNumber: user.phoneNumber,
                                                name: user.name,
                                              ));
                                        },
                                        child: BookIssuedAllUsers(
                                          uid: user.uid,
                                          name: user.name,
                                          phoneNumber: user.phoneNumber,
                                          profilePic: user.profilePic,
                                          userRef: user.uid,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : emptyList(
                                content: "'No User found!",
                              ),
                  ],
                ),
              if (ap.userModel.userType == "admin")
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'All books:',
                            style: Styles.title2,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateScale(context, const ViewAllBooks());
                            },
                            child: Hero(
                              tag: 'viewAllBooks',
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0.w, vertical: 6.5),
                                  child: Text(
                                    'View all',
                                    style: Styles.smallText2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horGap(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                availabilityForUser = !availabilityForUser;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0.w, vertical: 3.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    availabilityForUser
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.black54,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.black54,
                                          ),
                                    Text(
                                      'Available only',
                                      style: GoogleFonts.lora(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              isShimmer
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: HomeBooksShimmer(
                          color: Colors.amber.shade100,
                          itemCount: ap.userModel.userType == "user" ? 8 : 4,
                        ),
                      ),
                    )
                  : searchBooksForUser.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: RefreshIndicator(
                              onRefresh: () {
                                return getBooksFuture()
                                    .then(
                                      (value) => setState(
                                        () {
                                          isShimmer = true;
                                          if (value.isNotEmpty) {
                                            value.sort((a, b) => b.addedTime
                                                .compareTo(a.addedTime));
                                            allBooksAdmin = value;
                                            allBooksUser = value;
                                            noBooks = false;
                                            _controller.text = '';
                                            isSearchVisible = false;
                                            availabilityForUser = false;
                                          } else {
                                            noBooks = true;
                                            _controller.text = '';
                                            isSearchVisible = false;
                                            availabilityForUser = false;
                                          }
                                        },
                                      ),
                                    )
                                    .then((value) => Future.delayed(
                                                const Duration(seconds: 1))
                                            .then(
                                          (value) => setState(
                                            () {
                                              isShimmer = false;
                                            },
                                          ),
                                        ));
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.only(bottom: 10.h),
                                itemCount: searchBooksForUser.length,
                                itemBuilder: (context, index) {
                                  var book = searchBooksForUser[index];
                                  debugPrint(
                                      "this is reference of book ${book.bookReference.toString()}");
                                  return GestureDetector(
                                    onTap: (ap.userModel.userType == "user")
                                        ? null
                                        : () {
                                            navigateSlide(
                                              context,
                                              ViewbookFromHome(
                                                bookName: book.bookName,
                                                bookReference:
                                                    book.bookReference!,
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
                                      numberOfBooks: book.numberOfBooks,
                                      isAdmin: ap.userModel.userType == "user"
                                          ? false
                                          : true,
                                      color: const Color.fromARGB(
                                          255, 255, 241, 240),
                                      description: book.description!,
                                      isAvailable: book.isAvailable!,
                                      bookName: book.bookName,
                                      writerName: book.writerName,
                                      bookId: book.bookId!.toString(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : emptyList(content: "No book found!"),
            ],
          ),
        ),
      ),
    );
  }
}
