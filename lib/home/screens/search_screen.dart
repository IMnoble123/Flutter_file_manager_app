import 'dart:io';
import 'package:file_manager/core/constants/file_constants.dart';
import 'package:file_manager/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/directory_item.dart';
import '../../core/widgets/file_item.dart';
import 'folder_screen.dart';

class Search extends SearchDelegate {
  final ThemeData themeData;

  Search({
    Key? key,
    required this.themeData,
  });

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = themeData;
  //   return theme.copyWith(
  //     primaryTextTheme: Theme.of(context).primaryTextTheme,
  //     textTheme: Theme.of(context).textTheme.copyWith(
  //           headline1: Theme.of(context).textTheme.headline1!.copyWith(
  //                 color: Theme.of(context).primaryTextTheme.headline6!.color,
  //               ),
  //         ),
  //     // inputDecorationTheme: InputDecorationTheme(
  //     //   hintStyle: TextStyle(
  //     //     color: theme.primaryTextTheme.headline6!.color,
  //     //   ),
  //     // ),
  //   );
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var hcontroller = Get.put(HomeController());
    return FutureBuilder<List<FileSystemEntity>>(
      future:
          FileConstants.searchFiles(query, showHidden: hcontroller.showHidden),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return const Center(child: Text('No file match your query!'));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                FileSystemEntity file = snapshot.data[index];
                if (file.toString().split(':')[0] == 'Directory') {
                  return DirectoryItem(
                    popTap: null,
                    file: file,
                    tap: () {
                      Get.to(
                        () => Folder(title: 'Storage', path: file.path),
                      );
                    },
                  );
                }
                return FileItem(file: file, popTap: null);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                        width: MediaQuery.of(context).size.width - 70,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var controller = Get.put(HomeController());
    return FutureBuilder<List<FileSystemEntity>>(
      future:
          FileConstants.searchFiles(query, showHidden: controller.showHidden),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return const Center(child: Text('No file match your query!'));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                FileSystemEntity file = snapshot.data[index];
                if (file.toString().split(':')[0] == 'Directory') {
                  return DirectoryItem(
                    popTap: null,
                    file: file,
                    tap: () {
                      Get.to(() => Folder(title: 'Storage', path: file.path));
                    },
                  );
                }
                return FileItem(file: file, popTap: null);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                        width: MediaQuery.of(context).size.width - 70,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
