import 'package:file_manager/settings/screen/settings_screen.dart';
import 'package:file_manager/sign_up/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: Column(children: [
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 30,
            ),
            title: const Text('Settings'),
            onTap: () {
              Get.to(() => const SettingScreen());
            },
          ),
          const Divider(
            height: 2,
            thickness: 2,
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                AuthController.instance.signOut();
              },
              child: const Text(
                'LogOut',
                style: TextStyle(color: Colors.red),
              ))
        ]),
      ),
    );
  }
}
