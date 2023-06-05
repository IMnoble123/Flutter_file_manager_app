import 'dart:io';
import 'package:file_manager/core/constants/file_constants.dart';
import 'package:file_manager/core/themes/app_theme.dart';
import 'package:file_manager/core/widgets/folder_drawer.dart';
import 'package:file_manager/home/controller/home_controller.dart';
import 'package:file_manager/home/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path_lib;

import '../../core/constants/dialog_constants.dart';
import '../../core/widgets/achive_dialog.dart';
import '../../core/widgets/addfile_dialog.dart';
import '../../core/widgets/directory_item.dart';
import '../../core/widgets/file_item.dart';
import '../../core/widgets/path_bar.dart';
import '../../core/widgets/rename_dialog.dart';

class Folder extends StatefulWidget {
  final String title;
  final String path;

  const Folder({
    Key? key,
    required this.title,
    required this.path,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> with WidgetsBindingObserver {
  final HomeController controller = Get.put(HomeController());
  late String path;
  List<String> paths = <String>[];

  List<FileSystemEntity> files = <FileSystemEntity>[];
  bool showHidden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getFiles();
    }
  }

  getFiles() async {
    try {
      Directory dir = Directory(path);
      List<FileSystemEntity> dirFiles = dir.listSync();
      files.clear();
      showHidden = controller.showHidden;
      setState(() {});
      for (FileSystemEntity file in dirFiles) {
        if (!showHidden) {
          if (!path_lib.basename(file.path).startsWith('.')) {
            files.add(file);
            setState(() {});
          }
        } else {
          files.add(file);
          setState(() {});
        }
      }

      files = FileConstants.sortList(files, controller.sort);
    } catch (e) {
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Permission Denied! cannot access this Directory!');
        navigateBack();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    path = widget.path;
    getFiles();
    paths.add(widget.path);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  navigateBack() {
    paths.removeLast();
    path = paths.last;
    setState(() {});
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (paths.length == 1) {
          return true;
        } else {
          paths.removeLast();
          setState(() {
            path = paths.last;
          });
          getFiles();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title),
              Text(
                path,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: PathBar(
            paths: paths,
            icon: widget.path.toString().contains('emulated')
                ? Icons.smartphone
                : Icons.sd_card,
            onChanged: (index) {
              // print(paths[index]);
              path = paths[index];
              paths.removeRange(index + 1, paths.length);
              setState(() {});
              getFiles();
            },
          ),
          actions:[
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              showSearch(
                context: context,
                delegate: Search(themeData: Theme.of(context)),
              );
            },
            icon: const Icon(Icons.search),
          )
            // IconButton(
            //   onPressed: () async {
            //     await showModalBottomSheet(
            //       context: context,
            //       builder: (context) => const SortSheet(),
            //     );
            //     getFiles();
            //   },
            //   tooltip: 'Sort by',
            //   icon: const Icon(Icons.sort),
            // ),
          ],
        ),
        drawer:const AppDrawer(),
        body: Visibility(
          replacement: const Center(child: Text('There\'s nothing here')),
          visible: files.isNotEmpty,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            itemCount: files.length,
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity file = files[index];
              if (file.toString().split(':')[0] == 'Directory') {
                return DirectoryItem(
                  popTap: (v) async {
                    if (v == 0) {
                      renameDialog(context, file.path, 'dir');
                    } else if (v == 1) {
                      deleteFile(true, file);
                    }
                  },
                  file: file,
                  tap: () {
                    paths.add(file.path);
                    path = file.path;
                    setState(() {});
                    getFiles();
                  },
                );
              }
              return FileItem(
                file: file,
                popTap: (v) async {
                  if (v == 0) {
                    renameDialog(context, file.path, 'file');
                  } else if (v == 1) {
                    deleteFile(false, file);
                  } else if (v == 2) {
                    decompressDialog(context, file.path, file.parent.path);
                  } else if (v == 3) {
                    // print('Share');
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeConfig.secondary,
          onPressed: () => addDialog(context, path),
          tooltip: 'Add Folder',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  deleteFile(bool directory, var file) async {
    try {
      if (directory) {
        await Directory(file.path).delete(recursive: true);
      } else {
        await File(file.path).delete(recursive: true);
      }
      Dialogs.showToast('Delete Successful');
    } catch (e) {
      // print(e.toString());
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Cannot write to this Storage device!');
      }
    }
    getFiles();
  }

  addDialog(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => AddFileDialog(path: path),
    );
    getFiles();
  }

  renameDialog(BuildContext context, String path, String type) async {
    await showDialog(
      context: context,
      builder: (context) => RenameFileDialog(path: path, type: type),
    );
    getFiles();
  }

  decompressDialog(BuildContext context, String path, String parent) async {
    await showDialog(
      context: context,
      builder: (context) => DecompressArchiveDialog(
        path: path,
        parent: parent,
      ),
    );
    getFiles();
  }
}
