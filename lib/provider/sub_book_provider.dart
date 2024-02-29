import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/sub_book_model.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addSubBookDocumentUpdated(
      DocumentReference<Object?> userReference,
      SubBookModel subBookModel) async {
    try {
      // Get a reference to the "subBooks" subcollection under the user's collection
      CollectionReference<Object?> subBooksCollection =
          userReference.collection('subBooks');

      // Convert the SubBookModel to a map using the toMap() method
      Map<String, dynamic> subBookData = subBookModel.toMap();

      // Add the document to the "subBooks" subcollection
      await subBooksCollection.add(subBookData);
    } catch (e) {
      // Handle any errors that occur during the process
      debugPrint('Error adding subcollection document: $e');
    }
  }

  Future<int> getSubBooksTotalCountUnderUser(
      DocumentReference<Object?> userReference) async {
    try {
      // Get a reference to the "subBooks" subcollection under the user's collection
      CollectionReference<Object?> subBooksCollection =
          userReference.collection('subBooks');

      // Query the subBooksCollection and get the documents
      QuerySnapshot<Object?> querySnapshot = await subBooksCollection.get();

      // Return the number of documents in the subcollection
      return querySnapshot.size;
    } catch (e) {
      // Handle any errors that occur during the process
      debugPrint('Error getting subBooks count: $e');
      return 0; // Return 0 if an error occurs
    }
  }

  Future<int> getSubBooksCurrentCountUnderUser(
      DocumentReference<Object?> userReference) async {
    try {
      // Get a reference to the "subBooks" subcollection under the user's collection
      CollectionReference<Object?> subBooksCollection =
          userReference.collection('subBooks');

      // Query the subBooksCollection and get the documents
      QuerySnapshot<Object?> querySnapshot =
          await subBooksCollection.where("status", isEqualTo: true).get();

      return querySnapshot.size;
    } catch (e) {
      debugPrint('Error getting subBooks count: $e');
      return 0; // Return 0 if an error occurs
    }
  }

  Future<List<SubBookModel>> getSubCollectionDocuments(
      DocumentReference<Object?> userReference) async {
    try {
      QuerySnapshot<Object?> subCollectionSnapshot =
          await userReference.collection('subBooks').get();
      List<SubBookModel> subCollectionDocuments =
          subCollectionSnapshot.docs.map((DocumentSnapshot<Object?> doc) {
        return SubBookModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return subCollectionDocuments;
    } catch (e) {
      debugPrint('Error retrieving subcollection documents: $e');
      return [];
    }
  }

  Future<void> updateSubBookFormId(
      int bookId, DateTime toDate, bool status, String uid) async {
    // Get a reference to the subBooks collection
    CollectionReference subBooksCollection =
        _usersCollection.doc(uid).collection('subBooks');

    try {
      // Query for the specific document based on the bookId
      QuerySnapshot querySnapshot = await subBooksCollection
          .where('bookId', isEqualTo: bookId)
          .where('status', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference of the first matching document
        DocumentReference subBookDocument = querySnapshot.docs[0].reference;
        debugPrint('subBookDocument ${subBookDocument.id} id is this');
        // Update the specific fields
        await subBookDocument.update({
          'toDate': Timestamp.fromDate(toDate),
          'status': status,
        });
      } else {
        // Handle the case where the document with the specified bookId is not found
        debugPrint('Document with bookId $bookId not found.');
      }
    } catch (e) {
      // Handle any errors that occur during the update process
      debugPrint('Error updating subBook: $e');
    }
  }

  Future<List<SubBookModel>> getSubBooksByBookReference(
      DocumentReference<Object?> bookReference) async {
    try {
      List<SubBookModel> subBooks = [];

      // Use collectionGroup to query the subBooks collection across all users
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('subBooks')
          .where('bookReference', isEqualTo: bookReference)
          .get();

      // Loop through the documents and convert them to SubBookModel objects
      for (var doc in querySnapshot.docs) {
        SubBookModel subBook =
            SubBookModel.fromMap(doc.data() as Map<String, dynamic>);
        subBooks.add(subBook);
      }

      return subBooks;
    } catch (e) {
      // Handle any errors that might occur during the query or conversion
      debugPrint('Error getting subBooks: $e');
      return [];
    }
  }

  Future<List<SubBookModel>> getSubBooksForUser(String uid) async {
    List<SubBookModel> subBooks = [];

    try {
      final DocumentReference userDocRef = _usersCollection.doc(uid);

      // Get the sub-collection reference for 'subBooks' under the user document
      final CollectionReference subBooksCollection =
          userDocRef.collection('subBooks');

      // Get all the documents in the sub-collection
      QuerySnapshot querySnapshot = await subBooksCollection.get();

      // Loop through each document and convert it to SubBookModel
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String,
            dynamic>?; // Convert Object? to Map<String, dynamic>?
        if (data != null) {
          SubBookModel subBook = SubBookModel.fromMap(data);
          subBooks.add(subBook);
        }
      }

      return subBooks;
    } catch (e) {
      debugPrint('Error getting subBooks: $e');
      return [];
    }
  }
}
