import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'dart:io';

class SimpleCrop extends StatefulWidget {
  final File image;
  SimpleCrop({this.image});
  @override
  _SimpleCropState createState() => _SimpleCropState();
}

class _SimpleCropState extends State<SimpleCrop> {
  final cropKey = GlobalKey<ImgCropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '裁剪图片',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          leading: new IconButton(
            icon:
            new Icon(Icons.navigate_before, color: Colors.white, size: 40),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ImgCrop(
            key: cropKey,
            // chipRadius: 100,
            // chipShape: 'rect',
            maximumScale: 3,
            image: FileImage(widget.image),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final crop = cropKey.currentState;
            final File croppedFile = await crop.cropCompleted(widget.image, pictureQuality: 600);
            //showImage(context, croppedFile);
            Navigator.pop(context,croppedFile);
          },
          tooltip: 'Increment',
          child: Text('Crop'),
        ));
  }
}