import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference users =
  FirebaseFirestore.instance.collection('Users');

  /// FoodukoUser is a custom Class which we made in user.dart
  /// User is a firebase Auth class which comes inbuilt with firebase_auth package.
  FoodukoUser _userFromFirebase(User? user) {
    return FoodukoUser(
      uid: user!.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  /// Returns instance of [FirebaseAuthService] of the currently logged in user
  FirebaseAuthService getCurrentUser() {
    return this;
  }

  /// Returns instance of [FoodukoUser] of the currently logged in user
  FoodukoUser? currentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return _userFromFirebase(user);
    } else {
      return null;
    }
  }

  /// This function is triggered whenever the authentication state changes
  /// That is if a user logs in or logs out
  ///
  /// Returns [FoodukoUser]
  Stream<FoodukoUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  /// A function to Login the user using there Google Account
  /// This method ensures that the email is verified.
  /// The user need not have to SignUp in the application and this is a very easy method of authentication.
  ///
  /// Returns [FoodukoUser]
  Future<FoodukoUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    final user = authResult.user;

    // Add the users document if not already present in the Database

    // users.doc(user!.email).get().then(
    //       (DocumentSnapshot documentSnapshot) async {
    //     if (!documentSnapshot.exists) {
    //       await createFirebaseDocument(user);
    //       Navigator.pushNamed(context, "/setProfile");
    //     } else if (documentSnapshot.get("phone") == null) {
    //       Navigator.pushNamed(context, "/setProfile");
    //     } else {
    //       Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    //       Fluttertoast.showToast(msg: "Sign in successful!");
    //     }
    //   },
    // );

    // Return our custom user object
    return _userFromFirebase(user);
  }

  // Future<FoodukoUser> createUser(BuildContext context, String email,
  //     String password, String displayName) async {
  //   try {
  //     await _firebaseAuth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then(
  //           (result) async {
  //         final user = result.user;
  //         await user!.updateDisplayName(displayName);
  //         await createFirebaseDocument(_firebaseAuth.currentUser!);
  //         Navigator.pushNamed(context, "/setProfile");
  //       },
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       Fluttertoast.showToast(msg: "The password provided is too weak.");
  //     } else if (e.code == 'email-already-in-use') {
  //       Fluttertoast.showToast(
  //           msg: "The account already exists for that email.");
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     Fluttertoast.showToast(msg: "Something went wrong, Try again!");
  //   }
  //   return _userFromFirebase(_firebaseAuth.currentUser);
  // }

  // Future<FoodukoUser> signInWithEmailPassword(
  //     String email, String password) async {
  //   UserCredential? authResult;
  //   try {
  //     authResult = await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       Fluttertoast.showToast(msg: "Email not found, create a new account!");
  //     } else if (e.code == 'wrong-password') {
  //       Fluttertoast.showToast(msg: "Wrong password. Try again!");
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     Fluttertoast.showToast(msg: "Something went wrong, Try again!");
  //   }
  //
  //   return _userFromFirebase(authResult!.user);
  // }

  // Future<void> sendPasswordResetEmail(String email) async {
  //   _firebaseAuth
  //       .sendPasswordResetEmail(email: email)
  //       .then((value) => Fluttertoast.showToast(
  //     msg: "Password Reset link sent to your email!",
  //     backgroundColor: Colors.indigo,
  //     textColor: Colors.white,
  //   ))
  //       .catchError((error) {
  //     if (error.code == 'user-not-found') {
  //       Fluttertoast.showToast(
  //         msg: "Email not found, create a new account!",
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //     } else if (error.code == 'invalid-email') {
  //       Fluttertoast.showToast(
  //         msg: "Invalid email",
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //     }
  //   });
  // }

  Future signOutUser() async {
    return _firebaseAuth.signOut();
  }

  // Future<void> createFirebaseDocument(User user) {
  //   return users
  //       .doc(user.email)
  //       .set({
  //     "name": user.displayName,
  //     "email": user.email,
  //     "phone": user.phoneNumber,
  //     // you can also add default data
  //     "wishlist": [],
  //   })
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  void dispose() {}

}
