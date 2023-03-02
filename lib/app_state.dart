import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'doctor.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _getDoctorsSubscription;
  List<Doctor> _getDoctors = [];
  List<Doctor> get getDoctors => _getDoctors;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _getDoctorsSubscription = FirebaseFirestore.instance
            .collection('doctors')
            .snapshots()
            .listen((snapshot) {
          _getDoctors = [];
          for (final document in snapshot.docs) {
            _getDoctors.add(
              Doctor(
                name: document.data()['nom'] as String,
                prenom: document.data()['prenom'] as String,
                fonction: document.data()['fonction'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  // Future<DocumentReference> addData(
  //     String amount, String client, String product) {
  //   if (!_loggedIn) {
  //     throw Exception('Must be logged in');
  //   }

  //   return FirebaseFirestore.instance
  //       .collection('products')
  //       .add(<String, dynamic>{
  //     'amount': amount,
  //     'client': client,
  //     'product': product,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     'name': FirebaseAuth.instance.currentUser!.displayName,
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //   });
  // }
}
