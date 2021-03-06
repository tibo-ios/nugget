import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/utils/credentials.dart';

class FirebaseRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  bool get online => _auth.currentUser() != null;

  Stream<FirebaseUser> get authStream => _auth.onAuthStateChanged;

  Future<FirebaseUser> signIn() {
    return _auth.signInWithEmailAndPassword(
        email: Credentials.EMAIL, password: Credentials.PASSWORD);
  }

  void signOut() {
    _auth.signOut();
  }

  Stream<QuerySnapshot> getEntriesStream(String name) {
    return _firestore
        .collection('users')
        .document(name)
        .collection('data')
        .orderBy('date', descending: true)
        .snapshots();
  }

  void deleteDocument(DataEntry entry) {
    _firestore
        .collection('users')
        .document(entry.name.toLowerCase())
        .collection('data')
        .document(entry.docId)
        .delete();
  }

  addDocument(DataEntry entry) async {
    DocumentReference ref = await _firestore
        .collection('users')
        .document(entry.name.toLowerCase())
        .collection('data')
        .add(DataEntry.toMap(entry));

    entry.docId = ref.documentID;
  }
}
