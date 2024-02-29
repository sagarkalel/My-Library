import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_library/model/sub_book_model.dart';

class UserModel {
  String name;
  String userType;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  // List<SubBookModel>? subBook;

  UserModel({
    required this.name,
    required this.userType,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    // this.subBook,
  });

//from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      userType: map['userType'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      // subBook: map['subBook'] != null
      //     ? List<SubBookModel>.from(
      //         map['subBook'].map((subBook) => SubBookModel.fromMap(subBook)))
      //     : [],
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userType": userType,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "uid": uid,
      // "subBook": subBook,
    };
  }
}

Stream<List<UserModel>> getUsers() {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  return usersCollection.snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>),
            )
            .toList(),
      );
}

Future<List<UserModel>> getUsersFuture() async {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  try {
    QuerySnapshot querySnapshot = await usersCollection.get();

    List<UserModel> usersList = querySnapshot.docs
        .map(
          (doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();

    return usersList;
  } catch (e) {
    // Handle any errors that might occur during the database operation
    debugPrint('Error while fetching users: $e');
    return [];
  }
}

Future<List<UserModel>> getAllUsers() async {
  List<UserModel> users = [];

  try {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await usersCollection.get();

    querySnapshot.docs.forEach((doc) {
      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      users.add(user);
    });

    return users;
  } catch (e) {
    debugPrint('Error getting users: $e');
    return [];
  }
}

Stream<List<SubBookModel>> getSubBooksForUser(DocumentReference userRef) {
  return userRef.collection('subBooks').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (doc) => SubBookModel.fromMap(doc.data()),
            )
            .toList(),
      );
}

Future<UserModel?> getUserFromBookReference(
    DocumentReference<Object?> bookReference) async {
  try {
    // Query the subBook collection to find the document with the given bookReference
    QuerySnapshot<Object?> subBookSnapshot = await bookReference
        .collection('subBooks')
        .where('bookReference', isEqualTo: bookReference.path)
        .limit(1)
        .get();

    if (subBookSnapshot.docs.isEmpty) {
      return null;
    }

    DocumentReference<Object?> userReference = subBookSnapshot
        .docs[0].reference.parent.parent as DocumentReference<Object?>;

    DocumentSnapshot<Object?> userSnapshot = await userReference.get();

    // Create and return the UserModel instance from the user's document data
    UserModel user =
        UserModel.fromMap(userSnapshot.data()! as Map<String, dynamic>);
    return user;
  } catch (e) {
    debugPrint("Error getting user document: $e");
    return null;
  }
}

Future<UserModel?> getUserByBookReference(
    DocumentReference bookReference) async {
  try {
    // Use the collectionGroup method to query the subBooks collection across all users.
    QuerySnapshot subBooksSnapshot = await FirebaseFirestore.instance
        .collectionGroup('subBooks')
        .where('bookReference', isEqualTo: bookReference)
        .limit(1) // Limit the query to retrieve only one sub-book document.
        .get();

    // Check if the query returned any sub-book documents
    if (subBooksSnapshot.docs.isNotEmpty) {
      // Get the reference to the parent user document
      DocumentReference<Map<String, dynamic>>? userRef =
          subBooksSnapshot.docs[0].reference.parent.parent;

      // Get the user document snapshot
      DocumentSnapshot userSnapshot = await userRef!.get();

      // If the user document exists, create a UserModel object and return it
      if (userSnapshot.exists) {
        UserModel user =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        return user;
      }
    }

    return null; // Return null if no user found for the given bookReference.
  } catch (e) {
    debugPrint('Error fetching user: $e');
    return null; // Return null in case of an error.
  }
}

Future<UserModel?> getUserModelByUid(String uid) async {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  try {
    DocumentSnapshot<Object?> userSnapshot =
        await usersCollection.doc(uid).get();

    if (userSnapshot.exists) {
      // Cast the DocumentSnapshot<Object?> to DocumentSnapshot<Map<String, dynamic>>
      final userMap = userSnapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(userMap);
    } else {
      // If the user document doesn't exist, return null or handle it as required
      return null;
    }
  } catch (e) {
    // Handle any errors that might occur during the process
    debugPrint('Error getting user document: $e');
    return null;
  }
}
