
import 'package:file_manager/home/screens/folder_screen.dart';
import 'package:file_manager/permission/screen/permission_screen.dart';
import 'package:file_manager/sign_up/screen/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/firebase_constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  late Rx<GoogleSignInAccount?> googleSignInAccount;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(auth.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);

    googleSignInAccount.bindStream(googleSign.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Sinup Screen
      Get.offAll(() => const SignUpScreen());
    } else {
      Get.offAll(() => const PermissionScreen(first: false));
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {
      Get.offAll(() => const SignUpScreen());
    } else {
      Get.offAll(() => const Folder(
            path: '',
            title: '',
          ));
    }
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSign.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth.signInWithCredential(credential);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void register() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar("Error", e.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.black);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.black);
    }
  }

  void login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar("Error", e.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.black);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.black);
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
