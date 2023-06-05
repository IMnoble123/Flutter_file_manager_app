import 'dart:io';

import 'package:file_manager/core/constants/file_constants.dart';
import 'package:flutter/material.dart';
import '../constants/dialog_constants.dart';
import '../constants/fonthelper_constant.dart';
import '../constants/iconfont_constant.dart';
import 'custom_alert.dart';

class DecompressArchiveDialog extends StatefulWidget {
  final String path;
  final String parent;
  const DecompressArchiveDialog(
      {super.key, required this.path, required this.parent});

  @override
  State<DecompressArchiveDialog> createState() =>
      _DecompressArchiveDialogState();
}

class _DecompressArchiveDialogState extends State<DecompressArchiveDialog> {
  final TextEditingController outputDir = TextEditingController();
  bool loading = FileConstants.decompressing;

  @override
  Widget build(BuildContext context) {
    outputDir.text = widget.parent;
    return CustomAlert(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Decompress Archive',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            IconFont(
              iconName: IconFontHelper.archive,
              color: Colors.purple[700],
              size: 25,
            ),
            const SizedBox(height: 10),
            Text(
              widget.path.split('/').last,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            // ,
            const SizedBox(height: 25),
            const Text(
              'Output Directory:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: outputDir,
              keyboardType: TextInputType.text,
              cursorColor: Colors.white,
            ),
            const SizedBox(height: 20),
            loading ? const CircularProgressIndicator() : const SizedBox(),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                          color:Colors.black,
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
                      if (!loading) {
                        loading = true;
                        setState(() {});
                        if (!Directory(outputDir.text).existsSync()) {
                          await Directory(outputDir.text)
                              .create()
                              .catchError((e) {
                            if (e.toString().contains('Permission denied')) {
                              Dialogs.showToast(
                                  'Cannot write to this Storage  device!');
                            }
                          });
                        }
                        await FileConstants.extractArchive(
                                widget.path, outputDir.text)
                            .then((value) => {
                                  if (value == true)
                                    {
                                      Navigator.pop(context),
                                      Dialogs.showToast(
                                          'Archive decompressed Successfully'),
                                    }
                                });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Decompress',
                      style: TextStyle(color: Colors.black),
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