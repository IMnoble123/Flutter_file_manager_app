import 'package:file_manager/core/services/theme_services.dart';
import 'package:file_manager/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 20, color: ThemeConfig.primary),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading:
                Icon(Icons.brightness_2_rounded, color: ThemeConfig.darkBg),
            title: const Text('Dark mode',
                style: TextStyle(color: Colors.black, fontSize: 12)),
            trailing: TextButton(
                onPressed: () {
                  ThemeService().switchTheme();
                },
                child: const Text(
                  'Swith',
                  style: TextStyle(color: Colors.blue),
                )),
          )
        ],
      ),
    );
  }
}
