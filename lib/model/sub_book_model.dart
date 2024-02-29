import 'package:cloud_firestore/cloud_firestore.dart';

class SubBookModel {
  String? bookName;
  String? writerName;
  int? bookId;
  DocumentReference<Object?>? bookReference; // Reference to the "book" document
  bool? status;
  DateTime? fromDate;
  DateTime? toDate;
  String? uid;
  String? userName;

  SubBookModel({
    this.bookName,
    this.bookId,
    this.bookReference,
    this.fromDate,
    this.status,
    this.toDate,
    this.writerName,
    this.uid,
    this.userName,
  });

  // from map
  factory SubBookModel.fromMap(Map<String, dynamic> map) {
    return SubBookModel(
      bookName: map['bookName'] ?? '',
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      writerName: map['writerName'] ?? '',
      bookId: map['bookId'] ?? 0,
      bookReference: map['bookReference'],
      status: map['status'] ?? false,
      fromDate: map['fromDate'] != null
          ? (map['fromDate'] as Timestamp).toDate()
          : null,
      toDate:
          map['toDate'] != null ? (map['toDate'] as Timestamp).toDate() : null,
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "bookName": bookName,
      "userName": userName,
      "uid": uid,
      "writerName": writerName,
      "bookId": bookId,
      "bookReference": bookReference,
      "status": status,
      "fromDate": fromDate != null ? Timestamp.fromDate(fromDate!) : null,
      "toDate": toDate != null ? Timestamp.fromDate(toDate!) : null,
    };
  }
}
