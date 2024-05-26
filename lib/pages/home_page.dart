import 'package:beadando/pages/add_item_page.dart';
import 'package:beadando/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void navigateToAddItemPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 51, 51),
      appBar: AppBar(
        title: const Text(
          "Kiadásaim",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: firestoreService.getExpensesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List expensesList = snapshot.data!.docs;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: expensesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = expensesList[index];
                        String docID = document.id;
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        String dateText = data['date'] ?? '';
                        String costText = data['cost'] ?? '';
                        String personText = data['person'] ?? '';
                        String imgUrl = data['imgUrl'] ?? '';

                        return ListTile(
                          title: Text(
                            '$costText Ft',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            'Dátum: $dateText \nSzemély: $personText',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          leading: SizedBox(
                            height: 90,
                            width: 90,
                            child: (data.containsKey('imgUrl') &&
                                    (data['imgUrl'] ?? '') != '')
                                ? Image.network(
                                    data['imgUrl'],
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(
                                    width: 90,
                                  ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text("Jelenleg nincsenek kiadásaid.");
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () => navigateToAddItemPage(context),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}
