import 'dart:io';

import 'package:flutter/material.dart';
import '../constants/dialog_constants.dart';
import 'custom_alert.dart';

class AddFileDialog extends StatefulWidget {
  final String path;

  const AddFileDialog({super.key, required this.path});

  @override
  State<AddFileDialog> createState() => _AddFileDialogState();
}

class _AddFileDialogState extends State<AddFileDialog> {
  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlert(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 15),
            const Text(
              'Add New Folder',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: name,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                SizedBox(
                  height: 40,
                  width: 130,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (name.text.isNotEmpty) {
                        if (!Directory('${widget.path}/${name.text}')
                            .existsSync()) {
                          await Directory('${widget.path}/${name.text}')
                              .create()
                              .catchError((e) {
                            // print(e.toString());
                            if (e.toString().contains('Permission denied')) {
                              Dialogs.showToast(
                                  'Cannot write to this Storage  device!');
                            }
                          });
                        } else {
                          Dialogs.showToast(
                              'A Folder with that name already exists!');
                        }
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                       Colors.white,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}