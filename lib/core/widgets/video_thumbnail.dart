import 'package:flutter/material.dart';

class VideoThumbnail extends StatelessWidget {
   final String path;
  const VideoThumbnail({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/video-placeholder.png',
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );
  }
}