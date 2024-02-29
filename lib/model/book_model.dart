import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String bookName;
  String writerName;
  int? bookId;
  bool? isAvailable;
  DateTime addedTime;
  String? description;
  DocumentReference? bookReference;
  int numberOfBooks;

  BookModel({
    required this.bookName,
    required this.writerName,
    this.bookId,
    this.isAvailable,
    required this.addedTime,
    this.description,
    this.bookReference,
    this.numberOfBooks = 1,
  });

  // from map
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      bookName: map['bookName'] ?? '',
      writerName: map['writerName'] ?? '',
      bookId: map['bookId'] as int?,
      numberOfBooks: map['numberOfBooks'] as int,
      isAvailable: map['isAvailable'] as bool?,
      addedTime: map['addedTime'] != null
          ? (map['addedTime'] as Timestamp).toDate()
          : DateTime.now(),
      description: map['description'] ?? '',
      bookReference: map['bookReference'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      "bookName": bookName,
      "writerName": writerName,
      "bookId": bookId,
      "numberOfBooks": numberOfBooks,
      "isAvailable": isAvailable,
      "addedTime": Timestamp.fromDate(addedTime),
      "description": description,
      "bookReference": bookReference, // Include bookReference in the map
    };
  }
}
