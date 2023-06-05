import 'dart:async';
import 'package:file_manager/home/screens/folder_screen.dart';
import 'package:file_manager/sign_up/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/dialogs.dart';

class PermissionScreen extends StatefulWidget {
  final bool first;
  const PermissionScreen({super.key, required this.first});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    handleTimeout();
    super.initState();
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      requestPermission();
    } else {
      if (!mounted) return;
      if (!widget.first) {
        Get.offAll(() => const Folder(
              path: '',
              title: '',
            ));
      } else {
        Get.offAll(() => const SignUpScreen());
      }
    }
  }

  requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      if (!mounted) return;
      if (!widget.first) {
        Get.offAll(() => const Folder(
              path: '',
              title: '',
            ));
      } else {
        Get.offAll(() => const SignUpScreen());
      }
    } else {
      Dialogs.showToast('Please Grant Storage Permissions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'assets/images/file_manage.png',
              ),
              height: 50,
              width: 50,
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
