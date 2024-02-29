import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/model/book_model.dart';
import 'package:my_library/model/user_provider.dart';
import 'package:my_library/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  BookModel? _bookModel;
  BookModel get bookModel => _bookModel!;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<BookModel> _listBookModel = [];
  List<BookModel> get listBookModel => _listBookModel;
  set listBookModel(List<BookModel> _value) {
    _listBookModel = _value;
    prefs.setStringList(
        "listBookModel", _value.map((x) => x.toString()).toList());
  }

  void saveBookDataToFirebase({
    required BuildContext context,
    required BookModel bookModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseFirestore
          .collection("books")
          .add(bookModel.toMap())
          .then((value) => {
                onSuccess(),
                _isLoading = false,
                notifyListeners(),
              });
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.message.toString());
    }
  }

//new function for adding books
  void addBookDataRefToFirebase({
    required BuildContext context,
    required BookModel bookModel,
    required Function(DocumentReference bookReference) onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference newBookDocRef =
          await _firebaseFirestore.collection("books").add(bookModel.toMap());

      // Set the bookReference in the bookModel instance
      bookModel.bookReference = newBookDocRef;

      // Update the document with the bookReference field
      await newBookDocRef.update({'bookReference': newBookDocRef});

      onSuccess(newBookDocRef);

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.message.toString());
    }
  }

//get book data from firebase
  Future<List<BookModel>> fetchBooks() async {
    List<BookModel> books = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('books').get();

    snapshot.docs.forEach((doc) {
      BookModel book = BookModel(
        bookName: doc.data()['bookName'],
        writerName: doc.data()['writerName'],
        bookId: doc.data()['bookId'],
        isAvailable: doc.data()['isAvailable'],
        addedTime: (doc.data()['addedTime'] as Timestamp).toDate(),
      );

      books.add(book);
    });

    return books;
  }

  //optimized code of fetch books
  Future<List<BookModel>> fetchBooksNew() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('books').get();

    return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
  }

  //update book availabilty
  void updateBookAvailability(
      DocumentReference bookReference, bool isAvailable) {
    bookReference.update({
      'isAvailable': isAvailable,
    }).then((value) {
      debugPrint('Book availability updated successfully.');
    }).catchError((error) {
      debugPrint('Failed to update book availability: $error');
    });
  }

  //update book availabilty
  void updateBookAvailabilityByNumberOfBooksPlus(
      DocumentReference bookReference, int numberOfBooks) {
    bookReference.update({
      'isAvailable': true,
      'numberOfBooks': numberOfBooks + 1,
    }).then((value) {
      debugPrint('Book availability updated successfully.');
    }).catchError((error) {
      debugPrint('Failed to update book availability: $error');
    });
  }

  //update book availability by numberOfBooks
  void updateBookAvailabilityByNumberOfBooks(
      DocumentReference bookReference, int numberOfBooks) {
    if (numberOfBooks >= 2) {
      bookReference.update({
        'isAvailable': true,
        'numberOfBooks': numberOfBooks - 1,
      }).then((value) {
        debugPrint('Book availability updated successfully.');
      }).catchError((error) {
        debugPrint('Failed to update book availability: $error');
      });
    } else {
      bookReference.update({
        'isAvailable': false,
        'numberOfBooks': numberOfBooks - 1,
      }).then((value) {
        debugPrint('Book availability updated successfully.');
      }).catchError((error) {
        debugPrint('Failed to update book availability: $error');
      });
    }
  }

  Future<bool> checkBookAvailability(DocumentReference bookReference) async {
    try {
      DocumentSnapshot bookSnapshot = await bookReference.get();
      bool isAvailable = bookSnapshot.get('isAvailable') ?? false;
      return isAvailable;
    } catch (error) {
      debugPrint('Error while checking book availability: $error');
      return false; // Return false in case of an error
    }
  }

  Future<bool> checkBookAvailabilityInt(DocumentReference bookReference) async {
    try {
      DocumentSnapshot bookSnapshot = await bookReference.get();
      int numberOfBooks = bookSnapshot.get('numberOfBooks') ?? 1;
      bool isAvailable = numberOfBooks >= 1;

      return isAvailable;
    } catch (error) {
      debugPrint('Error while checking book availability: $error');
      return false; // Return false in case of an error
    }
  }

  Future<int> checkBookAvailabilityIntReturn(
      DocumentReference bookReference) async {
    try {
      DocumentSnapshot bookSnapshot = await bookReference.get();
      int numberOfBooks = bookSnapshot.get('numberOfBooks') ?? 1;

      return numberOfBooks;
    } catch (error) {
      debugPrint('Error while checking book availability: $error');
      return 0; // Return false in case of an error
    }
  }

  Future<bool> doesBookExist(DocumentReference bookReference) async {
    try {
      DocumentSnapshot bookSnapshot = await bookReference.get();
      return bookSnapshot.exists;
    } catch (error) {
      debugPrint('Error while checking book existence: $error');
      return false;
    }
  }
}
