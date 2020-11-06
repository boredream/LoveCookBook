import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageBrowserPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ImageBrowserPage> {

  List<ImageBean> _images;
  int _index;

  @override
  Widget build(BuildContext context) {
    if (_images == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _index = args["index"];
      _images = args["images"];
    }

    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: PageController(initialPage: _index),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: ImageHelper.getImageProvider(_images[index]),
              heroAttributes: PhotoViewHeroAttributes(tag: _images[index]),
              onTapUp: (context, details, controllerValue) {
               Navigator.pop(context);
              },
            );
          },
          itemCount: _images.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
          // backgroundDecoration: widget.backgroundDecoration,
          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        )
    );
  }
}
