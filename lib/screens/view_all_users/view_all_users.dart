import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/shimmer_loadings/home_books_shimmer.dart';
import 'package:my_library/screens/view_all_users/view_user.dart';
import 'package:my_library/utils/styles.dart';
import 'package:my_library/widgets/components.dart';
import '../all_users/from_book_users_info.dart';
import '../../model/user_provider.dart';

class ViewAllUsers extends StatefulWidget {
  const ViewAllUsers({super.key});

  @override
  State<ViewAllUsers> createState() => _ViewAllUsersState();
}

class _ViewAllUsersState extends State<ViewAllUsers> {
  bool listEmpty = false;
  var allUsers = [];
  bool isSearchVisible = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isShimmer = true;

  @override
  void initState() {
    super.initState();
    getAllUsers().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          allUsers = value.where((user) => user.userType == "user").toList();
          listEmpty = false;
        } else {
          allUsers = value;
          listEmpty = true;
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
    var finalUsers = allUsers
        .where((element) =>
            element.name.toLowerCase().contains(_controller.text.toLowerCase()))
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
              ? Text('All borrowers', style: Styles.title)
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
          tag: 'viewAllButton2',
          child: Padding(
            padding: EdgeInsets.only(
              top: 15.h,
            ),
            child: isShimmer
                ? HomeBooksShimmer(
                    color: Colors.blue.shade200,
                    itemCount: 5,
                  )
                : (finalUsers.isNotEmpty)
                    ? ListView.builder(
                        itemCount: finalUsers.length,
                        itemBuilder: (context, index) {
                          finalUsers.sort(
                              (a, b) => b.createdAt.compareTo(a.createdAt));
                          final user = finalUsers[index];
                          return GestureDetector(
                            onTap: () {
                              navigateSlide(
                                  context,
                                  ViewUser(
                                    uid: user.uid,
                                    phoneNumber: user.phoneNumber,
                                    name: user.name,
                                  ));
                            },
                            child: FromBookUserInfo(
                              name: user.name,
                              uid: user.uid,
                              phoneNumber: user.phoneNumber,
                              profilePic: user.profilePic,
                            ),
                          );
                        })
                    : emptyList(content: "Sorry!, No User found."),
          ),
        ),
      ),
    );
  }
}
