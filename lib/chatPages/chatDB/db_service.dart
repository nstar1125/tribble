import 'package:cloud_firestore/cloud_firestore.dart';

class DB {
  final String? uid;
  DB({this.uid});

  //ref 유저 컬렉션
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future updateUserDate(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }
}
