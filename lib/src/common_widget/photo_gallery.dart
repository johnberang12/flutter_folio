import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'dot_length_indicator.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({Key? key, required this.photoUrls}) : super(key: key);

  final List<dynamic> photoUrls;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black45,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ))),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: const Border(bottom: BorderSide.none),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              itemCount: widget.photoUrls.length,
              builder: ((context, index) => PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      widget.photoUrls[index],
                    ),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  )),
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index) => setState(() => _activeIndex = index),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 32,
              child: _imageIndecator(),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageIndecator() => DotLengthIndicator(
      pageIndex: _activeIndex, length: widget.photoUrls.length);
}
