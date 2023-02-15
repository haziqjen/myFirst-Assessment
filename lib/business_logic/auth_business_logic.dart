import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:map_exam/core/constant.dart';
import 'package:map_exam/presentation/home_screen.dart';


enum AuthStatus {
  AUTHENTICATED,
  UNAUTHENTICATED
}

class AuthLogic {
  static final AuthLogic _singleton = AuthLogic.instances();

  factory AuthLogic() {
    return _singleton;
  }

  AuthLogic.instances();

  late String userId;
  late String userEmail;
  AuthStatus authStatus = AuthStatus.UNAUTHENTICATED;

  String get getUid => userId;

  String get getUsername => userEmail;

  AuthStatus get getAuthStatus => authStatus;

  Future<void> loginUser(
      {required PreLoginItem preLoginItem,
      required BuildContext context}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: preLoginItem.email,
        password: preLoginItem.password,
      );

      userId = credential.user?.uid ?? '';
      userEmail = credential.user?.email ?? '';

      if (kDebugMode) {
        print('Login success | Email : $userEmail | UID: $userId');
      }

      authStatus = AuthStatus.AUTHENTICATED;

      showCustomSnackBar(context: context, content: 'Login Success');

      Navigator.pushReplacement(context, HomeScreen.route());
    } on FirebaseAuthException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.code == 'user-not-found') {
        errorMessage = "No user found for that email";

        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (error.code == 'wrong-password') {
        errorMessage = "Wrong password. Please enter correct password";

        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }

      authStatus = AuthStatus.UNAUTHENTICATED;

      showCustomSnackBar(context: context, content: errorMessage, isError: true);

      throw Exception(errorMessage);
    }
  }
}

class PreLoginItem {
  String email;
  String password;

  PreLoginItem({required this.email, required this.password});
}
