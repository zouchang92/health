import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerWidget extends StatefulWidget {
  final int maxNum;
  final double size;
  final ValueChanged<List<File>> onValueChange;
  ImagePickerWidget({this.maxNum, this.size, this.onValueChange});
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  final double defaultWidth = 80;
  final int defaultMax = 1;
  final ImagePicker imagePicker = ImagePicker();

  int max;
  double width;
  List<PickedFile> _imageList = [];
  PickedFile imageFile;
  @override
  void initState() {
    super.initState();
    max = widget.maxNum;
    width = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageListwidget = [];
    imageListwidget
        .add(Padding(padding: EdgeInsets.symmetric(vertical: 5.0),child:Text('图片:', style: Theme.of(context).textTheme.subtitle1)));
    if (_imageList.length > 0) {
      // imageListwidget.insert()
      // imageListwidget.add(imageListWrapWidget());
    }
    imageListwidget.add(imageListWrapWidget());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: imageListwidget,
      ),
    );
  }

  Widget imageListWrapWidget() {
    List<Widget> t = [];
    if (_imageList.length > 0) {
      t = _imageList.map((e) => imageItemWidget(e)).toList();
    }
    int tm = max != null ? max : defaultMax;
    if (t.length < tm) {
      t.add(addButton());
    }
    return Wrap(
      children: t,
    );
  }

  Widget imageItemWidget(PickedFile file) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(0xffe4e4e4),
            radius: width != null ? 0.5 * width : 0.5 * defaultWidth,
            backgroundImage: FileImage(File(file.path)),
          ),
          Positioned(
              top: -15,
              right: -15,
              child: IconButton(
                  icon: Icon(Icons.close, color: Color(0xff666666)),
                  onPressed: () {
                    this.setState(() {
                      _imageList.removeWhere((element) => element == file);
                    });
                    List<File> filePaths =
                        _imageList.map((e) => File(e.path)).toList();
                    widget.onValueChange.call(filePaths);
                  })),
        ],
      ),
    );
  }

  Widget addButton() {
    return Container(
      height: width ?? defaultWidth,
      width: width ?? defaultWidth,
      color: Color(0xffe4e4e4),
      child: IconButton(
          icon: Icon(
            Icons.add,
            size: width != null ? 0.6 * width : defaultWidth * 0.6,
            color: Color(0xff999999),
          ),
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (_context) {
                  return CupertinoActionSheet(
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                            child: Text('拍照'),
                            onPressed: () {
                              getCamera();
                            }),
                        CupertinoActionSheetAction(
                          child: Text('从相册取照片'),
                          isDestructiveAction: false,
                          onPressed: () {
                            getGalleryImage();
                          },
                        )
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        isDefaultAction: true,
                      ));
                });
          }),
    );
  }

  Future _permission(PermissionGroup permission) async {
    PermissionStatus _status =
        await PermissionHandler().checkPermissionStatus(permission);
    // print('_status:$_status');
    if (_status != PermissionStatus.granted) {
      // print('_status:$_status');
      await PermissionHandler().openAppSettings();
      // print('tt:$tt');
      // showDialog(context: context,builder: (_context){
      //   return Dialog(

      //   );
      // });
    }
  }

  Future getCamera() async {
    // print('打开了相机');
    try {
      await _permission(PermissionGroup.camera);
      var image = await imagePicker.getImage(source: ImageSource.camera);
      Navigator.of(context).pop();
      if (image != null) {
        this.setState(() {
          _imageList.add(image);
        });
        // widget.onValueChange.call(File(image.path));
        List<File> filePaths = _imageList.map((e) => File(e.path)).toList();
        widget.onValueChange.call(filePaths);
      }
    } catch (exception) {
      print('exception:$exception');
    }
  }

  Future getGalleryImage() async {
    try {
      _permission(PermissionGroup.photos);
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      // print('image:${image.path}');
      Navigator.of(context).pop();
      if (image != null) {
        this.setState(() {
          _imageList.add(image);
        });
        List<File> filePaths = _imageList.map((e) => File(e.path)).toList();
        widget.onValueChange.call(filePaths);
      }
    } catch (exception) {
      print('exception:$exception');
      // Navigator.of(context).pop();
    }
  }
}
