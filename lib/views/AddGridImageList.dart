import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';

class AddGridImageList extends StatefulWidget {
  final List<ImageBean> _images;
  final Function() _onAddImage;
  final Function(ImageBean) _onRemoveImage;

  AddGridImageList(this._images, this._onAddImage, this._onRemoveImage,
      {Key key})
      : super(key: key);

  @override
  _State createState() => _State(_images, _onAddImage, _onRemoveImage);
}

class _State extends State<AddGridImageList> {
  final List<ImageBean> _images;
  final Function() _onAddImage;
  final Function(ImageBean) _onRemoveImage;

  _State(this._images, this._onAddImage, this._onRemoveImage);

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
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          child: Hero(
            tag: _images[index],
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: ImageHelper.getImage(_images[index])),
          ),
          onTap: () {
            Navigator.pushNamed(context, "imageBrowser",
                arguments: {"index": index, "images": _images});
          },
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
            onTap: () => showConfirmDeleteDialog(_images[index]),
          ),
        ),
      ],
    );
  }

  void showConfirmDeleteDialog(ImageBean image) {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _onRemoveImage(image);
    });
  }

  int getImageSize() {
    int size = _images.length + 1;
    if (size > 9) {
      size = 9;
    }
    return size;
  }
}
