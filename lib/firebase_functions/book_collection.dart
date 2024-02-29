import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_library/model/book_model.dart';

Stream<List<BookModel>> streamBooks() {
  return FirebaseFirestore.instance.collection('books').snapshots().map(
    (querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Timestamp addedTime = doc.data()['addedTime'];
        DateTime dateTime = addedTime.toDate();

        return BookModel(
          // bookId: doc.id,
          description: doc.data()['description'],
          addedTime: dateTime,
          bookId: doc.data()['bookId'],
          bookName: doc.data()['bookName'],
          writerName: doc.data()['writerName'],
          isAvailable: doc.data()['isAvailable'],
          bookReference: doc.reference,
          // Map more properties here if needed
        );
      }).toList();
    },
  );
}

Stream<List<BookModel>> streamBooksUpdated() {
  return FirebaseFirestore.instance.collection('books').snapshots().map(
    (querySnapshot) {
      return querySnapshot.docs.map((doc) {
        // Map the Firestore document data to a BookModel using the fromMap method
        return BookModel.fromMap(doc.data());
      }).toList();
    },
  );
}

Future<List<BookModel>> getBooksFuture() async {
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  try {
    QuerySnapshot querySnapshot = await booksCollection.get();

    List<BookModel> booksList = querySnapshot.docs
        .map(
          (doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();

    return booksList;
  } catch (e) {
    // Handle any errors that might occur during the database operation
    debugPrint('Error while fetching books: $e');
    return [];
  }
}
