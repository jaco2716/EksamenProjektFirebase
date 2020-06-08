import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("User Logged in: " + result.user.email);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result.user;
    } catch (e) {
      // throw the Firebase AuthException that we caught
      throw new AuthException(e.code, e.message);
    }
  }

  // wrappinhg the firebase calls
  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    var u = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await _firestore.collection('users').document(u.user.uid).setData({
      'uid': u.user.uid,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
    });

    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = "$firstName $lastName";
    return await u.user.updateProfile(info);
  }
}
