import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';

class AddGridImageList extends StatefulWidget {

  final List<ImageBean> _images;
  final Function() _onAddImage;
  AddGridImageList(this._images, this._onAddImage, {Key key}) : super(key: key);

  @override
  _State createState() => _State(_images, _onAddImage);
}

class _State extends State<AddGridImageList> {

  final List<ImageBean> _images;
  final Function() _onAddImage;
  _State(this._images, this._onAddImage);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: getImageSize(),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Container(
                  color: Colors.grey,
                  child: Icon(
                    Icons.add_a_photo,
                    size: 48,
                  ),
                ),
              ),
              onTap: _onAddImage,
            );
          } else {
            return getRow(index);
          }
        });
  }

  getRow(int index) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: _images[index].path != null
            ? Image.file(File(_images[index].path), fit: BoxFit.cover)
            : Image.network(_images[index].url, fit: BoxFit.cover)
    );
  }

  int getImageSize() {
    int size = _images.length + 1;
    if (size > 9) {
      size = 9;
    }
    return size;
  }
}
