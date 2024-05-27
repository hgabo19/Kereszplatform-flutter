import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');
  // create
  Future<void> addExpense(
      String date, String cost, String person, String imgUrl, String location) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return expenses.add({
        'date': date,
        'cost': cost,
        'person': person,
        'imgUrl': imgUrl,
        'location': location,
        'userID': user.uid,
      });
    } else {
      throw Exception('Log in first');
    }
  }

  // read
  Stream<QuerySnapshot> getExpensesStream() {
    User? user = FirebaseAuth.instance.currentUser;
    final expensesStream =
        expenses.where('userID', isEqualTo: user?.uid).snapshots();
    return expensesStream;
  }

  // delete

  Future<void> deleteExpense(String docID) async {
    try {
      await expenses.doc(docID).delete();
    } catch (e) {
      print('Error deleting expense:$e');
    }
  }
}
