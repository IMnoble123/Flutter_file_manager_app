import 'package:flutter/material.dart';

import '../widgets/cateoryone.dart';
import 'fonthelper_constant.dart';

class Constants {
  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  static List categories = [
    {
      'title': 'Images',
      'icon': IconFontHelper.img,
      'path': '',
      'color': Colors.teal,
      'screen': const CategoryOne(
        title: 'Images',
      ),
    },
    {
      'title': 'Videos',
      'icon': IconFontHelper.video,
      'path': '',
      'color': Colors.red,
      'screen': const CategoryOne(
        title: 'Video',
      ),
    },
  ];

  static List sortList = [
    'File name (A to Z)',
    'File name (Z to A)',
    'Date (oldest first)',
    'Date (newest first)',
    'Size (largest first)',
    'Size (Smallest first)',
  ];
}