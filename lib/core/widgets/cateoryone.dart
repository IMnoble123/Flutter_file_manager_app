import 'dart:io';
import 'package:file_manager/core/constants/file_constants.dart';
import 'package:file_manager/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import '../constants/constants.dart';
import 'file_icon.dart';

//Category with Thumbnail
class CategoryOne extends StatefulWidget {
  final String title;
  const CategoryOne({super.key, required this.title});

  @override
  State<CategoryOne> createState() => _CategoryOneState();
}

class _CategoryOneState extends State<CategoryOne> {
  final HomeController controller = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      switch (widget.title.toLowerCase()) {
        case 'images':
          controller.getImages('image');
          break;
        case 'video':
          controller.getImages('video');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (homeController) {
      if (homeController.loading) {
        return const Scaffold(body: CircularProgressIndicator());
      }
      return DefaultTabController(
        length: homeController.imageTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(
              indicatorColor: Theme.of(context).colorScheme.secondary,
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodySmall!.color,
              isScrollable: homeController.imageTabs.length < 3 ? false : true,
              tabs: Constants.map<Widget>(
                homeController.imageTabs,
                (index, label) {
                  return Tab(text: '$label');
                },
              ),
              onTap: (val) => homeController.switchCurrentFiles(
                  homeController.images, homeController.imageTabs[val]),
            ),
          ),
          body: Visibility(
            visible: homeController.images.isNotEmpty,
            replacement: const Center(child: Text('No Files Found')),
            child: TabBarView(
              children: Constants.map<Widget>(
                homeController.imageTabs,
                (index, label) {
                  List l = homeController.currentFiles;

                  return CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(10.0),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          crossAxisCount: 2,
                          children: Constants.map(
                            index == 0 ? homeController.images : l.reversed.toList(),
                            (index, item) {
                              File file = File(item.path);
                              String path = file.path;
                              String mimeType = mime(path) ?? '';
                              return _MediaTile(file: file, mimeType: mimeType);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _MediaTile extends StatelessWidget {
  final File file;
  final String mimeType;

  const _MediaTile({required this.file, required this.mimeType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => OpenFile.open(file.path),
      child: GridTile(
        header: Container(
          height: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: mimeType.split('/')[0] == 'video'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          FileConstants.formatBytes(file.lengthSync(), 1),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    )
                  : Text(
                      FileConstants.formatBytes(file.lengthSync(), 1),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ),
        child: mimeType.split('/')[0] == 'video'
            ? FileIcon(file: file)
            : Image(
                fit: BoxFit.cover,
                errorBuilder: (b, o, c) {
                  return const Icon(Icons.image);
                },
                image: ResizeImage(
                  FileImage(File(file.path)),
                  width: 150,
                  height: 150,
                ),
              ),
      ),
    );
  }
}
